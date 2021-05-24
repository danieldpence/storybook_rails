# frozen_string_literal: true

require "active_support/dependencies/autoload"

module ActionView
  module Storybook
    module Helpers
      extend ActiveSupport::Autoload

      autoload :story_params
    end
  end
end
