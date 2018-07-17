Spree::Taxon.class_eval do
  scope :top_selling, ->(limit = 5) do
    joins(products: { variants: { line_items: :order }}).
    where("#{Spree::Order.table_name}.state = 'complete'").
    order("COUNT(#{Spree::LineItem.table_name}.quantity) DESC").
    limit(5).
    sum("#{Spree::LineItem.table_name}.quantity")
  end
end
