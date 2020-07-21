require 'optparse'
require 'yaml'
require 'colorize'

require 'app_release/constants'

module AppRelease
  class Parser
    attr_reader :args, :actions

    DEFAULT_ACTIONS = {
      init: false
    }.freeze

    def self.parse(args)
      new(args).parse
    end

    def initialize(args)
      @args = args
      @actions = DEFAULT_ACTIONS.dup
    end

    def parse
      # puts
      # puts
      # puts @args.inspect
      # puts
      # puts

      parser.parse!(args)

      # @actions
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
          show(AppRelease::VERSION)
          exit
        end

        opts.on('-h', '--help', 'Prints this help') do
          show(opts)
          exit
        end

        opts.on('-major', 'Upgrading the major version') do
          upgrading_version(:major)
        end

        opts.on('-minor', 'Upgrading the minor update') do
          upgrading_version(:minor)
        end

        opts.on('-patch', 'Upgrading the patch update') do
          upgrading_version(:patch)
        end

        # opts.on('-create-git-tag', 'Create git tag') do
        #   create_git_tag
        # end
      end
    end

    def init_version_file
      if file_exists?
        show("File #{AppRelease::Constants::FILE_NAME} has already been created", :yellow)
      else
        create_version_file

        show("File #{AppRelease::Constants::FILE_NAME} was created", :green)
      end
    end

    def upgrading_version(section)
      unless file_exists?
        show(
          "First, you need to create a version file.\nTo do this, run command `bundle exec app_release --init`",
          :red
        )
        exit
      end

      file = current_version_file.dup

      major = file[:major]
      minor = file[:minor]
      patch = file[:patch]

      if !major.positive? && !minor.positive? && !patch.positive?
        show('Something is wrong with the versions', :red)
        exit
      end

      show("Previous version: #{version_formatted_for(file)}", :yellow)

      version_from_section = file[section]

      file[section] = version_from_section + 1

      if section == :major
        file[:minor] = 0
        file[:patch] = 0
      elsif section == :minor
        file[:patch] = 0
      end

      update_version_file_with(file)

      show("New version: #{version_formatted_for(file)}", :green)
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

    # def create_git_tag
    # end

    ############################################################################
    ############################################################################
    ############################################################################

    def show(value, color = nil)
      # puts
      puts value.colorize(color)
      # puts
    end
  end
end
