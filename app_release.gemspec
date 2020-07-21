lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'app_release/version'

Gem::Specification.new do |spec|
  spec.name          = 'app-release'
  spec.version       = AppRelease::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Anton Sokolov']
  spec.email         = ['anton@sokolov.digital']
  spec.homepage      = 'https://github.com/afuno/app-release'
  spec.licenses      = ['MIT']
  spec.summary       = 'A simple tool for updating the version of a Rails application'
  spec.description   = 'A simple tool for updating the version of a Rails application'

  spec.files         = Dir['bin/**/* lib/**/*']
  spec.require_paths = ['lib']

  spec.executables   = ['app_release']

  spec.add_dependency 'colorize', '~> 0.8.1'
  spec.add_development_dependency 'rubocop', '= 0.88'
end
