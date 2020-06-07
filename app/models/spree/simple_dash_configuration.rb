# frozen_string_literal: true

module Spree
  class SimpleDashConfiguration < Preferences::Configuration
    preference :limit, :integer, default: 10

    if Spree.respond_to?(:solidus_version) && Spree.solidus_version > '1.4'
      Spree::Backend::Config.configure do |config|
        # This is the email submenu, useful for store users
        config.menu_items << config.class::MenuItem.new(
          [:overview],
          'bar-chart',
          label: 'overview',
          condition: -> { can?(:manage, Spree::Overview) }
        )
      end
    end
  end
end
