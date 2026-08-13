connection: "wwi-snowflake"

include: "context_*.view.lkml"
include: "*.dashboard.lookml"

label: "Atlan Context Lakehouse"

# Governance coverage across every asset Atlan knows about.
explore: context_assets {
  label: "Governance Coverage"
  description: "Every catalogued asset with its certification, ownership, documentation, glossary and lineage state, plus storage volume and tag assignments. Start here for governance KPI reporting."
  sql_always_where: ${context_assets.status} = 'ACTIVE' ;;

  join: context_asset_tags {
    type: left_outer
    relationship: one_to_one
    sql_on: ${context_assets.guid} = ${context_asset_tags.entityguid} ;;
  }

  join: context_relational {
    type: left_outer
    relationship: one_to_one
    sql_on: ${context_assets.guid} = ${context_relational.guid} ;;
  }
}

# Who is actually using the catalogue, and on which assets.
explore: context_pages {
  label: "Adoption and Usage"
  description: "Page-level usage of Atlan: active users, searches, asset profile views, and the governance state of whatever they landed on."

  join: context_users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${context_pages.user_id} = ${context_users.id} ;;
  }

  join: context_assets {
    type: left_outer
    relationship: many_to_one
    sql_on: ${context_pages.asset_guid} = ${context_assets.guid} ;;
  }

  # context_assets.tag_count resolves against this view, so it has to travel
  # with it into every explore that joins context_assets.
  join: context_asset_tags {
    type: left_outer
    relationship: one_to_one
    sql_on: ${context_assets.guid} = ${context_asset_tags.entityguid} ;;
  }
}

# Raw product event stream for deeper KPI work.
explore: context_tracks {
  label: "Product Events"
  description: "Every tracked product event, bucketed into search, workflow, marketplace and automation categories."

  join: context_users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${context_tracks.user_id} = ${context_users.id} ;;
  }
}

explore: context_users {
  label: "Users"
  description: "Atlan user directory with role, licence type and personas."
}
