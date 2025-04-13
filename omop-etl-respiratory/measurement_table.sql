-- Step 1: Create the sequence if not exists
CREATE SEQUENCE IF NOT EXISTS "DSWB_cdm".measurement_id_seq
    START WITH 1
    INCREMENT BY 1
    OWNED BY "DSWB_cdm".measurement.measurement_id;

-- Step 2: Extract relevant measurements using a CTE
WITH extracted_measurements AS (
    SELECT
        p.person_id,
        m.measurement_name,
        m.concept_id AS measurement_concept_id,
        sd."Date hospitalized...9"::date AS measurement_date,
        sd."Date hospitalized...9"::timestamp AS measurement_datetime,
        CASE
            WHEN m.measurement_name = 'Respiratory rate' THEN sd."Respiratory rate"
            WHEN m.measurement_name = 'spo2' THEN sd."SpO2"
            WHEN m.measurement_name = 'pulse' THEN sd."Pulse"
            WHEN m.measurement_name = 'leukocytes (per mm3)' THEN sd."Leukocytes (Per mm3)"
            WHEN m.measurement_name = 'neutrophils (%)' THEN sd."Neutrophils (%)"
            WHEN m.measurement_name = 'lymphocytes (%)' THEN sd."Lymphocytes (%)"
            WHEN m.measurement_name = 'eosiophiles (%)' THEN sd."Eosiophiles (%)"
            WHEN m.measurement_name = 'monocytes (%)' THEN sd."Monocytes (%)"
            WHEN m.measurement_name = 'hemoglobin tx' THEN sd."Hemoglobin Tx"
            WHEN m.measurement_name = 'platelets (per mm3)' THEN sd."Platelets (per mm3)"
            WHEN m.measurement_name = 'crp' THEN sd."CRP"
            WHEN m.measurement_name = 'sedimentation rate' THEN sd."Sedimentation rate"
            WHEN m.measurement_name = 'urea' THEN sd."Urea"
            WHEN m.measurement_name = 'creatinine level' THEN sd."Creatinine level"
            WHEN m.measurement_name = 'sgot' THEN sd."SGOT"
            WHEN m.measurement_name = 'sgpt' THEN sd."SGPT"
            WHEN m.measurement_name = 'cd4 count (current or <1 month)' THEN sd."CD4 count (current or <1 month)"
            WHEN m.measurement_name = '% lymphocytes' THEN sd."% lymphocytes"
            WHEN m.measurement_name = 'pleural leukocytes (/mm3)' THEN sd."Pleural leukocytes (/mm3)"
        END AS raw_value
    FROM respiratorydisease.respiratorydiseasedataset sd
    JOIN "DSWB_cdm".person p 
        ON p.person_source_value = sd."unique_code"
    CROSS JOIN (
        VALUES
            ('Respiratory rate', 4313591),
            ('spo2', 608493),
            ('pulse', 4224504),
            ('leukocytes (per mm3)', 45878743),
            ('neutrophils (%)', 45906211),
            ('lymphocytes (%)', 45952054),
            ('eosiophiles (%)', 45941946),
            ('monocytes (%)', 45947517),
            ('hemoglobin tx', 37546133),
            ('platelets (per mm3)', 36310193),
            ('crp', 37398482),
            ('sedimentation rate', 40621485),
            ('urea', 4020121),
            ('creatinine level', 37394438),
            ('sgot', 45505208),
            ('sgpt', 4096233),
            ('cd4 count (current or <1 month)', 3956422),
            ('% lymphocytes', 37399254),
            ('pleural leukocytes (/mm3)', 40777290)
    ) AS m(measurement_name, concept_id)
)

-- Step 3: Insert into measurement table
INSERT INTO "DSWB_cdm".measurement (
    measurement_id,
    person_id,
    measurement_concept_id,
    measurement_date,
    measurement_datetime,
    measurement_time,
    measurement_type_concept_id,
    operator_concept_id,
    value_as_number,
    value_as_concept_id,
    unit_concept_id,
    range_low,
    range_high,
    provider_id,
    visit_occurrence_id,
    visit_detail_id,
    measurement_source_value,
    measurement_source_concept_id,
    unit_source_value,
    unit_source_concept_id,
    value_source_value,
    measurement_event_id,
    meas_event_field_concept_id
)
SELECT
    NEXTVAL('"DSWB_cdm".measurement_id_seq') AS measurement_id,
    em.person_id,
    em.measurement_concept_id,
    em.measurement_date,
    em.measurement_datetime,
    NULL AS measurement_time,
    32818 AS measurement_type_concept_id,
    NULL AS operator_concept_id,
    CASE 
        WHEN em.raw_value::text ~ '^-?\\d+(\\.\\d+)?$' THEN em.raw_value::numeric 
        ELSE NULL 
    END AS value_as_number,
    NULL AS value_as_concept_id,
    NULL AS unit_concept_id,
    NULL AS range_low,
    NULL AS range_high,
    NULL AS provider_id,
    NULL AS visit_occurrence_id,
    NULL AS visit_detail_id,
    em.measurement_name,
    0 AS measurement_source_concept_id,
    NULL AS unit_source_value,
    NULL AS unit_source_concept_id,
    NULL AS value_source_value,
    NULL AS measurement_event_id,
    NULL AS meas_event_field_concept_id
FROM extracted_measurements em
WHERE em.raw_value IS NOT NULL;


-- 'Measurements below are not inserted (no concept ID). Handle them later'
-- 'Macroscopy of pleural fluid'
-- 'Pleural proteins (/mm3)'
-- 'ascitic fluid proteins'
-- 'ascites leukocytes'
-- '% of lymphocytes in ascites'
-- 'smoking index'
-- 'ethyl index'
-- 'o2 flow rate (in liters/min)'
-- 'prothrombin rate'
-- 'HIV serology during hospitalization'