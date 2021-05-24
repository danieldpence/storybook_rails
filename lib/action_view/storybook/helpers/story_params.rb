module StoryParamsHelper
  def story_params
    params.dig(:story_params)
  end
end
