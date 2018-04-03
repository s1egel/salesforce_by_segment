view: opportunity_facts {
  derived_table: {
    sql_trigger_value: SELECT CURRENT_DATE ;;
    sql: select account_id
        , sum(case
                when stage_name = "Closed Won"
                then 1
                else 0
              end) as lifetime_opportunities_won
        , sum(case
                when stage_name = "Closed Won"
                then CAST(arr_c AS FLOAT64)
                else 0
              end) as lifetime_acv
      from salesforce.opportunities
      group by 1
 ;;
  }

  dimension: account_id {
    type: string
    sql: ${TABLE}.account_id ;;
  }

  dimension: lifetime_opportunities_won {
    type: number
    sql: ${TABLE}.lifetime_opportunities_won ;;
  }

  dimension: lifetime_acv {
    label: "Lifetime ACV"
    type: number
    sql: ${TABLE}.lifetime_acv ;;
  }
}
