require 'app_release/console'

module AppRelease
  class Git
    def self.create(version, prefix)
      new(version, prefix).create
    end

    def self.push
      `git push origin --tags`

      AppRelease::Console.success('git push')
    end

    def initialize(version, prefix = nil)
      @prefix = prefix
      @version = "v#{version}"
    end

    def create
      `git tag #{name_formatted}`

      AppRelease::Console.success("Tag #{name_formatted} was created")

      # rescue => e
      #   AppRelease::Console.danger(e)
    end

    private

    def name_formatted
      [
        @prefix,
        @version
      ].join('/')
    end
  end
end
