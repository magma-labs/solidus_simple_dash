# frozen_string_literal: true

require 'spree/core'

module SolidusSimpleDash
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree
    engine_name 'solidus_simple_dash'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'solidus_simple_dash.environment', before: :load_config_initializers do
      SolidusSimpleDash::Config = Spree::SimpleDashConfiguration.new
    end
  end
end
