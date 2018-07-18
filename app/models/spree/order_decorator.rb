Spree::Order.class_eval do
  scope :last_orders_by_line_items, ->(limit = 5) do
    includes(:line_items).
    where(state: 'complete').
    order('completed_at DESC')
    .limit(limit)
  end

  scope :biggest_spenders, ->(limit = 5) do
    where(['state = ? AND user_id IS NOT NULL', 'complete']).
    order('SUM(total) DESC').
    group(:user_id).
    limit(5).
    sum(:total)
  end

  scope :abandoned_carts, ->(limit = 5) do
    incomplete.
    where('email IS NOT NULL AND item_count > 0 AND updated_at < ?', Time.now)
    limit(limit)
  end

  scope :abandoned_carts_steps, ->(limit = 5) do
    order('COUNT(state) DESC').
    where('updated_at < ?', Time.now)
    limit(limit).
    group(:state).
    count
  end
end
