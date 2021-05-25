# frozen_string_literal: true

require File.expand_path('boot', __dir__)

require "rails"
require "active_model/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_view/storybook/engine"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    config.load_defaults 6.0
    config.secret_key_base = "foo"
  end
end
