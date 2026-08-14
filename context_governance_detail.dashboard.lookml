# Detail companion to context_governance. Certification breakdown deliberately
# lives on the MDLH dashboard only, to avoid showing the same pie twice.
- dashboard: context_governance_detail
  title: "Governance and Adoption Detail"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Breakdowns behind the executive KPIs: coverage by source, governance tiers, adoption patterns and the most viewed assets."

  filters:
  - name: date_range
    title: "Date Range"
    type: field_filter
    default_value: "90 days"
    allow_multiple_values: true
    required: false
    model: context_lakehouse
    explore: context_pages
    field: context_pages.viewed_date

  - name: asset_type
    title: "Asset Type"
    type: field_filter
    default_value: "Table,View,TablePartition,MaterialisedView"
    allow_multiple_values: true
    required: false
    model: context_lakehouse
    explore: context_assets
    field: context_assets.asset_type

  - name: source_system
    title: "Source System"
    type: field_filter
    allow_multiple_values: true
    required: false
    model: context_lakehouse
    explore: context_assets
    field: context_assets.connector_name

  elements:

  # ---------- Governance breakdowns ----------

  - title: "Governance Coverage by Source System"
    name: coverage_by_source
    model: context_lakehouse
    explore: context_assets
    type: looker_column
    fields: [context_assets.connector_name, context_assets.pct_documented, context_assets.pct_owned, context_assets.pct_with_terms, context_assets.pct_with_lineage]
    sorts: [context_assets.pct_documented desc]
    limit: 12
    listen:
      asset_type: context_assets.asset_type
      source_system: context_assets.connector_name
    row: 0
    col: 0
    width: 16
    height: 7

  - title: "Assets by Governance Tier"
    name: governance_tier
    model: context_lakehouse
    explore: context_assets
    type: looker_bar
    fields: [context_assets.governance_tier, context_assets.count]
    sorts: [context_assets.governance_tier]
    listen:
      asset_type: context_assets.asset_type
      source_system: context_assets.connector_name
    row: 0
    col: 16
    width: 8
    height: 7

  - title: "Verified Tables Trend"
    name: trend_verified
    model: context_lakehouse
    explore: context_table_history
    type: looker_line
    fields: [context_table_history.snapshot_date, context_table_history.verified_count]
    sorts: [context_table_history.snapshot_date]
    limit: 500
    note_state: expanded
    note_display: below
    note_text: "Steady stewardship progress: 190 verified in March, 218 by August. Certification is climbing, just far slower than new data arrives."
    row: 7
    col: 0
    width: 16
    height: 7

  - title: "Latest Snapshot"
    name: trend_freshness
    model: context_lakehouse
    explore: context_table_history
    type: single_value
    fields: [context_table_history.latest_snapshot]
    note_state: expanded
    note_display: below
    note_text: "Freshness of the history feed. Check this before presenting the trend as live."
    row: 7
    col: 16
    width: 8
    height: 7

  # ---------- Adoption ----------

  - title: "Adoption Over Time"
    name: adoption_trend
    model: context_lakehouse
    explore: context_pages
    type: looker_line
    fields: [context_pages.viewed_week, context_pages.unique_users, context_pages.count]
    sorts: [context_pages.viewed_week]
    listen:
      date_range: context_pages.viewed_date
    row: 14
    col: 0
    width: 16
    height: 7

  - title: "Where Users Spend Their Time"
    name: product_area
    model: context_lakehouse
    explore: context_pages
    type: looker_bar
    fields: [context_pages.section, context_pages.count, context_pages.unique_users]
    sorts: [context_pages.count desc]
    limit: 10
    listen:
      date_range: context_pages.viewed_date
    row: 14
    col: 16
    width: 8
    height: 7

  - title: "Most Viewed Assets"
    name: top_assets
    model: context_lakehouse
    explore: context_pages
    type: looker_grid
    fields: [context_assets.asset_name, context_assets.asset_type, context_assets.connector_name, context_assets.certificate_status, context_pages.count]
    filters:
      context_pages.asset_guid: "-NULL"
      context_assets.asset_name: "-NULL"
    sorts: [context_pages.count desc]
    limit: 15
    listen:
      date_range: context_pages.viewed_date
    row: 21
    col: 0
    width: 24
    height: 7
