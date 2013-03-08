module LiquidRenderer
  class Railtie < ::Rails::Railtie
    initializer 'liquid-renderer' do
      ActiveSupport.on_load(:action_controller) do
        require 'liquid'
        require 'liquid-renderer/render'
      end
    end
  end
end