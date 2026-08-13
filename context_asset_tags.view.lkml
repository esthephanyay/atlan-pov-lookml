# Real tag assignments live in entity_metadata.tagrelationship, not in the
# asset_tags array on gold.assets (that column is populated for only 10 assets
# across the whole tenant). This rolls tags up to one row per asset.
view: context_asset_tags {
  derived_table: {
    sql:
      select
        entityguid,
        count(distinct tagname) as tag_count,
        listagg(distinct tagname, ', ') within group (order by tagname) as tag_names,
        max(case when upper(tagname) = 'PII' then 1 else 0 end) as is_pii
      from SALES_DEMO_CONTEXT_STORE.entity_metadata.tagrelationship
      where status = 'ACTIVE'
      group by 1 ;;
  }

  dimension: entityguid {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.entityguid ;;
  }

  dimension: tag_count {
    label: "Tag Count"
    type: number
    sql: ${TABLE}.tag_count ;;
  }

  dimension: tag_names {
    label: "Tags"
    type: string
    sql: ${TABLE}.tag_names ;;
  }

  dimension: is_pii {
    label: "Is PII Tagged"
    type: yesno
    sql: ${TABLE}.is_pii = 1 ;;
  }
}
