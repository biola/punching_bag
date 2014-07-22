lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'punching_bag/version'

spec = Gem::Specification.new do |s|
  s.name = 'punching_bag'
  s.version = PunchingBag::VERSION
  s.summary = "PunchingBag hit conter and trending plugin"
  s.description = "PunchingBag is a hit counting and simple trending engine for Ruby on Rails"
  s.files = Dir['MIT-LICENSE', 'app/**/*.rb', 'lib/**/*.rb', 'lib/tasks/*.rake']
  s.test_files = Dir['spec/**/*']
  s.require_path = 'lib'
  s.author = "Adam Crownoble"
  s.email = "adam@obledesign.com"
  s.homepage = "https://github.com/biola/punching_bag"
  s.license = 'MIT'
  s.add_dependency 'railties', '~> 3.2', '~> 4.0'
  s.add_dependency 'voight_kampff', '~> 0.2'
  s.add_development_dependency 'activerecord', '~> 4.0'
  s.add_development_dependency 'combustion', '~> 0.5'
  s.add_development_dependency 'rspec-its', '~> 1.0'
  s.add_development_dependency 'rspec-rails', '~> 3.0'
  s.add_development_dependency 'sqlite3', '~> 1.3'
end
