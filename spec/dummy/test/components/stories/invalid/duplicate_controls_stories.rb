# frozen_string_literal: true

module Invalid
  class DuplicateControlsStories < ActionView::Storybook::Stories
    story :duplicate_controls do
      controls do
        title "OK"
        title "Not OK!"
      end
    end
  end
end
