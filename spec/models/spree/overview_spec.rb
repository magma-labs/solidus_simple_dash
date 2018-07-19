describe Spree::Overview, type: :model do
  let(:store) { create(:store) }
  let(:user) { create(:user) }
  let(:product1) { create(:product, name: 'RoR Shirt') }
  let(:product2) { create(:product, name: 'RoR Jersey') }
  let(:product3) { create(:product, name: 'RoR Hat') }
  let(:product4) { create(:product, name: 'RoR Pants') }
  let(:product5) { create(:product, name: 'RoR Shoes') }
  let(:variant1) { create(:variant, product: product1) }
  let(:variant2) { create(:variant, product: product2) }
  let(:variant3) { create(:variant, product: product3) }
  let(:variant4) { create(:variant, product: product4) }
  let(:variant5) { create(:variant, product: product5) }
  let!(:taxonomy) { create(:taxonomy, name: 'Categories') }
  let!(:taxon) do
    taxon = create(:taxon, taxonomy: taxonomy)
    product1.taxons = [ taxon ]
    product2.taxons = [ taxon ]
    product3.taxons = [ taxon ]
    product4.taxons = [ taxon ]
    product5.taxons = [ taxon ]
  end
  let!(:line_items) do
    [ create(:line_item, variant: variant1, quantity: 5),
      create(:line_item, variant: variant2, quantity: 4),
      create(:line_item, variant: variant3, quantity: 3),
      create(:line_item, variant: variant4, quantity: 2),
      create(:line_item, variant: variant5, quantity: 1) ]
  end
  let!(:order) do
    create(:completed_order_with_totals, user: user, line_items: line_items)
  end
  let!(:order_on_cart) { create(:order, user: user, line_items: line_items, completed_at: nil, state: 'cart') }
  let(:params) do
    { from: (Time.new().to_date - 1.week).to_s(:db), value: 'Count' }
  end

  subject { Spree::Overview.new(params) }

  context '#orders_by_day' do
    it 'returns data' do
      expect(subject.orders_by_day).not_to be_empty
    end
  end

  context '#orders_line_total' do
    it 'returns data' do
      expect(subject.orders_line_total).not_to be_nil
    end
  end

  context '#orders_total' do
    it 'returns data' do
      expect(subject.orders_total).not_to be_nil
    end
  end

  context '#orders_adjustment_total' do
    it 'returns data' do
      expect(subject.orders_adjustment_total).not_to be_nil
    end
  end

  context '#best_selling_variants' do
    it 'returns data' do
      expect(subject.best_selling_variants).not_to be_empty
    end
  end

  context '#top_grossing_variants' do
    it 'returns data' do
      expect(subject.top_grossing_variants).not_to be_empty
    end
  end

  context '#best_selling_taxons' do
    it 'returns data' do
      expect(subject.best_selling_taxons).not_to be_nil
    end
  end

  context '#abandoned_carts' do
    it 'returns data' do
      expect(subject.abandoned_carts).not_to be_nil
    end
  end

  context '#checkout_steps' do
    it 'returns data' do
      expect(subject.checkout_steps).not_to be_empty
    end
  end

  context '#abandoned_carts_products' do
    it 'returns data' do
      expect(subject.abandoned_carts_products).not_to be_empty
    end
  end

  context '#biggest_spenders' do
    it 'returns data' do
      expect(subject.biggest_spenders).not_to be_empty
    end
  end

  context '#out_of_stock_products' do
    it 'returns data' do
      expect(subject.out_of_stock_products).not_to be_empty
    end
  end
end
