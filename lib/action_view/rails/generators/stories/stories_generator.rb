# frozen_string_literal: true

module Rails
  module Generators
    class StoriesGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      source_root File.expand_path("../templates", __FILE__)
      argument :stories, type: :array, default: [], banner: "stories"
      check_class_collision suffix: "Stories"

      # @module_name = options[:module]

      desc "Generates story files for a given component class NAME and optional list of story names."

      def create_stories_files
        template "stories.rb", "test/components/#{file_path}.rb"
        template "view.rb", "test/components/#{file_path}.html.erb"
      end
    end
  end
end
