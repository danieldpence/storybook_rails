# frozen_string_literal: true

require 'fileutils'
require "rails/generators/test_case"
require "generators/storybook/stories_generator"

Rails.application.load_generators

class StoriesGeneratorTest < Rails::Generators::TestCase
  tests Storybook::StoriesGenerator
  destination File.expand_path("../tmp", __dir__)
  setup :prepare_destination

  arguments %w[Button primary]

  setup do
    Rails.application.config.storybook_rails.stories_path = "./"
  end

  teardown do
    FileUtils.rm_rf(File.expand_path("../tmp", __dir__))
  end

  def test_stories_generator
    run_generator

    assert_file "button_stories.rb" do |file|
      assert_match(/class ButtonStories < /, file)
      assert_match(/story\(:primary\)/, file)
    end

    assert_file "button_stories.html.erb" do |file|
      assert_match("<div>Render the Button partial here.</div>", file)
    end
  end

  def test_stories_generator_with_namespace
    run_generator %w[buttons/button primary]

    assert_file "buttons/button_stories.rb" do |file|
      assert_match(/class Buttons::ButtonStories < /, file)
      assert_match(/story\(:primary\)/, file)
    end

    assert_file "buttons/button_stories.html.erb" do |file|
      assert_match("<div>Render the Buttons::Button partial here.</div>", file)
    end
  end

  def test_stories_generator_with_namespaced_classname
    run_generator %w[Buttons::Button primary]

    assert_file "buttons/button_stories.rb" do |file|
      assert_match(/class Buttons::ButtonStories < /, file)
      assert_match(/story\(:primary\)/, file)
    end

    assert_file "buttons/button_stories.html.erb" do |file|
      assert_match("<div>Render the Buttons::Button partial here.</div>", file)
    end
  end
end
