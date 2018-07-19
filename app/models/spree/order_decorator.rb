Spree::Order.class_eval do
  scope :last_orders_by_line_items, -> do
    includes(:line_items).
    where(state: 'complete').
    order('completed_at DESC')
  end

  scope :biggest_spenders, -> do
    where(['state = ? AND user_id IS NOT NULL', 'complete']).
    order('SUM(total) DESC').
    group(:user_id).
    sum(:total)
  end

  scope :abandoned_carts, -> do
    incomplete.
    where('email IS NOT NULL AND item_count > 0 AND updated_at < ?', Time.now)
  end

  scope :abandoned_carts_steps, -> do
    order('COUNT(state) DESC').
    where('updated_at < ?', Time.now)
    group(:state).
    count
  end
end
