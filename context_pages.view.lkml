view: context_pages {
  sql_table_name: SALES_DEMO_CONTEXT_STORE.usage_analytics.pages ;;
  label: "Page Views"

  dimension: id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: user_id {
    hidden: yes
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: viewed {
    label: "Viewed"
    type: time
    timeframes: [raw, time, date, day_of_week, hour_of_day, week, month, quarter, year]
    sql: ${TABLE}.timestamp ;;
  }

  dimension: section {
    label: "Product Area"
    description: "Which part of Atlan the user landed on: discovery, asset profile, glossary, lineage, monitor."
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: page_title {
    label: "Page Title"
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: path {
    label: "Path"
    type: string
    sql: ${TABLE}.path ;;
  }

  dimension: active_persona {
    label: "Active Persona"
    type: string
    sql: ${TABLE}.active_persona ;;
  }

  # ---------- Asset context of the page view ----------

  dimension: asset_type {
    label: "Asset Type Viewed"
    type: string
    sql: ${TABLE}.asset_type ;;
  }

  dimension: asset_connector {
    label: "Source System Viewed"
    type: string
    sql: ${TABLE}.connector_name ;;
  }

  dimension: asset_qualified_name {
    label: "Asset Viewed"
    type: string
    sql: ${TABLE}.asset_qualified_name ;;
  }

  dimension: asset_guid {
    hidden: yes
    type: string
    sql: ${TABLE}.asset_guid ;;
  }

  dimension: viewed_asset_has_description {
    label: "Viewed Asset Has Description"
    type: yesno
    sql: ${TABLE}.has_description ;;
  }

  dimension: viewed_asset_has_owners {
    label: "Viewed Asset Has Owners"
    type: yesno
    sql: ${TABLE}.has_owners ;;
  }

  dimension: viewed_asset_has_classification {
    label: "Viewed Asset Has Tags"
    type: yesno
    sql: ${TABLE}.has_classification ;;
  }

  dimension: search_term {
    label: "Search Term"
    type: string
    sql: ${TABLE}.search ;;
  }

  dimension: matched_asset_count {
    label: "Search Result Count"
    type: number
    sql: ${TABLE}.matched_asset_count ;;
  }

  # ---------- Measures ----------

  measure: count {
    label: "Page Views"
    type: count
    drill_fields: [page_detail*]
  }

  measure: unique_users {
    label: "Active Users"
    type: count_distinct
    sql: ${TABLE}.user_id ;;
    drill_fields: [context_users.name, count]
  }

  # The amplitude session and session_uuid columns are empty in this tenant,
  # so anonymous_id is the only reliable device identifier available.
  measure: unique_devices {
    label: "Distinct Devices"
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
  }

  measure: active_days {
    label: "Active Days"
    type: count_distinct
    sql: ${TABLE}.timestamp::date ;;
  }

  measure: unique_assets_viewed {
    label: "Distinct Assets Viewed"
    type: count_distinct
    sql: ${TABLE}.asset_guid ;;
  }

  measure: searches {
    label: "Searches Run"
    type: count
    filters: [section: "discovery"]
  }

  measure: asset_profile_views {
    label: "Asset Profile Views"
    type: count
    filters: [section: "asset_profile"]
  }

  measure: views_per_user {
    label: "Page Views per Active User"
    type: number
    value_format_name: decimal_1
    sql: 1.0 * ${count} / nullif(${unique_users}, 0) ;;
  }

  set: page_detail {
    fields: [viewed_time, context_users.name, section, asset_type, asset_qualified_name]
  }
}
