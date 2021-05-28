# frozen_string_literal: true

module SolidusSimpleDash
  class Configuration < Spree::Preferences::Configuration
    preference :limit, :integer, default: 10
  end
end
