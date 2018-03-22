view: dates {
  derived_table: {
    sql: SELECT(DATE_ADD(DATE(CURRENT_TIMESTAMP()), INTERVAL -1* n DAY)) as date
      FROM UNNEST(GENERATE_ARRAY(0,2000,1)) n
       ;;
    sql_trigger_value: SELECT CURRENT_DATE ;;
  }

  dimension_group: date {
    type: time
    datatype: date
    timeframes: [date, week, month, year]
    convert_tz: no
    sql: ${TABLE}.date ;;
  }
}
