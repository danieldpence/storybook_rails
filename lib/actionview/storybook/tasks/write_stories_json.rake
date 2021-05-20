# frozen_string_literal: true

namespace :actionview_storybook do
  desc "Write CSF JSON stories for all Stories"
  task write_stories_json: :environment do
    puts "Writing Stories JSON"
    ActionView::Storybook::Stories.all.each do |stories|
      json_path = stories.write_csf_json
      puts "#{stories.name} => #{json_path}"
    end
    puts "Done"
  end
end
