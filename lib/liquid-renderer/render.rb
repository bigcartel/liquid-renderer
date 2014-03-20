module LiquidRenderer
  def self.render(content, *args)
    options = args.extract_options!.symbolize_keys
    options[:assigns] ||= {}
    options[:registers] ||= {}

    # Use the given context or set up a new one
    context = options[:context] || Liquid::Context.new([options[:assigns], options[:scope]].compact, {}, options[:registers])

    # Render the page content
    rendered_content = _render(content, context, options[:payload])

    # If layout_content has been specified, render it and set assigns to our already-rendered content.
    # Note that we can't use 'layout' here because ActionView helpfully tries to turn any string passed to it into a file path relative to 'layouts/'
    if options[:layout_content] and options[:layout_content].kind_of?(String)
      options[:assigns][Rails.configuration.liquid_renderer['content_for_layout']] = rendered_content
      rendered_content = _render(options[:layout_content], context, options[:payload])
    end

    rendered_content
  end

  private

  def self._render(content, context, payload)
    template = instrument('liquid.parse', payload) do
      Liquid::Template.parse(content)
    end
    instrument('liquid.render', payload) do
      template.render(context)
    end
  end

  def self.instrument(name, payload)
    if defined?(::ActiveSupport::Notifications)
      ActiveSupport::Notifications.instrument(name, payload) { yield }
    else
      yield
    end
  end
end
