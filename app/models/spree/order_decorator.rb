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
end
