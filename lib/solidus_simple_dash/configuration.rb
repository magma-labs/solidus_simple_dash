module SolidusSimpleDash
  class Configuration < Spree::Preferences::Configuration
    OVERVIEW_TABS ||= [:overview]

    if Spree.respond_to?(:solidus_version) && Spree.solidus_version > '1.4'
      new_item = Spree::BackendConfiguration::MenuItem.new(OVERVIEW_TABS,
        'bar-chart')
      Spree::Backend::Config.menu_items << new_item
    end
  end
end
