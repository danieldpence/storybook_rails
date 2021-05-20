# frozen_string_literal: true

require "rails"
require "actionview/storybook"

module ActionView
  module Storybook
    class Engine < Rails::Engine
      config.actionview_storybook = ActiveSupport::OrderedOptions.new

      initializer "actionview_storybook.set_configs" do |app|
        options = app.config.actionview_storybook

        options.show_stories = Rails.env.development? if options.show_stories.nil?

        if options.show_stories
          options.stories_path ||= defined?(Rails.root) ? Rails.root.join("test/components/stories") : nil
        end

        ActiveSupport.on_load(:actionview_storybook) do
          options.each { |k, v| send("#{k}=", v) }
        end
      end

      initializer "actionview_storybook.set_autoload_paths" do |app|
        options = app.config.actionview_storybook

        ActiveSupport::Dependencies.autoload_paths << options.stories_path if options.show_stories && options.stories_path
      end

      config.after_initialize do |app|
        options = app.config.actionview_storybook

        if options.show_stories
          app.routes.prepend do
            get "storybook/*stories/:story" => "storybook#show", :internal => true
          end
        end
      end

      rake_tasks do
        load File.join(__dir__, "tasks/write_stories_json.rake")
      end
    end
  end
end
