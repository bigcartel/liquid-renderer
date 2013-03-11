# Liquid renderer for Action Controller

Adds a liquid renderer to ActionController as well as parsing and rendering instrumentation via ActiveSupport::Notification

## Installation

Add this line to your application's Gemfile:

    gem 'liquid-renderer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install liquid-renderer

## Usage

Basic usage:

    render liquid: liquid_content, assigns: assigns, registers: registers

Slightly more advanced usage (adding a top-level scope to the renderers):

    render liquid: liquid_content, assigns: assigns, registers: registers, scope: top_level_scope

Usage with a layout (the layout should be a string or respond to_s):

    render liquid: liquid_content, assigns: assigns, registers: registers, layout_content: layout_content

The default _assigns_ used for rendering content inside of a layout is *content_for_layout* but can be configured for your environment if different:

    class Application < Rails::Application
      config.liquid_renderer.content_for_layout = 'page_content'
    end


Instrumentation is available for _liquid.parse_ and _liquid.render_:

    ActiveSupport::Notifications.subscribe("liquid.parse") do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      statsd.timing('liquid.parse', event.duration)
    end

    ActiveSupport::Notifications.subscribe(/^liquid\./) do |*args|
      ...
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
