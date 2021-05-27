# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable RSpec/LetSetup
# rubocop:disable RSpec/MultipleExpectations
# rubocop:disable RSpec/MultipleMemoizedHelpers
describe Spree::Admin::OverviewController, type: :controller do
  stub_authorization!

  let!(:user) { create(:user) }
  let!(:product) { create(:product) }
  let!(:other1) { create(:product) }
  let(:line_items) do
    [create(:line_item, variant: product.master, quantity: 5)]
  end
  let!(:order) do
    create(:completed_order_with_totals, line_items: line_items)
  end

  before { stub_authentication! }

  describe 'with JS' do
    sign_in_as_admin!

    describe '#index' do
      before do
        allow(controller).to receive(:display_ability).and_return(true)
        get :index
      end

      it 'return the 5 best selling variants' do
        expect(response).to be_successful
        expect(assigns(:best_selling_variants)).not_to be_empty
      end

      it 'return the 5 best grossing variants' do
        expect(response).to be_successful
        expect(assigns(:top_grossing_variants)).not_to be_empty
      end
    end

    xdescribe '#report_data' do
      let(:params) { { report: 'orders_totals', name: '7_days' } }

      it 'allow JSON request with invalid token' do
        get :report_data, params: params, format: :js, xhr: true

        expect(response).to be_successful
      end

      it 'allow JSON request with a valid token' do
        params[:authenticity_token] = '123456'
        get :report_data, params: params, format: :js, xhr: true

        expect(response).to be_successful
      end
    end
  end
end
# rubocop:enable RSpec/LetSetup
# rubocop:enable RSpec/MultipleExpectations
# rubocop:enable RSpec/MultipleMemoizedHelpers
