lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rails_release/version'

Gem::Specification.new do |spec|
  spec.name          = 'rails-release'
  spec.version       = RailsRelease::VERSION
  spec.authors       = ['Anton Sokolov']
  spec.email         = ['anton@sokolov.digital']
  spec.homepage      = 'https://github.com/afuno/rails-release'
  spec.licenses      = ['MIT']
  spec.summary       = 'A simple tool for updating the version of a Rails application'
  spec.description   = 'A simple tool for updating the version of a Rails application'

  spec.files         = Dir.glob('{bin/*,lib/**/*,[A-Z]*}')
  # spec.platform      = Gem::Platform::RUBY
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rubocop', '= 0.88'
end
