# frozen_string_literal: true
require "rails/generators/named_base"
require "generators/storybook/stories_generator"

module Storybook
  class StoriesGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("templates", __dir__)
    argument :stories, type: :array, default: [], banner: "stories"
    check_class_collision suffix: "Stories"

    desc "Generates a stories file with the given NAME (if one does not exist) and " \
    "optional [stories], and matching view template file."
    
    def generate_stories_files
      template "stories.rb", File.join(stories_path.to_s, "#{file_path}_stories.rb")
      template "stories.html.erb", File.join(stories_path.to_s, "#{file_path}_stories.html.erb")
    end

    private

    def stories_path
      Rails.application.config.storybook_rails.stories_path
    end
  end
end
