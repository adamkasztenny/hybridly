require_relative "boot"

require "rails/all"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module Hybridly
  class Application < Rails::Application
    config.load_defaults 6.1
  end
end
