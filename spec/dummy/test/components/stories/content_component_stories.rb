# frozen_string_literal: true

class ContentComponentStories < ActionView::Storybook::Stories
  story :default do
    content do
      "Hello World!"
    end
  end
end
