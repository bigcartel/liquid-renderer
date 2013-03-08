module LiquidRenderer
  def self.render(content, *args)
    options = args.extract_options!.symbolize_keys
    options[:assigns] ||= {}
    options[:registers] ||= {}
    template = ActiveSupport::Notifications.instrument('liquid.parse') do
      Liquid::Template.parse(content)
    end
    context = Liquid::Context.new([options[:assigns], options[:scope]].compact, {}, options[:registers])
    ActiveSupport::Notifications.instrument('liquid.render') do
      template.render(context)
    end
  end
end

ActionController::Renderers.add :liquid do |content, options|
  render :text => LiquidRenderer.render(content, options), :content_type => 'text/html'
end

