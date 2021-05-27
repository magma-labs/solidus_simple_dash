# frozen_string_literal: true

module SolidusSimpleDash
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.scope :last_orders_by_line_items, -> do
          includes(:line_items)
            .where(state: 'complete')
            .order('completed_at DESC')
        end

        base.scope :biggest_spenders, -> do
          where(['state = ? AND user_id IS NOT NULL', 'complete'])
            .order('SUM(total) DESC')
            .group(:user_id)
            .sum(:total)
        end

        base.scope :abandoned_carts, -> do
          incomplete
            .where(
              'email IS NOT NULL AND item_count > 0 AND updated_at < ?',
              Time.zone.now
            )
        end

        base.scope :abandoned_carts_steps, -> do
          order('COUNT(state) DESC')
            .where('updated_at < ?', Time.zone.now)
            .group(:state)
            .count
        end
      end

      ::Spree::Order.prepend self
    end
  end
end
