module LiquidRenderer
  def self.render(content, *args)
    options = args.extract_options!.symbolize_keys
    options[:assigns] ||= {}
    options[:registers] ||= {}

    # Render the page content
    rendered_content = _render(content, Liquid::Context.new([options[:assigns], options[:scope]].compact, {}, options[:registers]))

    # If layout_content has been specified, render it and set assigns to our already-rendered content.
    # Note that we can't use 'layout' here because ActionView helpfully tries to turn any string passed to it into a file path relative to 'layouts/'
    if options[:layout_content] and options[:layout_content].kind_of?(String)
      options[:assigns][Rails.configuration.liquid_renderer['content_for_layout']] = rendered_content
      rendered_content = _render(options[:layout_content], Liquid::Context.new([options[:assigns], options[:scope]].compact, {}, options[:registers]))
    end

    rendered_content
  end

  private

  def self._render(content, context)
    template = ActiveSupport::Notifications.instrument('liquid.parse') do
      Liquid::Template.parse(content)
    end
    ActiveSupport::Notifications.instrument('liquid.render') do
      template.render(context)
    end
  end
end

ActionController::Renderers.add :liquid do |content, options|
  content_type = options.delete(:content_type) || 'text/html'
  render :text => LiquidRenderer.render(content, options), :content_type => content_type
end

