require 'app_release/console'

module AppRelease
  class Git
    def self.create(version, prefix)
      new(version, prefix).create
    end

    def self.push
      `git push`

      AppRelease::Console.success('git push')
    end

    def initialize(version, prefix = nil)
      @prefix = prefix
      @version = "v#{version}"
    end

    def create
      name = [
        @prefix,
        @version
      ].join('/')

      `git tag #{name}`

      AppRelease::Console.success("Tag #{name} was created")

      # rescue => e
      #   AppRelease::Console.danger(e)
    end
  end
end
