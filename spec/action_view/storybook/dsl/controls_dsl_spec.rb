# frozen_string_literal: true

RSpec.describe ActionView::Storybook::Dsl::ControlsDsl do
  subject { described_class.new(ActionView::Storybook::StoryConfig.new("anything", :anything, false, "anything")) }

  shared_examples "has controls attributes" do |control_attributes|
    it "has controls with expected attributes" do
      expect(subject.controls).to match_array(control_attributes.map { |attrs| have_attributes(attrs) })
    end
  end

  describe "#text" do
    before { subject.text(:name, "Jame Doe") }

    include_examples "has controls attributes", [
      {
        class: ActionView::Storybook::Controls::TextConfig,
        param: :name,
        name: "Name",
        value: "Jame Doe"
      }
    ]
  end

  describe "#boolean" do
    before { subject.boolean(:likes_people, true) }

    include_examples "has controls attributes", [
      {
        class: ActionView::Storybook::Controls::BooleanConfig,
        param: :likes_people,
        name: "Likes People",
        value: true
      }
    ]
  end

  describe "#number" do
    context "with minimal args" do
      before { subject.number(:number_pets, 2) }

      include_examples "has controls attributes", [
        {
          class: ActionView::Storybook::Controls::NumberConfig,
          type: :number,
          param: :number_pets,
          name: "Number Pets",
          value: 2,
          min: nil,
          max: nil,
          step: nil
        }
      ]
    end

    context "with all args" do
      before { subject.number(:number_pets, 2, min: 0, max: 10, step: 1) }

      include_examples "has controls attributes", [
        {
          class: ActionView::Storybook::Controls::NumberConfig,
          type: :number,
          param: :number_pets,
          name: "Number Pets",
          value: 2,
          min: 0,
          max: 10,
          step: 1
        }
      ]
    end
  end

  describe "#range" do
    context "with minimal args" do
      before { subject.range(:number_pets, 2) }

      include_examples "has controls attributes", [
        {
          class: ActionView::Storybook::Controls::NumberConfig,
          type: :range,
          param: :number_pets,
          name: "Number Pets",
          value: 2,
          min: nil,
          max: nil,
          step: nil
        }
      ]
    end

    context "with all args" do
      before { subject.range(:number_pets, 2, min: 0, max: 10, step: 1, name: "Pets") }

      include_examples "has controls attributes", [
        {
          class: ActionView::Storybook::Controls::NumberConfig,
          type: :range,
          param: :number_pets,
          name: "Pets",
          value: 2,
          min: 0,
          max: 10,
          step: 1
        }
      ]
    end
  end

  describe "#color" do
    before { subject.color(:favorite_color, "red") }

    include_examples "has controls attributes", [
      {
        class: ActionView::Storybook::Controls::ColorConfig,
        param: :favorite_color,
        name: "Favorite Color",
        value: "red"
      }
    ]
  end

  describe "#object" do
    before { subject.object(:other_things, { hair: "Brown", eyes: "Blue" }) }

    include_examples "has controls attributes", [
      {
        class: ActionView::Storybook::Controls::ObjectConfig,
        param: :other_things,
        name: "Other Things",
        value: { hair: "Brown", eyes: "Blue" }
      }
    ]
  end

  %w[select multi-select radio inline-radio check inline-check].each do |type|
    dsl_method = type.underscore

    describe "##{dsl_method}" do
      before { subject.send(dsl_method, :favorite_food, { hot_dog: "Hot Dog", pizza: "Pizza" }, "Pizza") }

      include_examples "has controls attributes", [
        {
          class: ActionView::Storybook::Controls::OptionsConfig,
          type: type.to_sym,
          param: :favorite_food,
          name: "Favorite Food",
          value: "Pizza",
          options: { hot_dog: "Hot Dog", pizza: "Pizza" }
        }
      ]
    end
  end

  describe "convenience shortcuts" do
    context "with date value" do
      before { subject.birthday Date.new(1950, 3, 26) }

      include_examples "has controls attributes", [
        {
          class: ActionView::Storybook::Controls::DateConfig,
          param: :birthday,
          name: "Birthday",
          value: Date.new(1950, 3, 26)
        }
      ]
    end

    context "with array value" do
      before { subject.sports %w[football baseball], "|" }

      include_examples "has controls attributes", [
        {
          class: ActionView::Storybook::Controls::ArrayConfig,
          param: :sports,
          name: "Sports",
          value: %w[football baseball],
          separator: "|"
        }
      ]
    end

    context "with hash value" do
      before { subject.other_things(hair: "Brown", eyes: "Blue") }

      include_examples "has controls attributes", [
        {
          class: ActionView::Storybook::Controls::ObjectConfig,
          param: :other_things,
          name: "Other Things",
          value: { hair: "Brown", eyes: "Blue" }
        }
      ]
    end

    context "with integer numeric value" do
      before { subject.number_pets(2) }

      include_examples "has controls attributes", [
        {
          class: ActionView::Storybook::Controls::NumberConfig,
          param: :number_pets,
          name: "Number Pets",
          value: 2
        }
      ]
    end

    context "with float numeric value" do
      before { subject.number_pets(2.5) }

      include_examples "has controls attributes", [
        {
          class: ActionView::Storybook::Controls::NumberConfig,
          param: :number_pets,
          name: "Number Pets",
          value: 2.5
        }
      ]
    end

    context "with true boolean value" do
      before { subject.like_people(true) }

      include_examples "has controls attributes", [
        {
          class: ActionView::Storybook::Controls::BooleanConfig,
          param: :like_people,
          name: "Like People",
          value: true
        }
      ]
    end

    context "with false boolean value" do
      before { subject.like_people(false) }

      include_examples "has controls attributes", [
        {
          class: ActionView::Storybook::Controls::BooleanConfig,
          param: :like_people,
          name: "Like People",
          value: false
        }
      ]
    end

    context "with string value" do
      before { subject.name("Jame Doe") }

      include_examples "has controls attributes", [
        {
          class: ActionView::Storybook::Controls::TextConfig,
          param: :name,
          name: "Name",
          value: "Jame Doe"
        }
      ]
    end

    it "defers to super for unknown value class" do
      expect { subject.name Struct }.to raise_error(NoMethodError)
    end
  end

  describe ".respond_to_missing?" do
    it "responds to all methods" do
      expect(subject.respond_to?(:foo)).to eq(true)
    end
  end
end
