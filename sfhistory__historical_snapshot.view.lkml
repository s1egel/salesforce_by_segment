view: historical_snapshot {
  derived_table: {
    sql_trigger_value: SELECT CURRENT_DATE ;;
    sql: with snapshot_window as ( select opportunity_history.*
                                  , coalesce(cast(lead(created_date,1) over(partition by opportunity_id order by created_date) as date), current_date) as stage_end
                                from salesforce.opportunity_history AS opportunity_history
                              )
      select dates.date as observation_date
        , snapshot_window.*
      from snapshot_window
      left join looker_scratch.LR_96M8UCQ2D0GIZPRVJD1HH_dates as dates
      on cast(dates.date as date) >= cast(snapshot_window.created_date as date)
      and cast(dates.date as date) <= cast(snapshot_window.stage_end as date)
      where dates.date <= current_date
 ;;
  }

  dimension_group: snapshot {
    type: time
    datatype: date
    timeframes: [date, week, month]
    description: "What snapshot date are you interetsed in?"
    sql: ${TABLE}.observation_date ;;
  }

  dimension: amount {
    type: number
    sql: CAST(${TABLE}.amount AS FLOAT64) ;;
  }

  dimension_group: close {
    type: time
    timeframes: [date, week, month]
    description: "At the time of snapshot, what was the projected close date?"
    sql: ${TABLE}.close_date ;;
  }

  dimension_group: created {
    hidden: yes
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created_date ;;
  }

  dimension: expected_revenue {
    type: number
    sql: CAST(${TABLE}.expected_revenue AS FLOAT64) ;;
  }

  dimension: forecast_category {
    type: string
    sql: ${TABLE}.forecast_category ;;
  }

  dimension: id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: opportunity_id {
    hidden: yes
    type: string
    sql: ${TABLE}.opportunity_id ;;
  }

  dimension: probability {
    type: number
    sql: CAST(${TABLE}.probability AS FLOAT64) ;;
  }

  dimension: probability_tier {
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

  dimension: stage_name {
    hidden: yes
    type: string
    sql: ${TABLE}.stage_name ;;
  }

  dimension: stage_name_funnel {
    type: string
    description: "At the time of snapshot, what funnel stage was the prospect in?"
    case: {
      when: {
        label: "Active Lead"
        sql: ${stage_name} = "Active Lead" ;;
      }
      when: {
        label: "Prospect"
        sql: ${stage_name} like "%Prospect%" ;;
      }
      when: {
        label: "Trial"
        sql: ${stage_name} like "%Trial%" ;;
      }
      when: {
        label: "Winning"
        sql: ${stage_name} in ("Proposal","Commit- Not Won","Negotiation") ;;
      }
      when: {
        label: "Won"
        sql: ${stage_name} = "Closed Won" ;;
      }
      when: {
        label: "Lost"
        sql: ${stage_name} like "%Closed%" ;;
      }
      else: "Unknown"
    }
  }

  dimension_group: stage_end {
    hidden: yes
    type: time
    datatype: date
    timeframes: [time, date, week, month]
    sql: ${TABLE}.stage_end ;;
  }

  measure: total_amount {
    type: sum
    description: "At the time of snapshot, what was the total projected ACV?"
    sql: ${amount} ;;
    value_format: "$#,##0"
    drill_fields: [id, account.name, snapshot_date, close_date, amount, probability, stage_name_funnel]
  }

  measure: count_opportunities {
    type: count_distinct
    sql: ${opportunity_id} ;;
  }

  set: detail {
    fields: [
      snapshot_date,
      id,
      opportunity_id,
      expected_revenue,
      amount,
      stage_name,
      close_date,
      stage_end_date
    ]
  }
}
