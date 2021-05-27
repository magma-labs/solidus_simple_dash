# frozen_string_literal: true

module SolidusSimpleDash
  module Spree
    module LineItemDecorator
      def self.prepended(base)
        base.scope :top_selling_by_variants, -> do
          joins(:order)
            .where(order_complete_scope)
            .order(by_quantity_sum_scope.desc)
            .group(:variant_id)
            .sum(:quantity)
        end

        base.scope :top_selling_by_taxons, -> do
          joins(:order, variant: { product: :taxons })
            .where(order_complete_scope)
            .order(by_quantity_sum_scope.desc)
            .group("#{::Spree::Taxon.table_name}.name")
            .sum(:quantity)
        end

        base.scope :top_grossing_by_variants, -> do
          joins(:order)
            .where(order_complete_scope)
            .order(by_quantity_price_summatory_scope.desc)
            .group(:variant_id)
            .sum(by_quantity_price_multiplication_scope)
        end

        base.scope :abandoned_orders, -> do
          joins(:order, variant: :product)
            .where(order_complete_scope)
            .order(by_quantity_sum_scope.desc)
            .group("#{::Spree::Product.table_name}.name")
            .sum(:quantity)
        end

        def base.order_complete_scope
          ::Spree::Order.arel_table[:state].eq('complete')
        end

        def base.by_quantity_sum_scope
          ::Spree::LineItem.arel_table[:quantity].sum
        end

        def base.by_quantity_price_multiplication_scope
          Arel::Nodes::Multiplication.new(
            ::Spree::LineItem.arel_table[:quantity],
            ::Spree::LineItem.arel_table[:price]
          )
        end

        def base.by_quantity_price_summatory_scope
          by_quantity_price_multiplication_scope.sum
        end
      end

      ::Spree::LineItem.prepend self
    end
  end
end
