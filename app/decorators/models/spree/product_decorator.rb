# frozen_string_literal: true

module Spree
  module ProductDecorator
    def self.prepended(klass)
      klass.scope :out_of_stock, -> do
        joins(:stock_items).
        where('spree_stock_items.count_on_hand = 0')
      end
    end

    ::Spree::Product.prepend(self)
  end
end
