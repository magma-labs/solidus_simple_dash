# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable RSpec/LetSetup
# rubocop:disable RSpec/NestedGroups
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

    describe '#report_data' do
      context 'with orders_totals' do
        context 'with 7 days' do
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

        context 'with 14 days' do
          let(:params) { { report: 'abandoned_carts', name: '14_days' } }

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

        context 'with this month' do
          let(:params) { { report: 'abandoned_carts', name: 'this_month' } }

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

        context 'with last month' do
          let(:params) { { report: 'abandoned_carts', name: 'last_month' } }

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

        context 'with this year' do
          let(:params) { { report: 'abandoned_carts', name: 'this_year' } }

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

        context 'with last year' do
          let(:params) { { report: 'abandoned_carts', name: 'last_year' } }

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

      context 'with orders' do
        context 'with 7 days' do
          let(:params) { { report: 'orders', name: '7_days' } }

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

        context 'with 14 days' do
          let(:params) { { report: 'orders', name: '14_days' } }

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

        context 'with this month' do
          let(:params) { { report: 'orders', name: 'this_month' } }

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

        context 'with last month' do
          let(:params) { { report: 'orders', name: 'last_month' } }

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

        context 'with this year' do
          let(:params) { { report: 'orders', name: 'this_year' } }

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

        context 'with last year' do
          let(:params) { { report: 'orders', name: 'last_year' } }

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

      context 'with new_users' do
        context 'with 7 days' do
          let(:params) { { report: 'new_users', name: '7_days' } }

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

        context 'with 14 days' do
          let(:params) { { report: 'new_users', name: '14_days' } }

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

        context 'with this month' do
          let(:params) { { report: 'new_users', name: 'this_month' } }

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

        context 'with last month' do
          let(:params) { { report: 'new_users', name: 'last_month' } }

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

        context 'with this year' do
          let(:params) { { report: 'new_users', name: 'this_year' } }

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

        context 'with last year' do
          let(:params) { { report: 'new_users', name: 'last_year' } }

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

      context 'with abandoned_carts' do
        context 'with 7 days' do
          let(:params) { { report: 'abandoned_carts', name: '7_days' } }

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

        context 'with 14 days' do
          let(:params) { { report: 'abandoned_carts', name: '14_days' } }

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

        context 'with this month' do
          let(:params) { { report: 'abandoned_carts', name: 'this_month' } }

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

        context 'with last month' do
          let(:params) { { report: 'abandoned_carts', name: 'last_month' } }

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

        context 'with this year' do
          let(:params) { { report: 'abandoned_carts', name: 'this_year' } }

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

        context 'with last year' do
          let(:params) { { report: 'abandoned_carts', name: 'last_year' } }

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
  end
end
# rubocop:enable RSpec/LetSetup
# rubocop:enable RSpec/NestedGroups
# rubocop:enable RSpec/MultipleExpectations
# rubocop:enable RSpec/MultipleMemoizedHelpers
