# Executive view. Deliberately short so the whole story is reachable without
# scrolling during a live demo. Everything else lives in
# context_governance_detail.
- dashboard: context_governance
  title: "Governance and Adoption KPIs"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Executive view: is governance coverage improving or eroding, and is the catalogue actually being used."

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

  # ---------- KPI row ----------

  - title: "Assets Catalogued"
    name: kpi_assets
    model: context_lakehouse
    explore: context_assets
    type: single_value
    fields: [context_assets.count]
    listen:
      asset_type: context_assets.asset_type
      source_system: context_assets.connector_name
    row: 0
    col: 0
    width: 5
    height: 3

  - title: "% Verified"
    name: kpi_verified
    model: context_lakehouse
    explore: context_assets
    type: single_value
    fields: [context_assets.pct_verified]
    listen:
      asset_type: context_assets.asset_type
      source_system: context_assets.connector_name
    row: 0
    col: 5
    width: 5
    height: 3

  - title: "% Documented"
    name: kpi_documented
    model: context_lakehouse
    explore: context_assets
    type: single_value
    fields: [context_assets.pct_documented]
    listen:
      asset_type: context_assets.asset_type
      source_system: context_assets.connector_name
    row: 0
    col: 10
    width: 5
    height: 3

  - title: "Active Users"
    name: kpi_users
    model: context_lakehouse
    explore: context_pages
    type: single_value
    fields: [context_pages.unique_users]
    listen:
      date_range: context_pages.viewed_date
    row: 0
    col: 15
    width: 4
    height: 3

  - title: "Searches Run"
    name: kpi_searches
    model: context_lakehouse
    explore: context_pages
    type: single_value
    fields: [context_pages.searches]
    listen:
      date_range: context_pages.viewed_date
    row: 0
    col: 19
    width: 5
    height: 3

  # ---------- Headline: improving or eroding ----------

  - title: "Documentation Coverage Over Time"
    name: trend_documented
    model: context_lakehouse
    explore: context_table_history
    type: looker_line
    fields: [context_table_history.snapshot_date, context_table_history.pct_documented, context_table_history.pct_verified]
    sorts: [context_table_history.snapshot_date]
    limit: 500
    note_state: expanded
    note_display: below
    note_text: "Coverage held near 93% from March to June, then dropped to 70.5% in the first week of July when 1,003 new tables landed at once. It has not recovered since. A point-in-time number cannot show this."
    row: 3
    col: 0
    width: 16
    height: 8

  - title: "Governance Debt"
    name: trend_debt
    model: context_lakehouse
    explore: context_table_history
    type: looker_area
    fields: [context_table_history.snapshot_date, context_table_history.documented_count, context_table_history.undocumented_count]
    sorts: [context_table_history.snapshot_date]
    limit: 500
    stacking: normal
    note_state: expanded
    note_display: below
    note_text: "Undocumented tables in absolute terms: steady around 250 through June, then 1,249 from July onward. Data arriving faster than stewardship can keep up."
    row: 3
    col: 16
    width: 8
    height: 8

  # ---------- So what ----------

  - title: "High Traffic, Low Governance"
    name: risk_assets
    model: context_lakehouse
    explore: context_pages
    type: looker_grid
    fields: [context_assets.asset_name, context_assets.asset_type, context_assets.connector_name, context_assets.governance_score, context_pages.count]
    filters:
      context_pages.asset_guid: "-NULL"
      context_assets.asset_name: "-NULL"
      context_assets.governance_score: "<=1"
    sorts: [context_pages.count desc]
    limit: 12
    note_state: expanded
    note_display: below
    note_text: "Assets people rely on that nobody has documented, owned or certified. This is the remediation backlog."
    listen:
      date_range: context_pages.viewed_date
    row: 11
    col: 0
    width: 12
    height: 7

  - title: "My Activity"
    name: my_activity
    model: context_lakehouse
    explore: context_pages
    type: looker_grid
    fields: [context_pages.viewed_date, context_pages.section, context_assets.asset_name, context_assets.certificate_status]
    filters:
      context_users.is_current_viewer: "Yes"
      context_assets.asset_name: "-NULL"
    sorts: [context_pages.viewed_date desc]
    limit: 12
    note_state: expanded
    note_display: below
    note_text: "Personalised to whoever is signed in. Same dashboard, different data per user."
    listen:
      date_range: context_pages.viewed_date
    row: 11
    col: 12
    width: 12
    height: 7
