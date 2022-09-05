# frozen_string_literal: true

require 'solidus_simple_dash'

module SolidusSimpleDash
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace Spree

    engine_name 'solidus_simple_dash'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'solidus_simple_dash.environment', before: :load_config_initializers do
      SolidusSimpleDash::Config = SolidusSimpleDash::Configuration.new
    end

    config.to_prepare do
      ::Spree::Backend::Config.configure do |config|
        config.menu_items << config.class::MenuItem.new(
          [:overview],
          'bar-chart',
          label: 'overview',
          condition: -> { can?(:manage, ::Spree::Overview) }
        )
      end
    end
  end
end
