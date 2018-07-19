Spree::LineItem.class_eval do
  scope :top_selling_by_variants, -> do
    joins(:order).
    where("#{Spree::Order.table_name}.state = 'complete'").
    order('SUM(spree_line_items.quantity) DESC').
    group(:variant_id).
    sum(:quantity)
  end

  scope :top_selling_by_taxons, -> do
    joins(:order, variant: { product: :taxons }).
    where("#{Spree::Order.table_name}.state = 'complete'").
    order("SUM(#{Spree::LineItem.table_name}.quantity) DESC").
    group("#{Spree::Taxon.table_name}.name").
    sum(:quantity)
  end

  scope :top_grossing_by_variants, -> do
    joins(:order).
    where("#{Spree::Order.table_name}.state = 'complete'").
    order("SUM(#{Spree::LineItem.table_name}.quantity * #{Spree::LineItem.table_name}.price) DESC")
    group(:variant_id).
    sum('price * quantity')
  end

  scope :abandoned_orders, -> do
    joins(:order, variant: :product).
    where("#{Spree::Order.table_name}.state != 'complete'").
    order('SUM(spree_line_items.quantity) DESC').
    group("#{Spree::Product.table_name}.name").
    sum(:quantity)
  end
end
