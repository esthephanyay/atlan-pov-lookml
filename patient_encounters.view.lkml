view: patient_encounters {
  sql_table_name: "ATLAN-HEALTHCARE-SNOWFLAKE".SILVER_HEALTHCARE.PATIENT_ENCOUNTERS ;;

  dimension: encounter_id {
    type: string
    sql: ${TABLE}.ENCOUNTER_ID ;;
    primary_key: yes
  }
  dimension: patient_id {
    type: string
    sql: ${TABLE}.PATIENT_ID ;;
  }
  dimension_group: admission {
    type: time
    timeframes: [date, month, year, quarter]
    sql: ${TABLE}.ADMISSION_DATE ;;
    label: "Admission"
  }
  dimension_group: discharge {
    type: time
    timeframes: [date, month, year]
    sql: ${TABLE}.DISCHARGE_DATE ;;
    label: "Discharge"
  }
  dimension: length_of_stay_days {
    type: number
    sql: DATEDIFF(day, ${TABLE}.ADMISSION_DATE, ${TABLE}.DISCHARGE_DATE) ;;
    label: "Length of Stay (Days)"
  }
  measure: count {
    type: count
    label: "Total Encounters"
  }
  measure: avg_length_of_stay {
    type: average
    sql: DATEDIFF(day, ${TABLE}.ADMISSION_DATE, ${TABLE}.DISCHARGE_DATE) ;;
    label: "Avg Length of Stay (Days)"
    value_format_name: decimal_1
  }
  measure: total_patients {
    type: count_distinct
    sql: ${TABLE}.PATIENT_ID ;;
    label: "Unique Patients"
  }
}
