# frozen_string_literal: true

class LayoutStories < ActionView::Storybook::Stories
  layout "admin"

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

  story :no_layout do
    controls do
      button_text "OK"
    end
    layout false
  end
end
