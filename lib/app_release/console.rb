require 'colorize'

module AppRelease
  class Console
    def self.print(text, color = nil)
      new(text, color).print
    end

    def self.log(text)
      new(text, nil).print
    end

    def self.success(text)
      new(text, :green).print
    end

    def self.warning(text)
      new(text, :yellow).print
    end

    def self.danger(text)
      new(text, :red).print
    end

    def initialize(text, color = nil)
      @text = text
      @color = color
    end

    def print
      puts @text.colorize(@color)
    end
  end
end
