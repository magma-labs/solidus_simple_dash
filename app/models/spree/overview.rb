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

    def orders_by_day(type = 'orders')
      if value == 'Count'
        orders = Spree::Order.select(:created_at).where(conditions(type))
        orders = orders.group_by { |o| o.created_at.to_date }
        fill_empty_entries(orders)

        orders.keys.sort.map do |key|
          [ key.strftime('%Y-%m-%d'), orders[key].size ]
        end
      else
        orders = Spree::Order.select([:created_at, :total]).where(conditions(type))
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

    def abandoned_carts(limit = 5)
      abandoned_carts = Spree::Order.abandoned_carts.first(limit).size
      order_completed = Spree::Order.complete.first(limit).size

      [ [I18n.t('spree.simple_dash.abandoned_carts'), abandoned_carts],
        [I18n.t('spree.simple_dash.completed_carts'), order_completed] ]
    end

    def abandoned_carts_products(limit = 5)
      line_items = Spree::LineItem.abandoned_orders.first(limit)

      line_items.sort { |x, y| y[1] <=> x[1] }
    end

    def checkout_steps(limit = 5)
      orders = Spree::Order.abandoned_carts_steps.first(limit)

      items = orders.map do |o|
        [o[0].titleize, o[1]]
      end

      items.sort { |x, y| y[1] <=> x[1] }
    end

    def best_selling_variants(limit = 5)
      line_items = Spree::LineItem.top_selling_by_variants.first(5)

      items = line_items.map do |li|
        next unless variant = Spree::Variant.with_deleted.find_by(id: li[0])

        [variant.name, li[1]]
      end.compact

      items.sort { |x, y| y[1] <=> x[1] }
    end

    def top_grossing_variants(limit = 5)
      line_items = Spree::LineItem.top_grossing_by_variants.first(limit)

      items = line_items.map do |li|
        next unless variant = Spree::Variant.with_deleted.find_by(id: li[0])

        [variant.name, li[1]]
      end.compact

      items.sort { |x, y| y[1] <=> x[1] }
    end

    def best_selling_taxons(limit = 5)
      Spree::LineItem.top_selling_by_taxons.first(limit)
    end

    def last_orders(limit = 5)
      orders = Spree::Order.last_orders_by_line_items.first(limit)

      items = orders.map do |o|
        next unless o.line_items

        qty = o.line_items.inject(0) { |sum, li| sum + li.quantity }
        [o.email, qty, o.total]
      end.compact

      items
    end

    def biggest_spenders(limit = 5)
      spenders = Spree::Order.biggest_spenders.first(limit)

      items = spenders.map do |o|
        next unless user = Spree::User.find_by(id: o[0])

        orders = user.orders
        qty = orders.size
        [orders.first.email, qty, o[1]]
      end.compact

      items.sort { |x,y| y[2] <=> x[2] }
    end

    def out_of_stock_products
      Spree::Product.out_of_stock.first(5)
    end

    private

    def fill_empty_entries(orders)
      from_date = from.to_date
      to_date = (to || Time.now).to_date

      (from_date..to_date).each do |date|
        orders[date] ||= []
      end
    end

    def conditions(type = 'orders')
      query = if to
        "completed_at >= '#{from}' AND completed_at <= '#{to}'"
      else
        "completed_at >= '#{from}'"
      end

      query << " AND state != 'complete'" if type == 'abandoned_carts'
      query << " AND state = 'complete'" if type == 'orders'
      query
     end
  end
end
