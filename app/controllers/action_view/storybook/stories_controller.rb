# frozen_string_literal: true

require "rails/application_controller"

module ActionView
  module Storybook
    class StoriesController < Rails::ApplicationController
      prepend_view_path File.expand_path("../../../views", __dir__)
      prepend_view_path Rails.root.join("app/views") if defined?(Rails.root)
      prepend_view_path Rails.application.config.action_view_storybook.stories_path

      before_action :find_stories, :find_story, only: :show
      before_action :require_local!, unless: :show_stories?

      content_security_policy(false) if respond_to?(:content_security_policy)

      def show
        story_params = @story.values_from_params(params.permit!.to_h)
        story_params.deep_merge!(story_name: params[:story_name])

        render template: "#{@story.template}", layout: @story.layout, locals: { story_params: story_params }
      end

      private

      def show_stories?
        ActionView::Storybook.show_stories
      end

      def find_stories
        stories_name = params[:stories]
        @stories = ActionView::Storybook::Stories.find_stories(stories_name)

        head :not_found unless @stories
      end

      def find_story
        story_name = params[:story]
        @story = @stories.find_story(story_name)
        head :not_found unless @story
      end
    end
  end
end
