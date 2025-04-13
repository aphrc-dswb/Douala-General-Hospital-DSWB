-- Step 1: Create the sequence for specimen_id (if it doesn't exist)
CREATE SEQUENCE IF NOT EXISTS "DSWB_cdm"."specimen_id_seq"
    START WITH 1
    INCREMENT BY 1
    OWNED BY "DSWB_cdm".specimen.specimen_id;

-- Step 2: Insert pleural fluid specimens
INSERT INTO "DSWB_cdm".specimen (
    specimen_id,
    person_id,
    specimen_concept_id,
    specimen_type_concept_id,
    specimen_date,
    specimen_datetime,
    quantity,
    unit_concept_id,
    anatomic_site_concept_id,
    disease_status_concept_id,
    specimen_source_id,
    specimen_source_value,
    unit_source_value,
    anatomic_site_source_value,
    disease_status_source_value
)
SELECT
    NEXTVAL('"DSWB_cdm"."specimen_id_seq"') AS specimen_id,
    p.person_id,
    4040532 AS specimen_concept_id, -- SNOMED: Pleural fluid specimen
    32818 AS specimen_type_concept_id, -- EHR administration record
    sd."Date hospitalized...9"::date AS specimen_date,
    sd."Date hospitalized...9"::timestamp AS specimen_datetime,
    NULL AS quantity,
    NULL AS unit_concept_id,
    NULL AS anatomic_site_concept_id,
    NULL AS disease_status_concept_id,
    NULL AS specimen_source_id,
    'Pleural fluid specimen' AS specimen_source_value,
    NULL AS unit_source_value,
    NULL AS anatomic_site_source_value,
    NULL AS disease_status_source_value
FROM respiratorydisease.respiratorydiseasedataset sd
JOIN "DSWB_cdm".person p ON p.person_source_value = sd."unique_code"
WHERE sd."Macroscopy of pleural fluid" IS NOT NULL;
