# storybook_rails

The `storybook_rails` gem provides a Ruby DSL for writing Storybook stories, allowing you to develop, preview, and test standard Rails view partials in [Storybook](https://github.com/storybookjs/storybook/).

## Prior Art
This gem is a fork of [ViewComponent::Storybook](https://github.com/jonspalmer/view_component_storybook) and has been adapted to work with standard Rails view partials.

## Features
* A Ruby DSL for writing Stories describing standard Rails view templates/partials
* A Rails controller backend for Storybook Server compatible with Storybook Controls Addon parameters
* More to come...

## Installation

### Rails Installation

1. Add the `storybook_rails` gem, to your Gemfile: `gem 'storybook_rails'`
2. Run `bundle install`.
3. Add `require "action_view/storybook/engine"` to `config/application.rb`
4. Add `**/*.stories.json` to `.gitignore`

#### Configure Asset Hosts

If your views depend on Javascript, CSS or other assets served by the Rails application you will need to configure `asset_hosts`
appropriately for your various environments. For local development, do this by adding the following to `config/development.rb`:
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

### Webpacker
If your application uses Webpacker to compile your JavaScript and/or CSS, you will need to modify the default Storybook webpack configuration. Please see the [Storybook Webpack config](https://storybook.js.org/docs/react/configure/webpack) for more information on how to do that. Here's an example:

```javascript
// .storybook/main.js

const path = require('path');
const environment = require('../config/webpack/environment');
const { merge } = require('webpack-merge');

module.exports = {
  webpackFinal: async (config, { configType }) => {
    // `configType` has a value of 'DEVELOPMENT' or 'PRODUCTION'
    // You can change the configuration based on that.
    // 'PRODUCTION' is used when building the static version of storybook.
    let envConfig = environment.toWebpackConfig();

    let entries = {
      main: config.entry,
      application: path.resolve(__dirname, '../app/javascript/packs/application.js')
    }

    config.entry = entries

    // Storybook doesn't support .scss out of the box
    config.module.rules.push({
      test: /\.scss$/,
      use: ['style-loader', 'css-loader', 'sass-loader'],
      include: path.resolve(__dirname, '../'),
    });

    // merge Webpacker's config with Storybook's Webpack config
    let merged = merge(config, {module: envConfig.module}, {plugins: envConfig.plugins}, {devtool: 'cheap-module-source-map'})

    // Return the altered config
    return config;
  },
};
```

### Optional Nice-To-Haves
#### Setup File-Watching and Automatically run `rake storybook_rails:write_stories_json`
For a better developer experience, install your favorite file watching utility, such as [chokidar](https://github.com/kimmobrunfeldt/chokidar-cli) and add a couple scripts to enable automatic regeneration of `*.stories.json` files when you update `*_stories.rb` files:

`yarn add -D chokidar-cli`

In package.json:
```js
{
  ...
  "scripts": {
    "storybook:start": "rm -rf node_modules/.cache/storybook && start-storybook",
    "storybook:write-json": "bundle exec rake storybook_rails:write_stories_json",
    "storybook:watch": "chokidar '**/*_stories.rb' -c 'yarn storybook:write-json'"
  },
  ...
}
```
    

## Usage

### Writing Stories

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
    locals: { variant: story_params[:story_name], button_text: story_params[:button_text] } %>
```

It's up to you how handle rendering your partials in Storybook, but `storybook_rails` will look for a view template that matches the story name (`buttons/button_stories.html.erb` in the example above. In addition, `storybook_rails` provides a `story_params` helper which provides quick access to the params and args specified in the story config. You can use these parameters in your view template to render each story dynamically. Or not. It's up to you.

#### Story Files Generator
`storybook_rails` includes a Rails generator to make it easy to generate the files outlined in the section above.

To generate the files above, we could have: `bin/rails generate storybook_rails:stories Button primary secondary outline`.

For more detail, `bin/rails storybook_rails:stories --help`.

### Generating Storybook Stories JSON

Generate the Storybook JSON stories by running the rake task:
```sh
rake storybook_rails:write_stories_json
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

By Default `storybook_rails` expects to find stories in the folder `test/components/stories`. This can be configured but setting `config.storybook_rails.stories_path` in `config/applicaion.rb`. For example, if you're using RSpec you might set the following configuration:

```ruby
config.storybook_rails.stories_path = Rails.root.join("spec/components/stories")
```

### Troubleshooting
#### Restarting Storybook Fails
If Storybook fails to load with a `cannot get /` error, it could be related to [this issue](https://github.com/storybookjs/storybook/issues/14152). As a workaround, you can update the `yarn storybook` script to remove the `node_modules/.cache/storybook` files before Storybook starts:
```json
{
  "scripts": {
    "storybook": "rm -rf node_modules/.cache/storybook && start-storybook"
  }
}
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

Bug reports and pull requests are welcome on GitHub at https://github.com/danieldpence/storybook_rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `storybook_rails` project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/danieldpence/storybook_rails/blob/master/CODE_OF_CONDUCT.md).
