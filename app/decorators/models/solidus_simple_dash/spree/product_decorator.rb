# frozen_string_literal: true

module SolidusSimpleDash
  module Spree
    module ProductDecorator
      def self.prepended(base)
        base.scope :out_of_stock, -> do
          joins(:stock_items)
            .where(::Spree::StockItem.arel_table[:count_on_hand].eq(0))
        end
      end

      ::Spree::Product.prepend self
    end
  end
end
