# frozen_string_literal: true

module SolidusSimpleDash
  class Configuration < Spree::Preferences::Configuration
    OVERVIEW_TABS = %i[overview].freeze

    preference :limit, :integer, default: 10

    def overview_tabs
      @overview_tabs ||= OVERVIEW_TABS
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    alias config configuration

    def configure
      yield configuration
    end
  end
end
