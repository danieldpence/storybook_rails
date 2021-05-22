# frozen_string_literal: true

class ParametersStories < ActionView::Storybook::Stories
  parameters( size: :small )

  story :stories_parameters do
    controls do
      button_text "OK"
    end
  end

  story :stories_parameter_override do
    parameters( size: :large, color: :red )
    controls do
      button_text "OK"
    end
  end

  story :additional_parameters do
    parameters( color: :red )
    controls do
      button_text "OK"
    end
  end
end
