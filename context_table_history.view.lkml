# Daily snapshots of every table's governance state. This is what makes trend
# reporting possible: gold.assets only holds the current picture, so coverage
# regressions are invisible there.
view: context_table_history {
  sql_table_name: SALES_DEMO_CONTEXT_STORE.entity_history.table_history ;;
  label: "Governance History"

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.guid || '|' || ${TABLE}.snapshot_date ;;
  }

  dimension: guid {
    hidden: yes
    type: string
    sql: ${TABLE}.guid ;;
  }

  dimension: table_name {
    label: "Table"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: connector_name {
    label: "Source System"
    type: string
    sql: ${TABLE}.connectorname ;;
  }

  dimension_group: snapshot {
    label: "Snapshot"
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.snapshot_date ;;
  }

  dimension: certificate_status {
    label: "Certification"
    type: string
    sql: coalesce(${TABLE}.certificatestatus, 'Not Certified') ;;
  }

  dimension: is_verified {
    label: "Is Verified"
    type: yesno
    sql: ${TABLE}.certificatestatus = 'VERIFIED' ;;
  }

  dimension: has_description {
    label: "Has Description"
    type: yesno
    sql: coalesce(${TABLE}.userdescription, ${TABLE}.description) is not null ;;
  }

  dimension: has_owner {
    label: "Has Owner"
    type: yesno
    sql: coalesce(array_size(${TABLE}.ownerusers), 0) > 0 ;;
  }

  # ---------- Measures ----------

  measure: tables_in_snapshot {
    label: "Tables"
    type: count
  }

  measure: verified_count {
    label: "Verified"
    type: count
    filters: [is_verified: "yes"]
  }

  measure: documented_count {
    label: "Documented"
    type: count
    filters: [has_description: "yes"]
  }

  measure: undocumented_count {
    label: "Governance Debt (Undocumented)"
    description: "Tables carrying no description at that point in time. Rises whenever new data lands faster than it can be governed."
    type: count
    filters: [has_description: "no"]
  }

  measure: pct_documented {
    label: "% Documented"
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${documented_count} / nullif(${tables_in_snapshot}, 0) ;;
  }

  measure: pct_verified {
    label: "% Verified"
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${verified_count} / nullif(${tables_in_snapshot}, 0) ;;
  }

  measure: latest_snapshot {
    label: "Latest Snapshot"
    type: date
    sql: max(${TABLE}.snapshot_date) ;;
  }
}
