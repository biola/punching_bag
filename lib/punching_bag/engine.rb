require 'punching_bag'
require 'rails'
require 'active_record'

module PunchingBag
  class Engine < Rails::Engine
    initializer 'punching_bag.extend_acts_as_taggable_on' do
      require 'punching_bag/acts_as_taggable_on' if defined? ActsAsTaggableOn
    end
  end
end
