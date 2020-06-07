# frozen_string_literal: true

module Spree
  module OrderDecorator
    def self.prepended(klass)
      klass.scope :last_orders_by_line_items, -> do
        includes(:line_items).
        where(state: 'complete').
        order(Arel.sql('completed_at DESC'))
      end

      klass.scope :biggest_spenders, -> do
        where(['state = ? AND user_id IS NOT NULL', 'complete']).
        order(Arel.sql('SUM(total) DESC')).
        group(:user_id).
        sum(:total)
      end

      klass.scope :abandoned_carts, -> do
        incomplete.
        where('email IS NOT NULL AND item_count > 0 AND updated_at < ?',
              Time.now)
      end

      klass.scope :abandoned_carts_steps, -> do
        order(Arel.sql('COUNT(state) DESC')).
        where('updated_at < ?', Time.now)
        group(:state).
        count
      end
    end

    ::Spree::Order.prepend(self)
  end
end
