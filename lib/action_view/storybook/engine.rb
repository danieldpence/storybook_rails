# frozen_string_literal: true

require "rails"
require "action_view/storybook"

module ActionView
  module Storybook
    class Engine < Rails::Engine
      config.action_view_storybook = ActiveSupport::OrderedOptions.new

      initializer "action_view_storybook.set_configs" do |app|
        options = app.config.action_view_storybook

        options.show_stories = Rails.env.development? if options.show_stories.nil?

        if options.show_stories
          options.stories_path ||= defined?(Rails.root) ? Rails.root.join("test/components/stories") : nil
        end

        ActiveSupport.on_load(:action_view_storybook) do
          options.each { |k, v| send("#{k}=", v) }
        end
      end

      initializer "action_view_storybook.set_autoload_paths" do |app|
        options = app.config.action_view_storybook

        ActiveSupport::Dependencies.autoload_paths << options.stories_path if options.show_stories && options.stories_path
      end

      config.after_initialize do |app|
        options = app.config.action_view_storybook

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
