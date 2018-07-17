Spree::Product.class_eval do
  scope :out_of_stock, -> do
    joins(:stock_items).
    where('spree_stock_items.count_on_hand = 0')
  end
end
