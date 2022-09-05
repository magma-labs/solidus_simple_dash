# frozen_string_literal: true

module Spree
  class Overview
    attr_accessor :to, :from, :name, :value

    DEFAULT_COLORS = [
      '#0093DA',
      '#FF3500',
      '#92DB00',
      '#1AB3FF',
      '#FFB800'
    ].freeze

    def initialize(params)
      @to = params[:to]
      @from = params[:from]
      @name = params[:name]
      @value = params[:value] || 'Count'
    end

    def orders_by_day(type = 'orders')
      if value == 'Count'
        orders = Spree::Order.select(:created_at).where(conditions(type))
        orders = orders.group_by { |o| o.created_at.to_date }
        fill_empty_entries(orders)

        orders.keys.sort.map do |key|
          [key.strftime('%Y-%m-%d'), orders[key].size]
        end
      else
        orders = Spree::Order.select([:created_at, :total]).where(conditions(type))
        orders = orders.group_by { |o| o.created_at.to_date }
        fill_empty_entries(orders)

        orders.keys.sort.map do |key|
          [key.strftime('%Y-%m-%d'), orders[key].inject(0) do |_s, o|
            o.total
          end]
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
      abandoned_carts = Spree::Order.abandoned_carts.take(limit).size
      order_completed = Spree::Order.complete.take(limit).size

      [[I18n.t('spree.simple_dash.abandoned_carts'), abandoned_carts],
       [I18n.t('spree.simple_dash.completed_carts'), order_completed]]
    end

    def new_users_by_day
      users = Spree.user_class.select(:created_at).order('created_at ASC')
      users = users.group_by { |u| u.created_at.to_date }
      fill_empty_entries(users)

      users.keys.sort.map do |key|
        [key.strftime('%Y-%m-%d'), users[key].size]
      end
    end

    def abandoned_carts_products(limit = 5)
      line_items = Spree::LineItem.abandoned_orders.take(limit)

      line_items.sort { |x, y| y[1] <=> x[1] }
    end

    def checkout_steps(limit = 5)
      orders = Spree::Order.abandoned_carts_steps.take(limit)

      items = orders.map do |o|
        [o[0].titleize, o[1]]
      end

      items.sort { |x, y| y[1] <=> x[1] }
    end

    def best_selling_variants(limit = 5)
      line_items = Spree::LineItem.top_selling_by_variants.take(limit)

      items = line_items.map do |li|
        next if variant_discarded?(li[0])

        variant = find_variant(li[0])
        [variant.name, li[1]]
      end.compact

      items.sort { |x, y| y[1] <=> x[1] }
    end

    def top_grossing_variants(limit = 5)
      line_items = Spree::LineItem.top_grossing_by_variants.take(limit)

      items = line_items.map do |li|
        next if variant_discarded?(li[0])

        variant = find_variant(li[0])
        [variant.name, li[1]]
      end.compact

      items.sort { |x, y| y[1] <=> x[1] }
    end

    def best_selling_taxons(limit = 5)
      Spree::LineItem.top_selling_by_taxons.take(limit)
    end

    def last_orders(limit = 5)
      orders = Spree::Order.last_orders_by_line_items.take(limit)

      orders.map do |o|
        next unless o.line_items

        qty = o.line_items.inject(0) do |sum, li|
          sum + li.quantity
        end

        [o.email, qty, o.total]
      end.compact
    end

    def biggest_spenders(limit = 5)
      spenders = Spree::Order.biggest_spenders.take(limit)

      items = spenders.map do |o|
        next unless user = Spree.user_class.find_by(id: o[0])

        orders = user.orders
        qty = orders.size
        [orders.first.email, qty, o[1]]
      end.compact

      items.sort { |x, y| y[2] <=> x[2] }
    end

    def out_of_stock_products
      Spree::Product.out_of_stock.take(5)
    end

    private

    def find_variant(variant_id)
      Spree::Variant.find_by(id: variant_id)
    end

    def variant_discarded?(variant_id)
      if Spree.solidus_gem_version >= Gem::Version.new('3')
        Spree::Variant.with_discarded.find_by(id: variant_id).discarded?
      else
        Spree::Variant.discarded.find_by(id: variant_id).present?
      end
    end

    def fill_empty_entries(items)
      from_date = from.to_date
      to_date = (to || Time.zone.now).to_date

      (from_date..to_date).each do |date|
        items[date] ||= []
      end
    end

    def conditions(type = 'orders')
      query = []

      query << if to
                 Arel.sql(
                   "#{Spree::Order.quoted_table_name}.completed_at >= '#{from}'
                   AND #{Spree::Order.quoted_table_name}.completed_at <= '#{to}'"
                 )
               else
                 Arel.sql(
                   "#{Spree::Order.quoted_table_name}.completed_at >= '#{from}'"
                 )
               end

      query << if type == 'abandoned_carts'
                 Arel.sql(
                   " AND #{Spree::Order.quoted_table_name}.state != 'complete'"
                 )
               end

      query << if type == 'orders'
                 Arel.sql(
                   " AND #{Spree::Order.quoted_table_name}.state = 'complete'"
                 )
               end

      query.join
    end
  end
end
