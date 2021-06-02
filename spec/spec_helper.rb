# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  command_name "rails#{ENV['RAILS_VERSION']}-ruby#{ENV['RUBY_VERSION']}" if ENV["RUBY_VERSION"]
  add_filter 'spec'
  add_group 'generators', 'lib/generators'
  add_group 'action_view', 'lib/action_view'
end

require "bundler/setup"

# Configure Rails Envinronment
# we need to do this before including capybara
ENV["RAILS_ENV"] = "test"
require File.expand_path("dummy/config/environment.rb", __dir__)

require "rspec/expectations"
require "rspec/rails"
require 'minitest/autorun'
require 'minitest/spec'
require 'pry'

Dir[File.expand_path(File.join(File.dirname(__FILE__), "support", "**", "*.rb"))].sort.each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include RSpec::Rails::RequestExampleGroup, type: :request
end

def trim_result(content)
  content = content.to_s.lines.collect(&:strip).join("\n").strip

  doc = Nokogiri::HTML.fragment(content)

  doc.xpath("//text()").each do |node|
    if node.content.match?(/\S/)
      node.content = node.content.gsub(/\s+/, " ").strip
    else
      node.remove
    end
  end

  doc.to_s.strip
end

RSpec::Matchers.define :match_html do |expected|
  match do |actual|
    trim_result(actual) == trim_result(expected)
  end
end
