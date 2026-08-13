view: context_tracks {
  sql_table_name: SALES_DEMO_CONTEXT_STORE.usage_analytics.tracks ;;
  label: "Product Events"

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

  dimension_group: event {
    label: "Event"
    type: time
    timeframes: [raw, time, date, day_of_week, hour_of_day, week, month, quarter, year]
    sql: ${TABLE}.timestamp ;;
  }

  dimension: event_name {
    label: "Event Name"
    type: string
    sql: ${TABLE}.event ;;
  }

  dimension: event_text {
    label: "Event Description"
    type: string
    sql: ${TABLE}.event_text ;;
  }

  dimension: event_category {
    label: "Event Category"
    description: "Groups raw events into the buckets a business sponsor cares about."
    type: string
    sql:
      case
        when ${TABLE}.event ilike 'discovery%' then 'Search & Discovery'
        when ${TABLE}.event ilike 'workflow%' then 'Workflows & Pipelines'
        when ${TABLE}.event ilike 'marketplace%' then 'Marketplace'
        when ${TABLE}.event ilike 'api_evaluator%' then 'API & Automation'
        when ${TABLE}.event ilike 'performance_metric%' then 'Performance'
        else 'Other'
      end ;;
  }

  dimension: page_path {
    label: "Page Path"
    type: string
    sql: ${TABLE}.context_page_path ;;
  }

  measure: count {
    label: "Events"
    type: count
    drill_fields: [event_time, context_users.name, event_name]
  }

  measure: unique_users {
    label: "Users Generating Events"
    type: count_distinct
    sql: ${TABLE}.user_id ;;
  }

  measure: search_events {
    label: "Search Events"
    type: count
    filters: [event_name: "discovery_search_results"]
  }
}
