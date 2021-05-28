# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable RSpec/NestedGroups
# rubocop:disable RSpec/MultipleMemoizedHelpers
describe Spree::Overview, type: :model do
  let(:store) { create(:store) }
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let(:line_items) do
    [create(:line_item, variant: product.master, quantity: 5)]
  end
  let(:params_with_count) do
    { from: (Time.zone.now.to_date - 1.week).to_s(:db), value: 'Count' }
  end
  let(:params_with_value) do
    { from: (Time.zone.now.to_date - 1.week).to_s(:db), value: 'Value' }
  end
  let(:overview) { described_class.new(params_with_count) }

  context 'with instance' do
    before do
      create(
        :completed_order_with_totals,
        user: user,
        line_items: line_items
      )
      create(
        :order,
        user: user,
        line_items: line_items,
        completed_at: nil,
        state: 'cart'
      )
    end

    describe '.orders_by_day' do
      describe 'with count' do
        let(:overview) { described_class.new(params_with_count) }

        it 'returns orders by day' do
          expect(overview.orders_by_day).not_to be_nil
        end
      end

      describe 'with value' do
        let(:overview) { described_class.new(params_with_value) }

        it 'returns orders by day' do
          expect(overview.orders_by_day).not_to be_nil
        end
      end
    end

    describe '.abandoned_carts_by_day' do
      it 'returns master variant' do
        expect(overview.orders_by_day('abandoned_carts')).not_to be_empty
      end
    end

    describe '.new_users_by_day' do
      it 'returns new users by day' do
        expect(overview.new_users_by_day).not_to be_empty
      end
    end

    describe '.orders_line_total' do
      it 'returns orders line total' do
        expect(overview.orders_line_total).not_to be_nil
      end
    end

    describe '.orders_total' do
      it 'returns orders total' do
        expect(overview.orders_total).not_to be_nil
      end
    end

    describe '.orders_adjustment_total' do
      it 'returns orders adjustment total' do
        expect(overview.orders_adjustment_total).not_to be_nil
      end
    end

    describe '.best_selling_variants' do
      it 'returns best selling variants' do
        expect(overview.best_selling_variants).not_to be_empty
      end
    end

    describe '.top_grossing_variants' do
      it 'returns top grossing variants' do
        expect(overview.top_grossing_variants).not_to be_empty
      end
    end

    describe '.best_selling_taxons' do
      it 'returns best selling taxons' do
        expect(overview.best_selling_taxons).not_to be_nil
      end
    end

    describe '.abandoned_carts' do
      it 'returns abandoned carts' do
        expect(overview.abandoned_carts).not_to be_nil
      end
    end

    describe '.checkout_steps' do
      it 'returns checkout steps' do
        expect(overview.checkout_steps).not_to be_empty
      end
    end

    describe '.abandoned_carts_products' do
      it 'returns abandoned carts products' do
        expect(overview.abandoned_carts_products).not_to be_empty
      end
    end

    describe '.biggest_spenders' do
      it 'returns biggest spenders' do
        expect(overview.biggest_spenders).not_to be_empty
      end
    end

    describe '.out_of_stock_products' do
      it 'returns cout of stock products' do
        expect(overview.out_of_stock_products).not_to be_empty
      end
    end

    describe '.last_orders' do
      it 'returns cout of stock products' do
        expect(overview.last_orders).not_to be_empty
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
# rubocop:enable RSpec/MultipleMemoizedHelpers
