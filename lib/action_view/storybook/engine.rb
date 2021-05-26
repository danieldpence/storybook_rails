# frozen_string_literal: true

require "rails"
require "action_view/storybook"

module ActionView
  module Storybook
    class Engine < Rails::Engine
      config.storybook_rails = ActiveSupport::OrderedOptions.new

      initializer "storybook_rails.set_configs" do |app|
        options = app.config.storybook_rails

        options.show_stories = Rails.env.development? if options.show_stories.nil?

        if options.show_stories
          options.stories_path ||= defined?(Rails.root) ? Rails.root.join("test/components/stories") : nil
        end

        ActiveSupport.on_load(:storybook_rails) do
          options.each { |k, v| send("#{k}=", v) }
        end
      end

      initializer "storybook_rails.set_autoload_paths" do |app|
        options = app.config.storybook_rails

        ActiveSupport::Dependencies.autoload_paths << options.stories_path if options.show_stories && options.stories_path
      end

      config.after_initialize do |app|
        options = app.config.storybook_rails

        if options.show_stories
          app.routes.prepend do
            get "storybook/*stories/:story" => "action_view/storybook/stories#show"
          end
        end
      end

      rake_tasks do
        load File.join(__dir__, "tasks/write_stories_json.rake")
      end
    end
  end
end
