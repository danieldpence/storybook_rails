# frozen_string_literal: true

class NoLayoutStories < ActionView::Storybook::Stories
  layout false

  story :default do
    controls do
      button_text "OK"
    end
  end

  story :mobile_layout do
    controls do
      button_text "OK"
    end
    layout "mobile"
  end
end
