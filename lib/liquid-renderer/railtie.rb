module LiquidRenderer
  class Railtie < ::Rails::Railtie
    config.liquid_renderer = ActiveSupport::OrderedOptions.new

    initializer 'liquid_renderer.initialize' do |app|
      app.config.liquid_renderer.content_for_layout ||= 'content_for_layout'
      ActiveSupport.on_load(:action_controller) do
        require 'liquid'
        require 'liquid-renderer/render'
      end
    end
  end
end