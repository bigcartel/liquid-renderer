module LiquidRenderer
  class Railtie < ::Rails::Railtie
    config.liquid_renderer = ActiveSupport::OrderedOptions.new

    initializer 'liquid_renderer.initialize' do |app|
      app.config.liquid_renderer.content_for_layout ||= 'content_for_layout'
      ActiveSupport.on_load(:action_controller) do
        require 'liquid'
        require 'liquid-renderer/render'

        ActionController::Renderers.add :liquid do |content, options|
          content_type = options.delete(:content_type) || 'text/html'
          render :text => LiquidRenderer.render(content, options), :content_type => content_type
        end
      end
    end
  end
end
