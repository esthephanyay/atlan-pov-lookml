connection: "wwi-snowflake"

# Explicit includes. A bare "*.view.lkml" also pulled in the context_* views,
# which belong to the context_lakehouse model and reference joins that do not
# exist here.
include: "claims.view.lkml"
include: "encounters.view.lkml"
include: "patient_encounters.view.lkml"

explore: patient_encounters {
  label: "Patient Encounters"
}

explore: claims {
  label: "Claims Financial"
}
