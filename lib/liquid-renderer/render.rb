module LiquidRenderer
  def self.render(content, *args)
    options = args.extract_options!.symbolize_keys
    options[:assigns] ||= {}
    options[:registers] ||= {}

    # Render the page content
    rendered_content = _render(content, Liquid::Context.new([options[:assigns], options[:scope]].compact, {}, options[:registers]))

    # If a layout has been specified, render it and set assigns to our already-rendered content
    if options[:layout]
      options[:assigns][Rails.configuration.liquid_renderer['content_for_layout']] = rendered_content
      rendered_content = _render(options[:layout], Liquid::Context.new([options[:assigns], options[:scope]].compact, {}, options[:registers]))
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
  render :text => LiquidRenderer.render(content, options), :content_type => 'text/html'
end

