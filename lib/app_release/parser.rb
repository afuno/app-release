require 'optparse'
require 'yaml'

require 'app_release/constants'
require 'app_release/console'
require 'app_release/git'

module AppRelease
  class Parser
    attr_reader :args

    def self.parse(args)
      new(args).parse
    end

    def initialize(args)
      @args = args
    end

    def parse
      parser.parse!(args)
    rescue StandardError => e
      AppRelease::Console.danger("Ambiguously completable string is encountered\n#{e}")
    end

    private

    def parser
      OptionParser.new do |opts|
        opts.banner = 'Usage: app_release [options]'

        opts.on('-i', '--init', 'Creates a version file at the root of the project') do
          init_version_file
          exit
        end

        opts.on('-v', '--version', 'The current version of the gem') do
          AppRelease::Console.log(AppRelease::VERSION)
          exit
        end

        opts.on('-h', '--help', 'Prints this help') do
          AppRelease::Console.log(opts)
          exit
        end

        opts.on('--major', 'Upgrading the major version') do
          upgrading_version(:major)
        end

        opts.on('--minor', 'Upgrading the minor version') do
          upgrading_version(:minor)
        end

        opts.on('--patch', 'Upgrading the patch version') do
          upgrading_version(:patch)
        end

        opts.on('--create-git-tag', 'Create git tag') do
          create_git_tag_with
        end

        opts.on('--create-git-tag-for PREFIX', 'Create git tag with prefix') do |prefix|
          create_git_tag_with(prefix)
        end

        opts.on('--git-push', 'git push') do
          AppRelease::Git.push
        end
      end
    end

    def init_version_file
      if file_exists?
        AppRelease::Console.warning("File #{AppRelease::Constants::FILE_NAME} has already been created")
      else
        create_version_file

        AppRelease::Console.success("File #{AppRelease::Constants::FILE_NAME} was created")
      end
    end

    def upgrading_version(section)
      unless file_exists?
        AppRelease::Console.danger(
          "First, you need to create a version file.\nTo do this, run command `bundle exec app_release --init`"
        )
        exit
      end

      file = current_version_file.dup

      major = file[:major]
      minor = file[:minor]
      patch = file[:patch]

      if !major.positive? && !minor.positive? && !patch.positive?
        AppRelease::Console.danger('Something is wrong with the versions')
        exit
      end

      AppRelease::Console.warning("Previous version: #{version_formatted_for(file)}")

      version_from_section = file[section]

      file[section] = version_from_section + 1

      if section == :major
        file[:minor] = 0
        file[:patch] = 0
      elsif section == :minor
        file[:patch] = 0
      end

      update_version_file_with(file)

      AppRelease::Console.success("New version: #{version_formatted_for(file)}")
    end

    def version_formatted_for(file)
      major = file[:major]
      minor = file[:minor]
      patch = file[:patch]

      [
        major,
        minor,
        patch
      ].join('.')
    end

    def current_version_file
      @current_version_file ||= YAML.load_file(file_path)
    end

    def create_version_file
      write_in_file_with(AppRelease::Constants::INIT_VERSION)
    end

    def update_version_file_with(data)
      write_in_file_with(data)
    end

    def write_in_file_with(data)
      File.open(file_path, 'w') do |file|
        file.write("# Edit this file manually only if you know what you are doing\n\n")
        file.write(data.to_yaml.gsub("---\n", ''))
      end
    end

    def file_exists?
      File.exist?(file_path)
    end

    def file_path
      "#{Dir.pwd}/#{AppRelease::Constants::FILE_NAME}"
    end

    ############################################################################
    ############################################################################
    ############################################################################

    def create_git_tag_with(prefix = nil)
      version = version_formatted_for(current_version_file)
      AppRelease::Git.create(version, prefix)
    end
  end
end
