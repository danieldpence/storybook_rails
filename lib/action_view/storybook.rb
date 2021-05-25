# frozen_string_literal: true

require "active_model"
require "active_support/dependencies/autoload"

module ActionView
  module Storybook
    extend ActiveSupport::Autoload

    autoload :Controls
    autoload :Stories
    autoload :StoryConfig
    autoload :Dsl
    autoload :Helpers

    include ActiveSupport::Configurable
    # Set the location of component previews through app configuration:
    #
    # config.action_view_storybook.stories_path = Rails.root.join("app/views/storybook/stories")
    #
    mattr_accessor :stories_path, instance_writer: false

    # Enable or disable component previews through app configuration:
    #
    # config.action_view_storybook.show_stories = false
    #
    # Defaults to +true+ for development environment
    #
    mattr_accessor :show_stories, instance_writer: false

    ActiveSupport.run_load_hooks(:action_view_storybook, self)
  end
end
