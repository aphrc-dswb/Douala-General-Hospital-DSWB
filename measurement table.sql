SET search_path TO "DSWB_cdm";

TRUNCATE TABLE measurement RESTART IDENTITY CASCADE;

-- Créer la séquence si elle n'existe pas
CREATE SEQUENCE IF NOT EXISTS measurement_id_seq;

-- Réinitialiser la séquence à 1
ALTER SEQUENCE measurement_id_seq RESTART WITH 1;

INSERT INTO measurement (
   measurement_id,
   person_id,
   measurement_concept_id,
   measurement_date,
   measurement_type_concept_id,
   value_as_number,
   value_as_concept_id,
   unit_concept_id,
   provider_id,
   visit_occurrence_id,
   measurement_source_value,
   unit_source_value,
   value_source_value
)
-- Ethyl index
SELECT
   nextval('measurement_id_seq'),
   p.person_id,
   4305491,  -- Ethyl index
   CAST(r."Date hospitalized...9" AS DATE),
   32818,
   CAST(NULLIF(TRIM(r."Ethyl index"::TEXT), '') AS NUMERIC),
   NULL::INTEGER,
   NULL::INTEGER,
   1,
   vo.visit_occurrence_id,
   'Ethyl index',
   'index',
   r."Ethyl index"
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo ON vo.person_id = p.person_id
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Ethyl index" IS NOT NULL
  AND r."Ethyl index"::TEXT ~ '^[0-9.]+$'

UNION ALL

-- Respiratory rate
SELECT
   nextval('measurement_id_seq'),
   p.person_id,
   3027018,  -- Respiratory rate
   CAST(r."Date hospitalized...9" AS DATE),
   32818,
   CAST(NULLIF(TRIM(r."Respiratory rate"::TEXT), '') AS NUMERIC),
   NULL,
   8483,
   1,
   vo.visit_occurrence_id,
   'Respiratory rate',
   '/min',
   r."Respiratory rate"
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo ON vo.person_id = p.person_id
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Respiratory rate" IS NOT NULL
  AND r."Respiratory rate"::TEXT ~ '^[0-9.]+$'



UNION ALL
-- SpO₂
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    4196147,                                           -- SpO₂ concept ID
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                                              -- EHR administration record
    CAST(NULLIF(TRIM(r."SpO2"::TEXT), '') AS NUMERIC),
    NULL,
    8554,                                               -- % (unit_concept_id)
    1,
    vo.visit_occurrence_id,
    'SpO2',
    '%',                                                -- unit_source_value
    r."SpO2"
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
    ON vo.person_id = p.person_id 
    AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."SpO2" IS NOT NULL
  AND r."SpO2"::TEXT ~ '^[0-9.]+$'

UNION ALL

-- Hemoglobin Tx
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    3000963,                                           -- Hemoglobin concept ID
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                                              -- EHR administration record
    CAST(NULLIF(TRIM(r."Hemoglobin Tx"::TEXT), '') AS NUMERIC),
    NULL,
    8713,                                               -- g/dL (unit_concept_id)
    1,
    vo.visit_occurrence_id,
    'Hemoglobin Tx',
    'g/dL',                                             -- unit_source_value
    r."Hemoglobin Tx"
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
    ON vo.person_id = p.person_id 
    AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Hemoglobin Tx" IS NOT NULL
  AND r."Hemoglobin Tx"::TEXT ~ '^[0-9.]+$'

UNION ALL

-- Leukocytes (per mm³)
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    45878743,                                           -- Leukocytes concept ID
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                                              -- EHR administration record
    CAST(NULLIF(TRIM(r."Leukocytes (Per mm3)"::TEXT), '') AS NUMERIC),
    NULL,
    8848,                                               -- /mm³ (unit_concept_id)
    1,
    vo.visit_occurrence_id,
    'Leukocytes (per mm3)',
    '/mm³',                                             -- unit_source_value
    r."Leukocytes (Per mm3)"
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
    ON vo.person_id = p.person_id 
    AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Leukocytes (Per mm3)" IS NOT NULL
  AND r."Leukocytes (Per mm3)"::TEXT ~ '^[0-9.]+$'

UNION ALL
-- CRP
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    3016722,                            -- C-Reactive Protein
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                               -- EHR administration record
    CAST(NULLIF(TRIM(r."CRP"::TEXT), '') AS NUMERIC),
    NULL,
    8751,                               -- mg/L
    1,
    vo.visit_occurrence_id,
    'CRP',
    'mg/L',                             -- unit_source_value
    r."CRP"
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p 
  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."CRP" IS NOT NULL
  AND r."CRP"::TEXT ~ '^[0-9.]+$'
UNION ALL

-- Urea
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    3016726,                            -- Urea nitrogen
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                               -- EHR administration record
    CAST(NULLIF(TRIM(r."Urea"::TEXT), '') AS NUMERIC),
    NULL,
    8713,                               -- mg/dL
    1,
    vo.visit_occurrence_id,
    'Urea',
    'mg/dL',                            -- unit_source_value
    r."Urea"
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p 
  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Urea" IS NOT NULL
  AND r."Urea"::TEXT ~ '^[0-9.]+$'

UNION ALL
-- CD4 count
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    3001101,                            -- CD4+ T helper cells
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                               -- EHR administration record
    CAST(NULLIF(TRIM(r."CD4 count (current or <1 month)"::TEXT), '') AS NUMERIC),
    NULL,
    8799,                               -- cells/mm³
    1,
    vo.visit_occurrence_id,
    'CD4 count (current or <1 month)',
    'cells/mm³',                        -- unit_source_value
    r."CD4 count (current or <1 month)"
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p 
  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."CD4 count (current or <1 month)" IS NOT NULL
  AND r."CD4 count (current or <1 month)"::TEXT ~ '^[0-9.]+$'

UNION ALL
-- % lymphocytes
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    3013705,                            -- Lymphocytes %
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                               -- EHR administration record
    CAST(NULLIF(TRIM(r."% lymphocytes"::TEXT), '') AS NUMERIC),
    NULL,
    8554,                               -- %
    1,
    vo.visit_occurrence_id,
    '% lymphocytes',
    '%',                                -- unit_source_value
    r."% lymphocytes"
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p 
  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."% lymphocytes" IS NOT NULL
  AND r."% lymphocytes"::TEXT ~ '^[0-9.]+$'
  

UNION ALL
-- Ascitic fluid proteins
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    3017257,                              -- Ascitic fluid proteins
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                                -- EHR administration record
    CAST(r."ascitic fluid proteins" AS NUMERIC),
    NULL,                                  -- value_as_concept_id
    8713,                                 -- g/dL (unit_concept_id)
    1,                        -- provider_id (foreign key)
    vo.visit_occurrence_id,                -- visit_occurrence_id (foreign key)
    'Ascitic fluid proteins',              -- measurement_source_value
    'g/dL',                               -- unit_source_value
    r."ascitic fluid proteins"             -- value_source_value
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p 
  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."ascitic fluid proteins" IS NOT NULL
  AND r."ascitic fluid proteins"::TEXT ~ '^[0-9.]+$'

UNION ALL
-- Ascites leukocytes
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    3010115,                              -- Ascites leukocytes
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                                -- EHR administration record
    CAST(r."ascites leukocytes" AS NUMERIC),
    NULL,
    8848,                                 -- /mm³ (unit_concept_id)
    1,                        -- provider_id (foreign key)
    vo.visit_occurrence_id,                -- visit_occurrence_id (foreign key)
    'Ascites leukocytes',                  -- measurement_source_value
    '/mm³',                               -- unit_source_value
    r."ascites leukocytes"                 -- value_source_value
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p 
  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."ascites leukocytes" IS NOT NULL
  AND r."ascites leukocytes"::TEXT ~ '^[0-9.]+$'

UNION ALL
-- % of lymphocytes in ascites
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    3013705,                              -- Lymphocytes %
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                                -- EHR administration record
    CAST(r."% of lymphocytes in ascites" AS NUMERIC),
    NULL,
    8554,                                 -- % (unit_concept_id)
    1,                        -- provider_id (foreign key)
    vo.visit_occurrence_id,                -- visit_occurrence_id (foreign key)
    '% of lymphocytes in ascites',         -- measurement_source_value
    '%',                                  -- unit_source_value
    r."% of lymphocytes in ascites"        -- value_source_value
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p 
  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."% of lymphocytes in ascites" IS NOT NULL
  AND r."% of lymphocytes in ascites"::TEXT ~ '^[0-9.]+$'


UNION ALL
-- O2 flow rate (L/min)
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    44790940,                              -- O2 flow rate
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                                -- EHR administration record
    CAST(r."O2 flow rate (in liters/min)" AS NUMERIC),
    NULL,
    8698,                                 -- L/min (unit_concept_id)
    1,                        -- provider_id (foreign key)
    vo.visit_occurrence_id,                -- visit_occurrence_id (foreign key)
    'O2 flow rate (in liters/min)',        -- measurement_source_value
    'L/min',                               -- unit_source_value
    r."O2 flow rate (in liters/min)"       -- value_source_value
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p 
  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."O2 flow rate (in liters/min)" IS NOT NULL
  AND r."O2 flow rate (in liters/min)"::TEXT ~ '^[0-9.]+$'


UNION ALL
-- Pulse
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    3027017,                              -- Pulse
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                                -- EHR administration record
    CAST(r."Pulse" AS NUMERIC),
    NULL,
    8483,                                 -- /min (unit_concept_id)
    1,                        -- provider_id (foreign key)
    vo.visit_occurrence_id,                -- visit_occurrence_id (foreign key)
    'Pulse',                               -- measurement_source_value
    '/min',                                -- unit_source_value
    r."Pulse"                              -- value_source_value
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p 
  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Pulse" IS NOT NULL
  AND r."Pulse"::TEXT ~ '^[0-9.]+$'


UNION ALL
-- Neutrophils (%)
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    3010112,                              -- Neutrophils %
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                                -- EHR administration record
    CAST(r."Neutrophils (%)" AS NUMERIC),  -- value_as_number
    NULL,                                  -- value_as_concept_id
    8554,                                 -- % (unit_concept_id)
    1,                        -- provider_id (foreign key)
    vo.visit_occurrence_id,                -- visit_occurrence_id (foreign key)
    'Neutrophils (%)',                     -- measurement_source_value
    '%',                                   -- unit_source_value
    r."Neutrophils (%)"                    -- value_source_value
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p 
  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Neutrophils (%)" IS NOT NULL
  AND r."Neutrophils (%)"::TEXT ~ '^[0-9.]+$'


UNION ALL
-- Lymphocytes (%)
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    3013705,                              -- Lymphocytes %
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                                -- EHR administration record
    CAST(r."Lymphocytes (%)" AS NUMERIC),  -- value_as_number
    NULL,                                  -- value_as_concept_id
    8554,                                 -- % (unit_concept_id)
    1,                        -- provider_id (foreign key)
    vo.visit_occurrence_id,                -- visit_occurrence_id (foreign key)
    'Lymphocytes (%)',                     -- measurement_source_value
    '%',                                   -- unit_source_value
    r."Lymphocytes (%)"                    -- value_source_value
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p 
  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Lymphocytes (%)" IS NOT NULL
  AND r."Lymphocytes (%)"::TEXT ~ '^[0-9.]+$'


UNION ALL
-- Eosinophils (%)
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    3010114,                             -- Eosinophils %
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                               -- EHR administration record
    CAST(r."Eosiophiles (%)" AS NUMERIC), -- value_as_number
    NULL,                                 -- value_as_concept_id
    8554,                                 -- % (unit_concept_id)
    1,                       -- provider_id (foreign key)
    vo.visit_occurrence_id,               -- visit_occurrence_id (foreign key)
    'Eosiophiles (%)',                    -- measurement_source_value
    '%',                                  -- unit_source_value
    r."Eosiophiles (%)"                   -- value_source_value
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p 
  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Eosiophiles (%)" IS NOT NULL
  AND r."Eosiophiles (%)"::TEXT ~ '^[0-9.]+$'

UNION ALL
-- Monocytes (%)
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    3010113,                             -- Monocytes %
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                               -- EHR administration record
    CAST(r."Monocytes (%)" AS NUMERIC),   -- value_as_number
    NULL,                                 -- value_as_concept_id
    8554,                                 -- % (unit_concept_id)
    1,                       -- provider_id (foreign key)
    vo.visit_occurrence_id,               -- visit_occurrence_id (foreign key)
    'Monocytes (%)',                      -- measurement_source_value
    '%',                                  -- unit_source_value
    r."Monocytes (%)"                     -- value_source_value
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p 
  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Monocytes (%)" IS NOT NULL
  AND r."Monocytes (%)"::TEXT ~ '^[0-9.]+$'

UNION ALL
-- Platelets (per mm3)
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    3007461,                             -- Platelet count
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                               -- EHR administration record
    CAST(r."Platelets (per mm3)" AS NUMERIC),  -- value_as_number
    NULL,                                 -- value_as_concept_id
    8848,                                 -- /mm³ (unit_concept_id)
    1,                        -- provider_id (foreign key)
    vo.visit_occurrence_id,                -- visit_occurrence_id (foreign key)
    'Platelets (per mm3)',                 -- measurement_source_value
    '/mm³',                                -- unit_source_value
    r."Platelets (per mm3)"                -- value_source_value
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p 
  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Platelets (per mm3)" IS NOT NULL
  AND r."Platelets (per mm3)"::TEXT ~ '^[0-9.]+$'

UNION ALL
-- Sedimentation rate
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    4272950,                             -- ESR (Erythrocyte Sedimentation Rate)
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                               -- EHR administration record
    CAST(r."Sedimentation rate" AS NUMERIC),  -- value_as_number
    NULL,                                 -- value_as_concept_id
    8752,                                 -- mm/h (unit_concept_id)
    1,                        -- provider_id (foreign key)
    vo.visit_occurrence_id,                -- visit_occurrence_id (foreign key)
    'Sedimentation rate',                  -- measurement_source_value
    'mm/h',                                -- unit_source_value
    r."Sedimentation rate"                 -- value_source_value
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p 
  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Sedimentation rate" IS NOT NULL
  AND r."Sedimentation rate"::TEXT ~ '^[0-9.]+$'

UNION ALL
-- Creatinine level
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    3020564,  -- Creatinine
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                               -- EHR administration record
    CAST(r."Creatinine level" AS NUMERIC),  -- value_as_number
    NULL,                                 -- value_as_concept_id
    8840,                                 -- mg/dL (unit_concept_id)
    1,                        -- provider_id (foreign key)
    vo.visit_occurrence_id,                -- visit_occurrence_id (foreign key)
    'Creatinine level',                    -- measurement_source_value
    'mg/dL',                               -- unit_source_value
    r."Creatinine level"                   -- value_source_value
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Creatinine level" IS NOT NULL
  AND r."Creatinine level"::TEXT ~ '^[0-9.]+$'

UNION ALL
-- SGOT (AST)
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    3013721,  -- SGOT (AST)
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                               -- EHR administration record
    CAST(r."SGOT" AS NUMERIC),           -- value_as_number
    NULL,                                 -- value_as_concept_id
    8645,                                 -- U/L (unit_concept_id)
    1,                        -- provider_id (foreign key)
    vo.visit_occurrence_id,                -- visit_occurrence_id (foreign key)
    'SGOT',                                -- measurement_source_value
    'U/L',                                 -- unit_source_value
    r."SGOT"                               -- value_source_value
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."SGOT" IS NOT NULL
  AND r."SGOT"::TEXT ~ '^[0-9.]+$'

UNION ALL
-- SGPT (ALT)
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    3013722,  -- SGPT (ALT)
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                               -- EHR administration record
    CAST(r."SGPT" AS NUMERIC),           -- value_as_number
    NULL,                                 -- value_as_concept_id
    8645,                                 -- U/L (unit_concept_id)
    1,                        -- provider_id (foreign key)
    vo.visit_occurrence_id,                -- visit_occurrence_id (foreign key)
    'SGPT',                                -- measurement_source_value
    'U/L',                                 -- unit_source_value
    r."SGPT"                               -- value_source_value
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."SGPT" IS NOT NULL
  AND r."SGPT"::TEXT ~ '^[0-9.]+$'

UNION ALL
-- Prothrombin rate
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    3012410,  -- Prothrombin activity
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                               -- EHR administration record
    CAST(r."Prothrombin rate" AS NUMERIC), -- value_as_number
    NULL,                                 -- value_as_concept_id
    8554,                                 -- % (unit_concept_id)
    1,                        -- provider_id (foreign key)
    vo.visit_occurrence_id,                -- visit_occurrence_id (foreign key)
    'Prothrombin rate',                    -- measurement_source_value
    '%',                                   -- unit_source_value
    r."Prothrombin rate"                   -- value_source_value
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Prothrombin rate" IS NOT NULL
  AND r."Prothrombin rate"::TEXT ~ '^[0-9.]+$'

UNION ALL
-- Pleural proteins
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    3024114,  -- Pleural fluid protein
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                               -- EHR administration record
    CAST(r."Pleural proteins (/mm3)" AS NUMERIC), -- value_as_number
    NULL,                                 -- value_as_concept_id
    8713,                                 -- g/dL (unit_concept_id)
    1,                        -- provider_id (foreign key)
    vo.visit_occurrence_id,                -- visit_occurrence_id (foreign key)
    'Pleural proteins (/mm3)',             -- measurement_source_value
    'g/dL',                                -- unit_source_value
    r."Pleural proteins (/mm3)"            -- value_source_value
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Pleural proteins (/mm3)" IS NOT NULL
  AND r."Pleural proteins (/mm3)"::TEXT ~ '^[0-9.]+$'

UNION ALL
-- Pleural leukocytes
SELECT
    nextval('measurement_id_seq'),
    p.person_id,
    3019198,  -- Pleural leukocytes
    CAST(r."Date hospitalized...9" AS DATE),
    32818,                               -- EHR administration record
    CAST(r."Pleural leukocytes (/mm3)" AS NUMERIC), -- value_as_number
    NULL,                                 -- value_as_concept_id
    8848,                                 -- /mm³ (unit_concept_id)
    1,                        -- provider_id (foreign key)
    vo.visit_occurrence_id,                -- visit_occurrence_id (foreign key)
    'Pleural leukocytes (/mm3)',           -- measurement_source_value
    '/mm³',                                -- unit_source_value
    r."Pleural leukocytes (/mm3)"          -- value_source_value
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo 
  ON vo.person_id = p.person_id 
 AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Pleural leukocytes (/mm3)" IS NOT NULL
  AND r."Pleural leukocytes (/mm3)"::TEXT ~ '^[0-9.]+$';