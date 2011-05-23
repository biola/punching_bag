lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'punching_bag/version'

spec = Gem::Specification.new do |s|
  s.name = 'punching_bag'
  s.version = PunchingBag::VERSION
  s.summary = "PunchingBag hit conter and trending plugin"
  s.description = "PunchingBag is a hit counting and simple trending engine for Ruby on Rails"
  s.files = Dir['app/**/*.rb', 'lib/**/*.rb', 'lib/tasks/*.rake']
  s.require_path = 'lib'
  s.author = "Adam Crownoble"
  s.email = "adam@obledesign.com"
  s.homepage = "https://github.com/adamcrown/punching_bag"
  s.add_dependency('voight_kampff', '~>0.1.1')
end
