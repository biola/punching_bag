ENV['RAILS_ENV'] = 'test'

require 'bundler/setup'
require 'combustion'

Bundler.require :default

Combustion.initialize! :active_record

require 'rspec/rails'
require 'rspec/its'

require 'active_support/time'
require 'ostruct'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
end
