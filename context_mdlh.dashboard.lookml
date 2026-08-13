- dashboard: context_mdlh
  title: "Metadata Lakehouse Governance"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Storage, documentation, tagging and popularity across the catalogued estate. Looker equivalent of the Sigma MDLH governance workbook."

  filters:
  - name: asset_type
    title: "Asset Type"
    type: field_filter
    default_value: "Table"
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

  - name: database
    title: "Database"
    type: field_filter
    allow_multiple_values: true
    required: false
    model: context_lakehouse
    explore: context_assets
    field: context_relational.database_name

  elements:

  # ---------- KPI row ----------

  - title: "Total Tables"
    name: mdlh_total_tables
    model: context_lakehouse
    explore: context_assets
    type: single_value
    fields: [context_assets.count]
    filters:
      context_assets.asset_type: "Table"
    listen:
      source_system: context_assets.connector_name
      database: context_relational.database_name
    row: 0
    col: 0
    width: 4
    height: 3

  - title: "View Count"
    name: mdlh_view_count
    model: context_lakehouse
    explore: context_assets
    type: single_value
    fields: [context_assets.count]
    filters:
      context_assets.asset_type: "View"
    listen:
      source_system: context_assets.connector_name
      database: context_relational.database_name
    row: 0
    col: 4
    width: 4
    height: 3

  - title: "Total Size (GB)"
    name: mdlh_total_gb
    model: context_lakehouse
    explore: context_assets
    type: single_value
    fields: [context_relational.total_size_gb]
    listen:
      asset_type: context_assets.asset_type
      source_system: context_assets.connector_name
      database: context_relational.database_name
    row: 0
    col: 8
    width: 4
    height: 3

  - title: "Without a Description"
    name: mdlh_no_desc
    model: context_lakehouse
    explore: context_assets
    type: single_value
    fields: [context_assets.no_description_count]
    listen:
      asset_type: context_assets.asset_type
      source_system: context_assets.connector_name
      database: context_relational.database_name
    row: 0
    col: 12
    width: 4
    height: 3

  - title: "% Without Tags"
    name: mdlh_pct_untagged
    model: context_lakehouse
    explore: context_assets
    type: single_value
    fields: [context_assets.pct_untagged]
    listen:
      asset_type: context_assets.asset_type
      source_system: context_assets.connector_name
      database: context_relational.database_name
    row: 0
    col: 16
    width: 4
    height: 3

  - title: "Never Queried"
    name: mdlh_never_queried
    model: context_lakehouse
    explore: context_assets
    type: single_value
    fields: [context_assets.never_queried_count]
    listen:
      asset_type: context_assets.asset_type
      source_system: context_assets.connector_name
      database: context_relational.database_name
    row: 0
    col: 20
    width: 4
    height: 3

  # ---------- Governance ----------

  - title: "Certificate Status"
    name: mdlh_cert
    model: context_lakehouse
    explore: context_assets
    type: looker_pie
    fields: [context_assets.certificate_status, context_assets.count]
    sorts: [context_assets.count desc]
    value_labels: legend
    label_type: labPer
    listen:
      asset_type: context_assets.asset_type
      source_system: context_assets.connector_name
      database: context_relational.database_name
    row: 3
    col: 0
    width: 8
    height: 7

  - title: "Assets With No Description by Source"
    name: mdlh_no_desc_by_source
    model: context_lakehouse
    explore: context_assets
    type: looker_column
    fields: [context_assets.connector_name, context_assets.no_description_count, context_assets.count]
    sorts: [context_assets.no_description_count desc]
    limit: 12
    listen:
      asset_type: context_assets.asset_type
      source_system: context_assets.connector_name
      database: context_relational.database_name
    row: 3
    col: 8
    width: 8
    height: 7

  - title: "Tag Compliance by Schema"
    name: mdlh_tag_compliance
    model: context_lakehouse
    explore: context_assets
    type: looker_bar
    fields: [context_relational.schema_name, context_assets.tagged_count, context_assets.untagged_count]
    filters:
      context_relational.schema_name: "-NULL"
    sorts: [context_assets.untagged_count desc]
    limit: 12
    stacking: normal
    listen:
      asset_type: context_assets.asset_type
      source_system: context_assets.connector_name
      database: context_relational.database_name
    row: 3
    col: 16
    width: 8
    height: 7

  # ---------- Storage ----------

  - title: "Largest Tables by Size"
    name: mdlh_largest
    model: context_lakehouse
    explore: context_assets
    type: looker_bar
    fields: [context_assets.asset_name, context_relational.total_size_gb]
    filters:
      context_relational.has_size: "Yes"
    sorts: [context_relational.total_size_gb desc]
    limit: 15
    listen:
      asset_type: context_assets.asset_type
      source_system: context_assets.connector_name
      database: context_relational.database_name
    row: 10
    col: 0
    width: 12
    height: 8

  - title: "Size vs Popularity"
    name: mdlh_size_vs_pop
    model: context_lakehouse
    explore: context_assets
    type: looker_scatter
    fields: [context_assets.asset_name, context_relational.total_size_gb, context_assets.avg_popularity]
    filters:
      context_relational.has_size: "Yes"
    sorts: [context_relational.total_size_gb desc]
    limit: 200
    note_state: expanded
    note_display: below
    note_text: "Bottom right is the waste quadrant: large tables nobody queries."
    listen:
      asset_type: context_assets.asset_type
      source_system: context_assets.connector_name
      database: context_relational.database_name
    row: 10
    col: 12
    width: 12
    height: 8

  - title: "Storage by Size Band"
    name: mdlh_size_band
    model: context_lakehouse
    explore: context_assets
    type: looker_column
    fields: [context_relational.size_band, context_assets.count, context_relational.total_size_gb]
    sorts: [context_relational.size_band]
    listen:
      asset_type: context_assets.asset_type
      source_system: context_assets.connector_name
      database: context_relational.database_name
    row: 18
    col: 0
    width: 8
    height: 7

  - title: "Update Trends by User"
    name: mdlh_update_trends
    model: context_lakehouse
    explore: context_assets
    type: looker_column
    fields: [context_assets.updated_by, context_assets.count]
    filters:
      context_assets.updated_by: "-NULL"
    sorts: [context_assets.count desc]
    limit: 10
    listen:
      asset_type: context_assets.asset_type
      source_system: context_assets.connector_name
      database: context_relational.database_name
    row: 18
    col: 8
    width: 8
    height: 7

  - title: "Glossary Coverage"
    name: mdlh_glossary
    model: context_lakehouse
    explore: context_assets
    type: looker_column
    fields: [context_assets.asset_type, context_assets.count]
    filters:
      context_assets.asset_type: "AtlasGlossary,AtlasGlossaryTerm,AtlasGlossaryCategory"
    sorts: [context_assets.count desc]
    row: 18
    col: 16
    width: 8
    height: 7

  # ---------- Remediation backlog ----------

  - title: "Large Tables Never Queried"
    name: mdlh_waste
    model: context_lakehouse
    explore: context_assets
    type: looker_grid
    fields: [context_assets.asset_name, context_relational.database_name, context_relational.schema_name, context_relational.total_size_gb, context_relational.total_rows]
    filters:
      context_assets.has_popularity: "No"
      context_relational.has_size: "Yes"
    sorts: [context_relational.total_size_gb desc]
    limit: 20
    note_state: expanded
    note_display: below
    note_text: "Storage spend with no read activity behind it."
    listen:
      asset_type: context_assets.asset_type
      source_system: context_assets.connector_name
      database: context_relational.database_name
    row: 25
    col: 0
    width: 12
    height: 8

  - title: "Untagged and Undocumented"
    name: mdlh_gap_grid
    model: context_lakehouse
    explore: context_assets
    type: looker_grid
    fields: [context_assets.asset_name, context_assets.asset_type, context_relational.schema_name, context_assets.certificate_status, context_relational.total_size_gb]
    filters:
      context_assets.has_tags: "No"
      context_assets.has_description: "No"
    sorts: [context_relational.total_size_gb desc]
    limit: 20
    note_state: expanded
    note_display: below
    note_text: "No tags and no description. The starting backlog for a stewardship push."
    listen:
      asset_type: context_assets.asset_type
      source_system: context_assets.connector_name
      database: context_relational.database_name
    row: 25
    col: 12
    width: 12
    height: 8
