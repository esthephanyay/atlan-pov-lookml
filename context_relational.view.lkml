view: context_relational {
  sql_table_name: SALES_DEMO_CONTEXT_STORE.gold.relational_asset_details ;;
  label: "Storage and Volume"

  dimension: guid {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.guid ;;
  }

  dimension: database_name {
    label: "Database"
    type: string
    sql: ${TABLE}.database_name ;;
  }

  dimension: schema_name {
    label: "Schema"
    type: string
    sql: ${TABLE}.schema_name ;;
  }

  dimension: table_row_count {
    label: "Row Count"
    type: number
    sql: ${TABLE}.table_row_count ;;
  }

  dimension: table_column_count {
    label: "Column Count"
    type: number
    sql: ${TABLE}.table_column_count ;;
  }

  dimension: size_gb {
    label: "Size (GB)"
    type: number
    value_format_name: decimal_3
    sql: ${TABLE}.table_size_bytes / power(1024, 3) ;;
  }

  dimension: size_mb {
    label: "Size (MB)"
    type: number
    value_format_name: decimal_1
    sql: ${TABLE}.table_size_bytes / power(1024, 2) ;;
  }

  dimension: has_size {
    label: "Has Size Reported"
    type: yesno
    sql: ${TABLE}.table_size_bytes is not null ;;
  }

  dimension: table_total_read_count {
    label: "Total Reads"
    type: number
    sql: ${TABLE}.table_total_read_count ;;
  }

  dimension: table_queries {
    label: "Query Count"
    type: number
    sql: ${TABLE}.table_queries ;;
  }

  dimension: size_band {
    label: "Size Band"
    type: string
    sql:
      case
        when ${TABLE}.table_size_bytes is null then 'Unknown'
        when ${TABLE}.table_size_bytes >= power(1024, 3) then '1. 1 GB and above'
        when ${TABLE}.table_size_bytes >= 100 * power(1024, 2) then '2. 100 MB to 1 GB'
        when ${TABLE}.table_size_bytes >= 10 * power(1024, 2) then '3. 10 to 100 MB'
        else '4. Under 10 MB'
      end ;;
  }

  measure: total_size_gb {
    label: "Total Size (GB)"
    type: sum
    value_format_name: decimal_2
    sql: ${size_gb} ;;
  }

  measure: total_rows {
    label: "Total Rows"
    type: sum
    sql: ${table_row_count} ;;
  }

  measure: avg_size_mb {
    label: "Avg Size (MB)"
    type: average
    value_format_name: decimal_1
    sql: ${size_mb} ;;
  }

  measure: total_reads {
    label: "Total Reads"
    type: sum
    sql: ${table_total_read_count} ;;
  }
}
