include: "sfbase__users.view.lkml"
view: sf__users {
  extends: [sfbase__users]

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    link: {
      label: "Sales Representative Dashboard"
      url: "/dashboards/salesforce_by_segment::representative_performance?sales_rep={{ value }}"
      icon_url: "http://www.looker.com/favicon.ico"
    }
  }

  filter: name_select {
    suggest_dimension: name
  }

  filter: department_select {
    suggest_dimension: department
  }

  # rep_comparitor currently depends on "account.business_segment" instead of the intended
  # "department" field. If a custom user table attribute "department" exists,
  # replace business_segment with it.
  dimension: rep_comparitor {
    sql: CASE
        WHEN {% condition name_select %} ${name} {% endcondition %}
          THEN CONCAT('1 - ', ${name})
        WHEN {% condition department_select %} ${sf__accounts.business_segment} {% endcondition %}
          THEN CONCAT('2 - Rest of ', ${sf__accounts.business_segment})
      ELSE '3 - Rest of Sales Team'
      END
       ;;
  }
}



# Dimension not in salesforce_by_segment schema
#  - dimension: created
#    timeframes: [date, week, month, raw]

#  - dimension: age_in_months
#    type: number
#    sql: datediff(days,${created_raw},current_date)
