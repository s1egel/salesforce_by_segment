include: "sfbase__accounts.view.lkml"
view: sf__accounts {
  extends: [sfbase__accounts]

  filter: created_date_filter {
    type: date
  }

  dimension: number_of_employees {
    type: number
    sql: ${TABLE}.number_of_employees ;;
  }

  dimension: is_in_date_filter {
    type: yesno
    sql: {% condition created_date_filter %} ${created_date} {% endcondition %}
      ;;
  }

  dimension: created {
    #X# Invalid LookML inside "dimension": {"timeframes":["date","week","month","raw"]}
  }

  dimension: business_segment {
    type: string

    case: {
      when: {
        sql: ${number_of_employees} BETWEEN 0 AND 500 ;;
        label: "Small Business"
      }

      when: {
        sql: ${number_of_employees} BETWEEN 501 AND 1000 ;;
        label: "Mid-Market"
      }

      when: {
        sql: ${number_of_employees} > 1000 ;;
        label: "Enterprise"
      }

      else: "Unknown"
    }
  }

  dimension: annual_revenue {
    type: number
    sql: ${TABLE}.total_active_arr_c ;;
  }

  # measures #

  measure: customer_created_in_date_filter {
    type: count

    filters: {
      field: is_in_date_filter
      value: "yes"
    }
  }

  measure: percent_of_accounts {
    type: percent_of_total
    sql: ${count} ;;
  }

  measure: average_annual_revenue {
    type: average
    sql: ${annual_revenue} ;;
    value_format: "$#,##0"
  }

  measure: total_number_of_employees {
    type: sum
    sql: ${number_of_employees} ;;
  }

  measure: average_number_of_employees {
    type: average
    sql: ${number_of_employees} ;;
  }

  measure: count_customers {
    type: count

    filters: {
      field: type
      value: "\"Customer\""
    }
  }
}
