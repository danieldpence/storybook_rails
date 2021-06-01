# frozen_string_literal: true

require "rails/generators/named_base"

module Storybook
  class StoriesGenerator < Rails::Generators::NamedBase
    include Rails::Generators::ResourceHelpers

    source_root File.expand_path("templates", __dir__)
    argument :stories, type: :array, default: [], banner: "stories"
    check_class_collision suffix: "Stories"

    def create_stories_files
      stories_path = Rails.application.config.storybook_rails.stories_path
      template "stories.rb", "#{stories_path}/#{file_path}_stories.rb"
      template "view.html.erb", "#{stories_path}/#{file_path}_stories.html.erb"
    end
  end
end
