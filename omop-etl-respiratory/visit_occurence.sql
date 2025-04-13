-- Step 1: Create the sequence if it does not exist
CREATE SEQUENCE IF NOT EXISTS "DSWB_cdm"."visit_occurrence_id_seq"
    START WITH 1
    INCREMENT BY 1
    OWNED BY "DSWB_cdm".visit_occurrence.visit_occurrence_id;

-- Step 2: Insert visit_occurrence records
INSERT INTO "DSWB_cdm".visit_occurrence (
    visit_occurrence_id,
    person_id,
    visit_concept_id,
    visit_start_date,
    visit_start_datetime,
    visit_end_date,
    visit_end_datetime,
    visit_type_concept_id,
    provider_id,
    care_site_id,
    visit_source_value,
    visit_source_concept_id,
    admitted_from_concept_id,
    admitted_from_source_value,
    discharged_to_concept_id,
    discharged_to_source_value,
    preceding_visit_occurrence_id
)
SELECT
    NEXTVAL('"DSWB_cdm".visit_occurrence_id_seq') AS visit_occurrence_id,
    p.person_id,
    9201 AS visit_concept_id, -- Inpatient visit
    sd."Date hospitalized...9"::date AS visit_start_date,
    sd."Date hospitalized...9"::timestamp AS visit_start_datetime,
    COALESCE(sd."Release date...10"::date, sd."Date hospitalized...9"::date) AS visit_end_date,
    COALESCE(sd."Release date...10"::timestamp, sd."Date hospitalized...9"::timestamp) AS visit_end_datetime,
    32818 AS visit_type_concept_id, -- EHR administration record
    NULL AS provider_id,
    NULL AS care_site_id,
    'Hospitalization' AS visit_source_value,
    0 AS visit_source_concept_id,
    NULL AS admitted_from_concept_id,
    NULL AS admitted_from_source_value,
    NULL AS discharged_to_concept_id,
    NULL AS discharged_to_source_value,
    NULL AS preceding_visit_occurrence_id
FROM respiratorydisease.respiratorydiseasedataset sd
JOIN "DSWB_cdm".person p ON p.person_source_value = sd."unique_code"
WHERE sd."Date hospitalized...9" IS NOT NULL;
