require 'rack/crawler_detect'
module PunchingBag
  class Railtie < Rails::Railtie
    initializer "punching_bag.insert_middleware" do |app|
      app.config.middleware.use Rack::CrawlerDetect
    end
  end
end