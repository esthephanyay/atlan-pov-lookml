view: claims {
  sql_table_name: "ATLAN-HEALTHCARE-SNOWFLAKE".SILVER_HEALTHCARE.CLAIMS ;;

  dimension: claim_id {
    type: string
    sql: ${TABLE}.CLAIM_ID ;;
    primary_key: yes
  }
  dimension: encounter_id {
    type: string
    sql: ${TABLE}.ENCOUNTER_ID ;;
  }
  dimension: claim_status {
    type: string
    sql: ${TABLE}.CLAIM_STATUS ;;
  }
  dimension: billed_amount {
    type: number
    sql: ${TABLE}.BILLED_AMOUNT ;;
    value_format_name: usd
  }
  measure: count {
    type: count
    label: "Total Claims"
  }
  measure: total_billed {
    type: sum
    sql: ${TABLE}.BILLED_AMOUNT ;;
    label: "Total Billed Amount"
    value_format_name: usd_0
  }
  measure: avg_billed {
    type: average
    sql: ${TABLE}.BILLED_AMOUNT ;;
    label: "Avg Claim Amount"
    value_format_name: usd
  }
}
