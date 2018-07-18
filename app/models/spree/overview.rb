module Spree
  class Overview
    attr_accessor :to, :from, :name, :value

    DEFAULT_COLORS = ['#0093DA', '#FF3500', '#92DB00', '#1AB3FF',
      '#FFB800'].freeze

    def initialize(params)
      @to = params[:to]
      @from = params[:from]
      @name = params[:name]
      @value = params[:value]
    end

    def orders_by_day
      if value == 'Count'
        orders = Spree::Order.select(:created_at).where(conditions)
        orders = orders.group_by { |o| o.created_at.to_date }
        fill_empty_entries(orders)

        orders.keys.sort.map do |key|
          [ key.strftime('%Y-%m-%d'), orders[key].size ]
        end
      else
        orders = Spree::Order.select([:created_at, :total]).where(conditions)
        orders = orders.group_by { |o| o.created_at.to_date }
        fill_empty_entries(orders)

        orders.keys.sort.map do |key|
          [ key.strftime('%Y-%m-%d'), orders[key].inject(0) do |s, o|
            s += o.total
          end ]
        end
      end
    end

    def orders_line_total
      Spree::Order.where(conditions).sum(:item_total)
    end

    def orders_total
      Spree::Order.where(conditions).sum(:total)
    end

    def orders_adjustment_total
      Spree::Order.where(conditions).sum(:adjustment_total)
    end

    def abandoned_carts
      [ [I18n.t('spree.simple_dash.abandoned_carts'), Spree::Order.abandoned_carts.size],
        [I18n.t('spree.simple_dash.completed_carts'), Spree::Order.complete.size] ]
    end

    def abandoned_carts_products
      line_items = Spree::LineItem.abandoned_orders

      line_items.sort { |x, y| y[1] <=> x[1] }
    end

    def checkout_steps
      orders = line_items = Spree::Order.abandoned_carts_steps.map do |v|
        [v[0].titleize, v[1]]
      end

      orders.sort { |x, y| y[1] <=> x[1] }
    end

    def best_selling_variants
      line_items =  Spree::LineItem.top_selling_by_variants.map do |v|
        variant = Spree::Variant.find(v[0])
        [variant.name, v[1]]
      end

      line_items.sort { |x, y| y[1] <=> x[1] }
    end

    def top_grossing_variants
      line_items = Spree::LineItem.top_grossing_by_variants.map do |v|
        variant = Spree::Variant.find(v[0])
        [variant.name, v[1]]
      end

      line_items.sort { |x, y| y[1] <=> x[1] }
    end

    def best_selling_taxons
      Spree::LineItem.top_selling_by_taxons
    end

    def last_orders(limit = 5)
      orders = Spree::Order.last_orders_by_line_items(limit).map do |o|
        qty = o.line_items.inject(0) { |sum, li| sum + li.quantity }
        [o.email, qty, o.total]
      end

      orders
    end

    def biggest_spenders
      spenders = Spree::Order.biggest_spenders.map do |o|
        orders = Spree::User.find(o[0]).orders
        qty = orders.size

        [orders.first.email, qty, o[1]]
      end

      spenders.sort { |x,y| y[2] <=> x[2] }
    end

    def out_of_stock_products
      Spree::Product.out_of_stock.limit(5)
    end

    private

    def fill_empty_entries(orders)
      from_date = from.to_date
      to_date = (to || Time.now).to_date

      (from_date..to_date).each do |date|
        orders[date] ||= []
      end
    end

    def conditions
      if to
        "completed_at >= '#{from}' AND completed_at <= '#{to}'"
      else
        "completed_at >= '#{from}'"
      end
    end
  end
end
