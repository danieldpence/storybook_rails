# frozen_string_literal: true

module Invalid
  class DuplicateStoryStories < ActionView::Storybook::Stories
    story :my_story do
      controls do
        title "OK"
      end
    end

    story :my_story do
      controls do
        title "Not OK!"
      end
    end
  end
end
