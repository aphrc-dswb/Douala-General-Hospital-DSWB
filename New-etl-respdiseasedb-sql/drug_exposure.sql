SET search_path TO "DSWB_cdm";
TRUNCATE TABLE "DSWB_cdm".drug_exposure;

ALTER SEQUENCE drug_exposure_id_seq RESTART WITH 1;

-- Créer la séquence si elle n'existe pas
CREATE SEQUENCE IF NOT EXISTS drug_exposure_id_seq;

-- Insérer les expositions aux ARV
INSERT INTO drug_exposure (
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
    nextval('drug_exposure_id_seq') AS drug_exposure_id,
    p.person_id,
    45876157 AS drug_concept_id,  -- Antiretroviral therapy
    CAST(r."Date hospitalized...9" AS DATE) - (INTERVAL '1 month' * CAST(r."ARV start time (in months)" AS INTEGER)) AS drug_exposure_start_date,
    NULL,
    CAST(r."Date hospitalized...9" AS DATE) - (INTERVAL '1 month' * CAST(r."ARV start time (in months)" AS INTEGER)) AS drug_exposure_end_date,
    NULL,
    NULL,
    32818,  -- EHR record
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    pr.provider_id,
    vo.visit_occurrence_id,
    NULL,
    'Antiretroviral therapy',
    NULL,
    NULL,
    NULL
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p 
    ON r."unique_code" = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
    ON vo.person_id = p.person_id AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
JOIN "DSWB_cdm".provider pr 
    ON pr.provider_id = vo.provider_id
WHERE r."ARV" = 'Yes'
  AND r."Date hospitalized...9" IS NOT NULL
  AND r."ARV start time (in months)"::text ~ '^[0-9]+$';
