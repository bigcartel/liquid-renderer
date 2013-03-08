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
