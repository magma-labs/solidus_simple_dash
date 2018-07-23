# this clas was inspired (heavily) from the mephisto admin architecture

module Spree
  module Admin
    class OverviewController < Spree::Admin::BaseController
      before_action :display_ability
      before_action :set_date
      before_action :date_range, only: :report_data

      def index
        return unless display_ability

        @best_selling_variants = LazyObject.new { overview.best_selling_variants }
        @top_grossing_variants = LazyObject.new { overview.top_grossing_variants }
        @best_selling_taxons = LazyObject.new { overview.best_selling_taxons }
        @abandoned_carts = LazyObject.new { overview.abandoned_carts }
        @checkout_steps = LazyObject.new { overview.checkout_steps }
        @abandoned_carts_products = LazyObject.new { overview.abandoned_carts_products }

        @orders_by_day = LazyObject.new { overview.orders_by_day }
        @abandoned_carts_by_day = LazyObject.new { overview.orders_by_day('abandoned_carts') }
        @orders_line_total = LazyObject.new { overview.orders_line_total }
        @orders_total = LazyObject.new { overview.orders_total }
        @orders_adjustment_total = LazyObject.new { overview.orders_adjustment_total }

        @last_five_orders = LazyObject.new { overview.last_orders }
        @biggest_spenders = LazyObject.new { overview.biggest_spenders }
        @out_of_stock_products = LazyObject.new { overview.out_of_stock_products }

        @pie_colors = Spree::Overview::DEFAULT_COLORS
      end

      def report_data
        values = case params[:report]
          when 'abandoned_carts'
            '[[' + overview.orders_by_day('abandoned_carts').map do |day|
              "['#{day[0]}', #{day[1]}]"
            end.join(',') + ']]'
          when 'orders_by_day'
            '[[' + overview.orders_by_day.map do |day|
              "['#{day[0]}', #{day[1]}]"
            end.join(',') + ']]'
          when 'orders_totals'
            [orders_total: overview.orders_total.to_i,
              orders_line_total: overview.orders_line_total.to_i,
              orders_adjustment_total: overview.orders_adjustment_total.to_i
            ].to_json
        end

        render js: values
      end

      private

      def overview
        @overview ||= Spree::Overview.new(params)
      end

      def display_ability
        @display_ability ||= Spree::Order.count > 10
      end

      def set_date
        params.merge!({ from: (Time.new().to_date - 1.week).to_s(:db),
          value: 'Count' })
      end

      def date_range
        from = Date.new(Time.now.year, Time.now.month, 1)
        to = Date.new(Time.now.year, Time.now.month, -1)

        dates = case params[:name]
          when '7_days'
            { from: (Time.new().to_date - 1.week).to_s(:db) }
          when '14_days'
            { from: (Time.new().to_date - 2.week).to_s(:db) }
          when 'this_month'
            { from: from.to_s(:db),
              to: to.to_s(:db) }
          when 'last_month'
            { from: (from - 1.month).to_s(:db),
              to: (to - 1.month).to_s(:db) }
          when 'this_year'
            { from: Date.new(Time.now.year, 1, 1).to_s(:db) }
          when 'last_year'
            { from: Date.new(Time.now.year - 1, 1, 1).to_s(:db),
              to: Date.new(Time.now.year - 1, 12, -1).to_s(:db) }
        end

        params.merge!(dates)
      end
    end
  end
end
