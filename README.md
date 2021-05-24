# ActionView::Storybook

The ActionView::Storybook gem provides Ruby api for writing stories describing Rails partials and allowing them to be previewed and tested in [Storybook](https://github.com/storybookjs/storybook/). This gem is a fork of the fantastic [ViewComponent::Storybook](https://github.com/jonspalmer/view_component_storybook) and has been adapted to work with standard Rails view partials.

## Features
* A Ruby DSL for writing Stories describing standard Rails view templates/partials
* A Rails controller backend for Storybook Server compatible with Storybook Controls Addon parameters

## Installation

### Rails Installation

1. Add the `action_view_storybook` gem, to your Gemfile: `gem 'action_view_storybook'`
2. Run `bundle install`.
3. Add `require "action_view/storybook/engine"` to `config/application.rb`
4. Add `**/*.stories.json` to `.gitignore`

#### Configure Asset Hosts

If your view components depend on Javascript, CSS or other assets served by the Rails application you will need to configure `asset_hosts`
apporpriately for your various environments. For local development this is a simple as adding to `config/development.rb`:
```ruby
Rails.application.configure do
  ...
  config.action_controller.asset_host =  'http://localhost:3000'
  ...
end
```
Equivalent configuration will be necessary in `config/production.rb` or `application.rb` based you your deployment environments.

### Storybook Installation

1. Add Storybook server as a dev dependedncy. The Storybook Controls addon isn't needed but is strongly recommended
   ```sh
   yarn add @storybook/server @storybook/addon-controls --dev
   ```
2. Add an NPM script to your package.json in order to start the storybook later in this guide
   ```json
   {
     "scripts": {
       "storybook": "start-storybook"
     }
   }
   ```
3. Create the .storybook/main.js file to configure Storybook to find the json stories the gem creates. Also configure the Controls addon:
   ```javascript
   module.exports = {
     stories: ['../test/components/**/*.stories.json'],
     addons: [
       '@storybook/addon-controls',
     ],
   };
   ```
4. Create the .storybook/preview.js file to configure Storybook with the Rails application url to call for the html content of the stories
   ```javascript

   export const parameters = {
     server: {
       url: `http://localhost:3000/storybook`,
     },
   };
   ```

## Usage

### Writing Stories

`ActionView::Storybook::Stories` provides a way to preview Rails partials in Storybook.

Suppose our app has a shared `app/views/shared/_button.html.erb` partial:

```erb
<% variant_class_map = {
  primary: "button",
  secondary: "button-secondary",
  outline: "button-outline",
} %>

<button class="<%= variant_class_map[variant.to_sym] %>">
  <%= button_text %>
</button>
```

We can write a stories describing the `_button.html.erb` partial:

```ruby
# buttons/button_stories.rb

class Buttons::ButtonStories < ActionView::Storybook::Stories
  self.title = "Buttons"

  story(:primary) do
    controls do
      text(:button_text, "Primary")
    end
  end

  story(:secondary) do
    controls do
      text(:button_text, "Secondary")
    end
  end

  story(:outline) do
    controls do
      text(:button_text, "Outline")
    end
  end
end
```

And a story template to render individual stories:
```erb
# buttons/button_stories.html.erb

<% story_name_class_map = {
    primary: "button",
    secondary: "button-secondary",
    outline: "button-outline"
  } %>

<%= render partial: 'shared/button',
    locals: { variant: story_name, button_text: story_params[:button_text] } %>
```

It's up to you how handle rendering your partials in Storybook, but `ActionView::Storybook` will look for a view template that matches the story name (`buttons/button_stories.html.erb` in the example above. In addition, `ActionView::Storybook` provides a `story_params` helper which provides quick access to the params and args specified in the story config. You can use these parameters in your view template to render each story dynamically. Or not. It's up to you.

### Generating Storybook Stories JSON

Generate the Storybook JSON stories by running the rake task:
```sh
rake action_view_storybook:write_stories_json
```

### Start the Rails app and Storybook

In separate shells start the Rails app and Storybook

```sh
rails s
```
```sh
yarn start-storybook
```

Alternatively you can use tools like [Foreman](https://github.com/ddollar/foreman) to start both Rails and Storybook with one command.

### Configuration

By Default ActionView::Storybook expects to find stories in the folder `test/components/stories`. This can be configured but setting `stories_path` in `config/applicaion.rb`. For example is you're using RSpec you might set the following configuration:

```ruby
config.action_view_storybook.stories_path = Rails.root.join("spec/components/stories")
```

### The Story DSL

Coming Soon

#### Parameters
#### Layout
#### Controls


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/danieldpence/action_view_storybook. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActionView::Storybook project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/danieldpence/action_view_storybook/blob/master/CODE_OF_CONDUCT.md).
