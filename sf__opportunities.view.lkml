include: "sfbase__opportunities.view.lkml"
view: sf__opportunities {
  extends: [sfbase__opportunities]

  dimension: is_lost {
    type: yesno
    sql: ${is_closed} AND NOT ${is_won} ;;
  }

  dimension: probability_group {
    type: string
    case: {
      when: {
        label: "Won"
        sql: ${probability} = 100;;
        }
      when: {
        label: "Above 80%"
        sql: ${probability} > 80;;
        }
      when: {
        label: "60 - 80%"
        sql: ${probability} > 60;;
        }
      when: {
        label: "40 - 60%"
        sql: ${probability} > 40;;
        }
      when: {
        label: "20 - 40%"
        sql: ${probability} > 20;;
        }
      when: {
        label: "Under 20%"
        sql: ${probability} > 0;;
        }
      when: {
        label: "Lost"
        sql: ${probability} = 0;;
        }
    }
  }

  dimension: created_raw {
    type:  date_raw
    sql: ${TABLE}.created_date ;;
  }

  dimension: close_raw {
    type:  date_raw
    sql: ${TABLE}.close_date ;;
  }

  dimension: close_quarter {
    type: date_quarter
    sql: ${TABLE}.close_date ;;
  }

  dimension: days_open {
    type: number
    sql: datediff(days, ${created_raw}, coalesce(${close_raw}, current_date) ) ;;
  }

  dimension: created_to_closed_in_60 {
    hidden: yes
    type: yesno
    sql: ${days_open} <=60 AND ${is_closed} = 'yes' AND ${is_won} = 'yes' ;;
  }

  # measures #

  measure: total_revenue {
    type: sum
    sql: ${total_value_c} ;;
    value_format: "$#,##0"
  }

  measure: average_revenue_won {
    label: "Average Revenue (Closed/Won)"
    type: average
    sql: ${total_value_c} ;;

    filters: {
      field: is_won
      value: "Yes"
    }

    value_format: "$#,##0"
  }

  measure: average_revenue_lost {
    label: "Average Revenue (Closed/Lost)"
    type: average
    sql: ${total_value_c} ;;

    filters: {
      field: is_lost
      value: "Yes"
    }

    value_format: "$#,##0"
  }

  measure: total_pipeline_revenue {
    type: sum
    sql: ${total_value_c} ;;

    filters: {
      field: is_closed
      value: "No"
    }

    value_format: "[>=1000000]0.00,,\"M\";[>=1000]0.00,\"K\";$0.00"
  }

  measure: average_deal_size {
    type: average
    sql: ${total_value_c} ;;
    value_format: "$#,##0"
  }

  measure: count_won {
    type: count

    filters: {
      field: is_won
      value: "Yes"
    }

    drill_fields: [id, sf_accounts.name, opportunity_owners.name, created_date, close_date, total_revenue]
  }

  measure: average_days_open {
    type: average
    sql: ${days_open} ;;
  }

  measure: count_closed {
    type: count

    filters: {
      field: is_closed
      value: "Yes"
    }
  }

  measure: count_open {
    type: count

    filters: {
      field: is_closed
      value: "No"
    }
  }

  measure: count_lost {
    type: count

    filters: {
      field: is_closed
      value: "Yes"
    }

    filters: {
      field: is_won
      value: "No"
    }

    drill_fields: [id, sf_accounts.name, opportunity_owners.name, created_date, close_date, total_revenue]
  }

  measure: win_percentage {
    type: number
    sql: 100.00 * ${count_won} / NULLIF(${count_closed}, 0) ;;
    value_format: "#0.00\%"
  }

  measure: open_percentage {
    type: number
    sql: 100.00 * ${count_open} / NULLIF(${count}, 0) ;;
    value_format: "#0.00\%"
  }


## For use with opportunities.type
  measure: count_new_business_won {
    type: count
    filters: {
      field: is_won
      value: "yes"
    }
    filters: {
      field: type
      value: "New Business"
    }
    drill_fields: [id, sf_accounts.name, opportunity_owners.name, created_date, close_date, total_revenue]
  }

# For use with opportunities.type
  measure: count_new_business {
   type: count
   filters: {
      field: type
      value: "New Business"
    }
    drill_fields: [id, sf_accounts.name, opportunity_owners.name, type, created_date, close_date, total_revenue]
  }
}
