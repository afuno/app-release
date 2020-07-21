require 'optparse'

module AppRelease
  class Parser
    # attr_reader :args, :options

    # Options = Struct.new(:name)

    # DEFAULT_OPTIONS = {
    #   exit: false
    # }.freeze
    #
    # def self.parse(args)
    #   new(args).parse
    # end
    #
    # def initialize(args)
    #   @args = args
    #   @options = DEFAULT_OPTIONS.dup
    # end
    #
    # def parse
    #   puts
    #   puts
    #   puts args.inspect
    #   puts
    #   puts
    #
    #   parser.parse!(args)
    #
    #   options
    # end
    #
    # private
    #
    # def parser
    #   OptionParser.new do |opts|
    #     add_options_to_parser(opts)
    #   end
    # end

    # def self.parse(options)
    #   args = Options.new('world')
    #
    #   opt_parser = OptionParser.new do |opts|
    #     opts.banner = 'Usage:'
    #
    #     opts.on('-nNAME', '--name=NAME', 'Name to say hello to') do |n|
    #       args.name = n
    #     end
    #
    #     opts.on('-h', '--help', 'Prints this help') do
    #       puts opts
    #       exit
    #     end
    #   end
    #
    #   opt_parser.parse!(options)
    #
    #   puts args
    #
    #   args
    # end

    attr_reader :args, :actions

    DEFAULT_ACTIONS = {
      init: false
      # exit: false
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
      end
    end

    def init_version_file
      puts 'init_version_file'

      if File.exist?('./Gemfile')
      end
    end

    def show(value)
      puts
      puts value
      puts
    end
  end
end
