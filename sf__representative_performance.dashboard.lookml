- dashboard: representative_performance
  title: "Sales Representative Performance Dashboard"
  layout: tile
  tile_size: 100

  filters:

  - name: sales_rep
    type: field_filter
    explore: sf__opportunities
    field: opportunity_owners.name

  - name: sales_segment
    type: field_filter
    explore: sf__accounts
    field: sf__accounts.business_segment
    default_value: 'Enterprise'

  elements:

  - name: count_won_deals
    title: 'Count of Won Deals (This Quarter)'
    type: single_value
    model: salesforce_by_segment
    explore: sf__opportunities
    measures: [sf__opportunities.count_won]
    listen:
      sales_segment: sf__accounts.business_segment
      sales_rep: opportunity_owners.name
    filters:
      sf__opportunities.close_date: 'this quarter'
      sf__opportunities.is_won: 'yes'
    limit: 500
    font_size: small
    text_color: '#49719a'
    width: 3
    height: 2

  - name: salesrep_total_revenue
    title: 'Salesrep - Total Revenue (This Quarter)'
    type: single_value
    model: salesforce_by_segment
    explore: sf__opportunities
    measures: [sf__opportunities.total_revenue]
    listen:
      sales_segment: sf__accounts.business_segment
      sales_rep: opportunity_owners.name
    filters:
      sf__opportunities.close_date: 'this quarter'
      sf__opportunities.is_won: 'yes'
    limit: 500
    font_size: small
    text_color: '#49719a'
    width: 3
    height: 2

  - name: count_lost_deals
    title: 'Count of Lost Deals (This Quarter)'
    type: single_value
    model: salesforce_by_segment
    explore: sf__opportunities
    measures: [sf__opportunities.count_lost]
    listen:
      sales_segment: sf__accounts.business_segment
      sales_rep: opportunity_owners.name
    filters:
      sf__opportunities.close_date: 'this quarter'
    limit: 500
    font_size: small
    text_color: '#49719a'
    width: 3
    height: 2

  - name: win_percentage
    title: 'Win Percentage of Closed Deals (This Quarter)'
    type: single_value
    model: salesforce_by_segment
    explore: sf__opportunities
    measures: [sf__opportunities.win_percentage]
    listen:
      sales_segment: sf__accounts.business_segment
      sales_rep: opportunity_owners.name
    filters:
      sf__opportunities.close_date: 'this quarter'
    limit: 500
    font_size: small
    text_color: '#49719a'
    width: 3
    height: 2

  - name: opportunities_to_wins_trend_peers
    title: 'Opportunities to Wins Trend vs. Peers'
    type: looker_line
    model: salesforce_by_segment
    explore: sf__opportunities
    dimensions: [sf__opportunities.created_month, opportunity_owners.rep_comparitor]
    pivots: [opportunity_owners.rep_comparitor]
    measures: [sf__opportunities.count, sf__opportunities.count_won]
    dynamic_fields:
    - table_calculation: opportunities_to_won
      label: opportunities_to_won
      expression: 1.0*${sf__opportunities.count_won}/${sf__opportunities.count}
      value_format: '#.0%'
    hidden_fields: [sf__opportunities.count_won, sf__opportunities.count]
    listen:
      sales_segment: opportunity_owners.department_select
      sales_rep: opportunity_owners.name_select
    filters:
      sf__opportunities.created_month: 9 months ago for 9 months
    sorts: [sf__opportunities.created_month desc, opportunity_owners.rep_comparitor]
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    stacking: ''
    colors: ['#635189', '#b3a0dd', '#a2dcf3', '#1ea8df']
    show_value_labels: false
    label_density: 25
    font_size: small
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_value_format: '#%'
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    show_null_points: true
    point_style: none
    interpolation: linear
    width: 12
    height: 4

  - name: salesrep_revenue_won_comparison
    title: 'SalesRep - Revenue Won comparison'
    type: looker_bar
    model: salesforce_by_segment
    explore: sf__opportunities
    dimensions: [opportunity_owners.rep_comparitor]
    measures: [sf__opportunities.average_revenue_won]
    listen:
      sales_segment: opportunity_owners.department_select
      sales_rep: opportunity_owners.name_select
    sorts: [opportunity_owners.rep_comparitor]
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: ''
    colors: ['#a2dcf3']
    show_value_labels: true
    label_density: 25
    label_color: ['#635189']
    font_size: small
    legend_position: center
    hide_legend: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_labels: [Total Revenue Won]
    y_axis_tick_density: default
    show_x_axis_label: false
    show_x_axis_ticks: true
    x_axis_scale: auto
    show_null_labels: false
    width: 6
    height: 3

  - name: salesrep_win_rate_comparison
    title: 'SalesRep - Win Rate Comparison'
    type: looker_bar
    model: salesforce_by_segment
    explore: sf__opportunities
    dimensions: [opportunity_owners.rep_comparitor]
    measures: [sf__opportunities.win_percentage]
    listen:
      sales_segment: opportunity_owners.department_select
      sales_rep: opportunity_owners.name_select
    sorts: [opportunity_owners.rep_comparitor]
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: ''
    colors: ['#a2dcf3']
    show_value_labels: true
    label_density: 25
    label_color: ['#635189']
    font_size: small
    legend_position: center
    hide_legend: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_labels: [sf__opportunities Win Rate]
    y_axis_tick_density: default
    show_x_axis_label: false
    show_x_axis_ticks: true
    x_axis_scale: auto
    show_null_labels: false
    width: 6
    height: 3

  - name: salesrep_revenue_pipeline_comparison
    title: 'SalesRep - Revenue Pipeline comparison'
    type: looker_bar
    model: salesforce_by_segment
    explore: sf__opportunities
    dimensions: [opportunity_owners.rep_comparitor]
    measures: [sf__users_opportunities.average_revenue_pipeline]
    listen:
      sales_segment: opportunity_owners.department_select
      sales_rep: opportunity_owners.name_select
    sorts: [opportunity_owners.rep_comparitor]
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: ''
    colors: ['#a2dcf3']
    show_value_labels: true
    label_density: 25
    label_color: ['#635189']
    font_size: small
    legend_position: center
    hide_legend: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_labels: [Total Revenue Pipeline]
    y_axis_tick_density: default
    show_x_axis_label: false
    show_x_axis_ticks: true
    x_axis_scale: auto
    show_null_labels: false
    width: 6
    height: 3
