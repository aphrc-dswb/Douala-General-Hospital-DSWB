-- First, ensure the sequence exists for drug_exposure_id
CREATE SEQUENCE IF NOT EXISTS "DSWB_cdm".drug_exposure_id_seq
    START WITH 1
    INCREMENT BY 1
    OWNED BY "DSWB_cdm".drug_exposure.drug_exposure_id;

-- Now perform the insertion
WITH arv_data AS (
    SELECT 
        p.person_id,
        432858 AS drug_concept_id,  -- ARV standard concept ID placeholder
        (sd."Date hospitalized...9"::date + (
            sd."ARV start time (in months)"::int * INTERVAL '1 month')
        )::date AS drug_exposure_start_date,
        (sd."Date hospitalized...9"::date + (
            sd."ARV start time (in months)"::int * INTERVAL '1 month')
        )::timestamp AS drug_exposure_start_datetime,
        
        -- Use start date as end date (to avoid nulls in NOT NULL column)
        (sd."Date hospitalized...9"::date + (
            sd."ARV start time (in months)"::int * INTERVAL '1 month')
        )::date AS drug_exposure_end_date,
        (sd."Date hospitalized...9"::date + (
            sd."ARV start time (in months)"::int * INTERVAL '1 month')
        )::timestamp AS drug_exposure_end_datetime,

        32818 AS drug_type_concept_id, -- EHR administration record
        'ARV' AS drug_source_value
    FROM respiratorydisease.respiratorydiseasedataset sd
    JOIN "DSWB_cdm".person p ON p.person_source_value = sd."unique_code"
    WHERE sd."ARV" IS NOT NULL AND sd."ARV start time (in months)" IS NOT NULL
)
INSERT INTO "DSWB_cdm".drug_exposure (
    drug_exposure_id, 
    person_id,
    drug_concept_id,
    drug_exposure_start_date,
    drug_exposure_start_datetime,
    drug_exposure_end_date,
    drug_exposure_end_datetime,
    verbatim_end_date,
    drug_type_concept_id,
    stop_reason,
    refills,
    quantity,
    days_supply,
    sig,
    route_concept_id,
    lot_number,
    provider_id,
    visit_occurrence_id,
    visit_detail_id,
    drug_source_value,
    drug_source_concept_id,
    route_source_value,
    dose_unit_source_value
)
SELECT 
    NEXTVAL('"DSWB_cdm".drug_exposure_id_seq') AS drug_exposure_id,
    person_id,
    drug_concept_id,
    drug_exposure_start_date,
    drug_exposure_start_datetime,
    drug_exposure_end_date,
    drug_exposure_end_datetime,
    NULL AS verbatim_end_date,
    drug_type_concept_id,
    NULL AS stop_reason,
    NULL AS refills,
    NULL AS quantity,
    NULL AS days_supply,
    NULL AS sig,
    NULL AS route_concept_id,
    NULL AS lot_number,
    NULL AS provider_id,
    NULL AS visit_occurrence_id,
    NULL AS visit_detail_id,
    drug_source_value,
    0 AS drug_source_concept_id,
    NULL AS route_source_value,
    NULL AS dose_unit_source_value
FROM arv_data;
