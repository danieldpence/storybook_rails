# frozen_string_literal: true

RSpec.describe ActionView::Storybook::StoryConfig do
  subject do
    described_class.new("example_story_config", "Example Story Config", false, "example_story_config")
  end

  describe "#valid?" do
    it "duplicate controls are invalid" do
      subject.controls << ActionView::Storybook::Controls::TextConfig.new(:title, "OK")
      subject.controls << ActionView::Storybook::Controls::TextConfig.new(:title, "Not OK!")

      expect(subject.valid?).to eq(false)
      expect(subject.errors[:controls].length).to eq(1)
    end

    it "duplicate controls with different types are invalid" do
      subject.controls << ActionView::Storybook::Controls::TextConfig.new(:title, "OK")
      subject.controls << ActionView::Storybook::Controls::NumberConfig.new(:number, :title, 777)
      expect(subject.valid?).to eq(false)
      expect(subject.errors[:controls].length).to eq(1)
    end
  end

  describe "#to_csf_params" do
    it "writes csf params" do
      expect(subject.to_csf_params).to eq(
        {
          name: "Example Story Config",
          parameters: {
            server: {
              id: "example_story_config",
              params: {
                story_name: "Example Story Config"
              }
            }
          }
        }
      )
    end

    context "with controls" do
      before do
        subject.controls << ActionView::Storybook::Controls::TextConfig.new(:title, "OK")
      end

      it "writes csf params" do
        expect(subject.to_csf_params).to eq(
          {
            name: "Example Story Config",
            parameters: {
              server: { 
                id: "example_story_config",
                params: {
                  story_name: "Example Story Config" 
                }
              }
            },
            args: {
              title: "OK"
            },
            argTypes: {
              title: { control: { type: :text }, name: "Title" }
            }
          }
        )
      end
    end

    context "with params" do
      before do
        subject.parameters = { size: :large, color: :red }
      end

      it "writes csf params" do
        expect(subject.to_csf_params).to eq(
          {
            name: "Example Story Config",
            parameters: {
              server: { 
                id: "example_story_config",
                params: {
                  story_name: "Example Story Config"
                }
              },
              size: :large,
              color: :red,
            }
          }
        )
      end
    end

    context "with controls and params" do
      before do
        subject.controls << ActionView::Storybook::Controls::TextConfig.new(:title, "OK")
        subject.parameters = { size: :large, color: :red }
      end

      it "writes csf params" do
        expect(subject.to_csf_params).to eq(
          {
            name: "Example Story Config",
            parameters: {
              server: {
                id: "example_story_config",
                params: {
                  story_name: "Example Story Config"
                }
              },
              size: :large,
              color: :red,
            },
            args: {
              title: "OK"
            },
            argTypes: {
              title: { control: { type: :text }, name: "Title" }
            }
          }
        )
      end
    end
  end
end
