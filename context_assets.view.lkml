view: context_assets {
  sql_table_name: SALES_DEMO_CONTEXT_STORE.gold.assets ;;
  label: "Assets"

  dimension: guid {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.guid ;;
  }

  dimension: asset_name {
    label: "Asset Name"
    type: string
    sql: coalesce(${TABLE}.display_name, ${TABLE}.asset_name) ;;
    link: {
      label: "Open in Atlan"
      url: "https://sales-demo.atlan.com/assets/{{ context_assets.guid._value }}/overview"
      icon_url: "https://sales-demo.atlan.com/favicon.ico"
    }
  }

  dimension: asset_qualified_name {
    label: "Qualified Name"
    type: string
    sql: ${TABLE}.asset_qualified_name ;;
  }

  dimension: asset_type {
    label: "Asset Type"
    type: string
    sql: ${TABLE}.asset_type ;;
  }

  dimension: sub_type {
    label: "Sub Type"
    type: string
    sql: ${TABLE}.sub_type ;;
  }

  dimension: connector_name {
    label: "Source System"
    type: string
    sql: ${TABLE}.connector_name ;;
  }

  dimension: status {
    hidden: yes
    type: string
    sql: ${TABLE}.status ;;
  }

  # ---------- Governance state ----------

  dimension: certificate_status {
    label: "Certification"
    type: string
    sql: coalesce(${TABLE}.certificate_status, 'Not Certified') ;;
    html:
      {% if value == 'VERIFIED' %}<span style="color:#0e8a16;font-weight:600">✔ Verified</span>
      {% elsif value == 'DRAFT' %}<span style="color:#b08800;font-weight:600">✎ Draft</span>
      {% elsif value == 'DEPRECATED' %}<span style="color:#b31d28;font-weight:600">⚠ Deprecated</span>
      {% else %}<span style="color:#6a737d">Not Certified</span>{% endif %} ;;
  }

  dimension: certificate_updated_by {
    label: "Certified By"
    type: string
    sql: ${TABLE}.certificate_updated_by ;;
  }

  dimension: owner_count {
    label: "Owner Count"
    type: number
    sql: coalesce(array_size(${TABLE}.owner_users), 0) + coalesce(array_size(${TABLE}.owner_groups), 0) ;;
  }

  dimension: term_count {
    label: "Glossary Term Count"
    type: number
    sql: coalesce(array_size(${TABLE}.term_guids), 0) ;;
  }

  # Tags come from the tagrelationship join, not the asset_tags array on this
  # table: that array is populated for only 10 assets tenant-wide, while
  # tagrelationship carries 5,331 live assignments.
  dimension: tag_count {
    label: "Tag Count"
    type: number
    sql: coalesce(${context_asset_tags.tag_count}, 0) ;;
  }

  dimension: has_description {
    label: "Has Description"
    type: yesno
    sql: coalesce(${TABLE}.user_description, ${TABLE}.description) is not null ;;
  }

  dimension: has_owner {
    label: "Has Owner"
    type: yesno
    sql: ${owner_count} > 0 ;;
  }

  dimension: has_terms {
    label: "Has Glossary Terms"
    type: yesno
    sql: ${term_count} > 0 ;;
  }

  dimension: has_tags {
    label: "Has Tags"
    type: yesno
    sql: ${tag_count} > 0 ;;
  }

  dimension: has_lineage {
    label: "Has Lineage"
    type: yesno
    sql: ${TABLE}.has_lineage ;;
  }

  dimension: is_verified {
    label: "Is Verified"
    type: yesno
    sql: ${TABLE}.certificate_status = 'VERIFIED' ;;
  }

  dimension: is_ai_documented {
    label: "AI Generated Description"
    type: yesno
    sql: ${TABLE}.asset_ai_generated_description is not null ;;
  }

  dimension: governance_score {
    label: "Governance Score (0-5)"
    description: "One point each for description, owner, glossary term, tag, and lineage."
    type: number
    sql:
      (case when coalesce(${TABLE}.user_description, ${TABLE}.description) is not null then 1 else 0 end)
    + (case when ${owner_count} > 0 then 1 else 0 end)
    + (case when ${term_count} > 0 then 1 else 0 end)
    + (case when ${tag_count} > 0 then 1 else 0 end)
    + (case when ${TABLE}.has_lineage then 1 else 0 end) ;;
  }

  dimension: governance_tier {
    label: "Governance Tier"
    type: string
    sql:
      case
        when ${governance_score} >= 4 then '1. Well governed'
        when ${governance_score} >= 2 then '2. Partially governed'
        when ${governance_score} = 1 then '3. Minimal'
        else '4. Ungoverned'
      end ;;
  }

  # ---------- Popularity ----------

  # Atlan writes FLT_MIN (~1.18e-38) instead of null when an asset has never
  # been queried. Left raw it renders as 0.00 but breaks any "= 0" filter,
  # so it is normalised to a true zero here.
  dimension: popularity_score {
    label: "Popularity Score"
    type: number
    value_format_name: decimal_2
    sql: case when ${TABLE}.popularity_score < 1e-30 then 0
              else ${TABLE}.popularity_score end ;;
  }

  dimension: has_popularity {
    label: "Has Been Queried"
    type: yesno
    sql: ${TABLE}.popularity_score >= 1e-30 ;;
  }

  dimension: source_read_count {
    label: "Source Query Count"
    type: number
    sql: ${TABLE}.source_read_count ;;
  }

  dimension: source_read_user_count {
    label: "Source Distinct Readers"
    type: number
    sql: ${TABLE}.source_read_user_count ;;
  }

  # ---------- Time ----------

  dimension_group: created {
    label: "Asset Created"
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: to_timestamp_ltz(${TABLE}.created_at, 3) ;;
  }

  dimension_group: updated {
    label: "Asset Updated"
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: to_timestamp_ltz(${TABLE}.updated_at, 3) ;;
  }

  dimension_group: certified {
    label: "Certified"
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: to_timestamp_ltz(${TABLE}.certificate_updated_at, 3) ;;
  }

  dimension: updated_by {
    label: "Last Updated By"
    type: string
    sql: ${TABLE}.updated_by ;;
  }

  # ---------- Measures ----------

  measure: count {
    label: "Total Assets"
    type: count
    drill_fields: [asset_detail*]
  }

  measure: verified_count {
    label: "Verified Assets"
    type: count
    filters: [is_verified: "yes"]
    drill_fields: [asset_detail*]
  }

  measure: documented_count {
    label: "Documented Assets"
    type: count
    filters: [has_description: "yes"]
    drill_fields: [asset_detail*]
  }

  measure: owned_count {
    label: "Owned Assets"
    type: count
    filters: [has_owner: "yes"]
    drill_fields: [asset_detail*]
  }

  measure: with_terms_count {
    label: "Assets with Glossary Terms"
    type: count
    filters: [has_terms: "yes"]
    drill_fields: [asset_detail*]
  }

  measure: with_lineage_count {
    label: "Assets with Lineage"
    type: count
    filters: [has_lineage: "yes"]
    drill_fields: [asset_detail*]
  }

  measure: tagged_count {
    label: "Tagged Assets"
    type: count
    filters: [has_tags: "yes"]
    drill_fields: [asset_detail*]
  }

  measure: untagged_count {
    label: "Untagged Assets"
    type: count
    filters: [has_tags: "no"]
    drill_fields: [asset_detail*]
  }

  measure: no_description_count {
    label: "Assets Without a Description"
    type: count
    filters: [has_description: "no"]
    drill_fields: [asset_detail*]
  }

  measure: pct_untagged {
    label: "% Without Tags"
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${untagged_count} / nullif(${count}, 0) ;;
  }

  measure: never_queried_count {
    label: "Never Queried"
    type: count
    filters: [has_popularity: "no"]
    drill_fields: [asset_detail*]
  }

  measure: pct_verified {
    label: "% Verified"
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${verified_count} / nullif(${count}, 0) ;;
  }

  measure: pct_documented {
    label: "% Documented"
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${documented_count} / nullif(${count}, 0) ;;
  }

  measure: pct_owned {
    label: "% With Owner"
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${owned_count} / nullif(${count}, 0) ;;
  }

  measure: pct_with_terms {
    label: "% With Glossary Terms"
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${with_terms_count} / nullif(${count}, 0) ;;
  }

  measure: pct_with_lineage {
    label: "% With Lineage"
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${with_lineage_count} / nullif(${count}, 0) ;;
  }

  measure: avg_popularity {
    label: "Avg Popularity"
    type: average
    value_format_name: decimal_2
    sql: ${popularity_score} ;;
  }

  measure: avg_governance_score {
    label: "Avg Governance Score"
    type: average
    value_format_name: decimal_2
    sql: ${governance_score} ;;
  }

  set: asset_detail {
    fields: [asset_name, asset_type, connector_name, certificate_status, owner_count, term_count, has_lineage, governance_score]
  }
}
