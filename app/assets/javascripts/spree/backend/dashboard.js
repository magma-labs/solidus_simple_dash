function number_with_delimiter(number, delimiter, separator) {
  try {
    var delimiter = delimiter || ',';
    var separator = separator || '.';

    var parts = number.toString().split('.');
    parts[0] = parts[0].replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1' + delimiter);
    formatted_number = parts.join(separator);

    if (formatted_number.length >= 6 && formatted_number.length <= 9) {
      var arr = formatted_number.split(',');
      return arr[0] + ' k';
    } else if (formatted_number.length == 10) {
      var arr = formatted_number.split(',');
      return arr[0] + ' m';
    } else {
      return formatted_number
    }
  } catch(e) {
    return number
  }
}

function handle_orders_by_day(settings, r, e, t) {
  var new_points = eval(r);
  var element = e;
  var type = t;
  var title = '';

  if (new_points[0].length > 0) {
    settings.axes.xaxis.min = new_points[0][0][0].replace(/-/g, "/");
    settings.axes.xaxis.max = new_points[0][new_points[0].length -1][0].replace(/-/g, "/");
  }

  settings.axes.yaxis.label = jQuery("#by_day_value :selected").val();

  switch(type) {
    case 'orders_by_day':
      title = orders
      break;
    case 'abandoned_carts_by_day':
      title = abandoned_orders
      break;
    default:
      title = orders_by_day_title
  }

  jQuery(element + '_title > span').text(title + ' ' + jQuery("#by_day_value :selected").val() + ' ' + by_day + ' (' + jQuery("#by_day_reports :selected").text() + ')');
  jQuery(element).empty();
  jQuery.jqplot(type, new_points, settings);
}

function handle_orders_total(r) {
  var values = eval(r);

  jQuery('#orders_total').text(number_with_delimiter(values[0].orders_total));
  jQuery('#orders_line_total').text(number_with_delimiter(values[0].orders_line_total));
  jQuery('#orders_adjustment_total').text(number_with_delimiter(values[0].orders_adjustment_total));
}

function build_options(points, settings) {
  settings.axes.xaxis.min = points[0][0][0].replace(/-/g, "/"),
  settings.axes.xaxis.max = points[0][points[0].length -1][0].replace(/-/g, "/")//,

  return settings;
}

jQuery(document).ready(function() {
  var pie_graph_options = {
    grid: {
      background:'#fff',
      borderWidth: 0,
      borderColor: '#fff',
      shadow: false
    },
    seriesDefaults:{
      renderer: jQuery.jqplot.PieRenderer,
      rendererOptions: {
        padding: 6,
        sliceMargin: 0
      }
    },
    seriesColors: pie_colors
  }

  var series_graph_options = {
    title: {
      textColor: '#476D9B',
      fontSize: '12pt'
    },
    grid: {
      background:'#fff',
      gridLineColor:'#fff',
      borderColor: '#476D9B'
    },
    axes:{
      yaxis:{
        label:'Order (Count)',
        labelRenderer: jQuery.jqplot.CanvasAxisLabelRenderer,
        autoscale:true,
        tickOptions:{
          formatString:'%d',
          fontSize: '10pt',
          textColor: '#476D9B'
        },
        min: 0,
        tickInterval: 1
      },
      xaxis:{
        renderer: jQuery.jqplot.DateAxisRenderer,
        rendererOptions: {
          tickRenderer: jQuery.jqplot.CanvasAxisTickRenderer
        },
        tickOptions:{
          formatString:'%b %#d, %y',
          angle: -30,
          fontSize: '10pt',
          textColor: '#476D9B'
        },
        min: 0,
        max: 0//,
        //tickInterval: '1 day'
      }
    },
    series:[
      {
        lineWidth:3, color: '#0095DA', fillAndStroke: true, fill: true, fillColor: '#E6F7FF'
      }
    ],
    highlighter: {
      formatString: "Date: %s <br />Value: %s ",
      sizeAdjust: 7.5
    }
  }

  if (typeof(orders_by_day_points) == 'object') {
    var order_settings = build_options(orders_by_day_points, series_graph_options)
    var abandoned_carts_settings = build_options(abandoned_carts_by_day_points, series_graph_options)

    jQuery.jqplot('orders_by_day', orders_by_day_points, order_settings);
    jQuery.jqplot('abandoned_carts_by_day', abandoned_carts_by_day_points, abandoned_carts_settings);

    jQuery('#by-day-options select').change(function() {
      var report = jQuery("#by_day_reports :selected").val();
      var value = jQuery("#by_day_value :selected").val();

      jQuery.ajax({
        type: 'GET',
        url: 'overview/report_data',
        data: ({
          report: 'orders_by_day',
          name: report,
          value: value,
          authenticity_token: Spree.api_key
        }),
        success: function(r) {
          handle_orders_by_day(order_settings, r, '#orders_by_day', 'orders_by_day')
        }
      });

      jQuery.ajax({
        type: 'GET',
        url: 'overview/report_data',
        data: ({
          report: 'abandoned_carts',
          name: report,
          value: value,
          authenticity_token: Spree.api_key
        }),
        success: function(r) {
          handle_orders_by_day(abandoned_carts_settings, r, '#abandoned_carts_by_day', 'abandoned_carts_by_day')
        }
      });

      jQuery.ajax({
        type: 'GET',
        url: 'overview/report_data',
        data: ({
          report: 'orders_totals',
          name: report,
          authenticity_token: Spree.api_key
        }),
        success: handle_orders_total
      });
    });

    abandoned_carts = jQuery.jqplot('abandoned_carts', [abandoned_carts_points], pie_graph_options);
    abandoned_carts_products = jQuery.jqplot('abandoned_carts_products', [abandoned_carts_products_points], pie_graph_options);
    best_selling_variants = jQuery.jqplot('best_selling_products', [ best_selling_variants_points ], pie_graph_options);
    checkout_steps = jQuery.jqplot('checkout_steps', [checkout_steps_points], pie_graph_options);
    top_grossing_variants = jQuery.jqplot('top_grossing_products', [top_grossing_variants_points], pie_graph_options);
    tbest_selling_taxons = jQuery.jqplot('best_selling_taxons', [best_selling_taxons_points], pie_graph_options);
  }
});
