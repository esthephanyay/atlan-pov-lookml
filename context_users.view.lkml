view: context_users {
  sql_table_name: SALES_DEMO_CONTEXT_STORE.usage_analytics.users ;;
  label: "Users"

  dimension: id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: email {
    label: "Email"
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: name {
    label: "User"
    type: string
    sql: coalesce(${TABLE}.name, ${TABLE}.username, ${TABLE}.email) ;;
  }

  dimension: username {
    label: "Username"
    type: string
    sql: ${TABLE}.username ;;
  }

  dimension: role {
    label: "Atlan Role"
    type: string
    sql: ${TABLE}.role ;;
  }

  dimension: job_role {
    label: "Job Role"
    type: string
    sql: ${TABLE}.job_role ;;
  }

  dimension: license_type {
    label: "License Type"
    type: string
    sql: ${TABLE}.license_type ;;
  }

  dimension: domain {
    label: "Email Domain"
    type: string
    sql: ${TABLE}.domain ;;
  }

  dimension_group: user_created {
    label: "User Created"
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  # Powers the personalized "my own information" view. Resolves against the
  # email of whoever is logged into Looker, so one dashboard serves every user.
  dimension: is_current_viewer {
    label: "Is Me"
    description: "Yes when this row is the Looker user currently viewing the dashboard."
    type: yesno
    sql: lower(${TABLE}.email) = lower('{{ _user_attributes["email"] }}') ;;
  }

  measure: count {
    label: "Total Users"
    type: count
    drill_fields: [name, email, role, license_type]
  }
}
