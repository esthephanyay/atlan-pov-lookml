connection: "wwi-snowflake"

include: "*.view.lkml"

explore: patient_encounters {
  label: "Patient Encounters"
}

explore: claims {
  label: "Claims Financial"
}
