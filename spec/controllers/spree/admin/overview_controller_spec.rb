# frozen_string_literal: true

describe Spree::Admin::OverviewController, type: :controller do
  let(:admin) { create(:admin_user) }

  stub_authorization!

  before do
    allow(controller).to receive_messages(spree_current_user: admin)
  end

  context '#index' do
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
      product1.taxons = [taxon]
      product2.taxons = [taxon]
      product3.taxons = [taxon]
      product4.taxons = [taxon]
      product5.taxons = [taxon]
    end
    let(:line_items) do
      [create(:line_item, variant: variant1, quantity: 5),
       create(:line_item, variant: variant2, quantity: 4),
       create(:line_item, variant: variant3, quantity: 3),
       create(:line_item, variant: variant4, quantity: 2),
       create(:line_item, variant: variant5, quantity: 1)]
    end
    let!(:order) do
      create(:completed_order_with_totals, line_items: line_items)
    end

    before do
      allow(controller).to receive(:display_ability).and_return(true)
      get :index
    end

    it 'should return the 5 best selling variants' do
      expect(response).to be_successful
      expect(assigns(:best_selling_variants)).to_not be_empty
    end

    it 'should return the 5 best selling variants' do
      expect(response).to be_successful
      expect(assigns(:top_grossing_variants)).to_not be_empty
    end
  end

  xcontext '#report_data' do
    let(:params) { { report: 'orders_totals', name: '7_days' } }

    it 'should allow JSON request with invalid token' do
      get :report_data, params: params, format: :js, xhr: true

      expect(response).to be_successful
    end

    it 'should allow JSON request with a valid token' do
      params[:authenticity_token] = '123456'
      get :report_data, params: params, format: :js, xhr: true

      expect(response).to be_successful
    end
  end
end
