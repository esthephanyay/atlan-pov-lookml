view: encounters {
  sql_table_name: "ATLAN-HEALTHCARE-SNOWFLAKE".SILVER_HEALTHCARE.ENCOUNTERS ;;

  dimension: encounter_id {
    type: string
    sql: ${TABLE}.ENCOUNTER_ID ;;
    primary_key: yes
  }
  dimension: patient_id {
    type: string
    sql: ${TABLE}.PATIENT_ID ;;
  }
  dimension: diagnosis_code {
    type: string
    sql: ${TABLE}.DIAGNOSIS_CODE ;;
  }
  dimension_group: admit {
    type: time
    timeframes: [date, month, year, quarter]
    sql: ${TABLE}.ADMIT_DATE ;;
    label: "Admit"
  }
  measure: count {
    type: count
    label: "Total Encounters"
  }
}
