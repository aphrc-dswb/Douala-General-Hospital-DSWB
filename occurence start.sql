SET search_path TO "DSWB_cdm";

-- Create the sequence for condition_occurrence if it doesn't already exist
CREATE SEQUENCE IF NOT EXISTS condition_occurrence_id_seq;

-- Insert medical history (antecedents) into condition_occurrence
INSERT INTO condition_occurrence (
    condition_occurrence_id,
    person_id,
    condition_concept_id,
    condition_start_date,
    condition_start_datetime,
    condition_end_date,
    condition_end_datetime,
    condition_type_concept_id,
    condition_status_concept_id,
    stop_reason,
    provider_id,
    visit_occurrence_id,
    visit_detail_id,
    condition_source_value,
    condition_source_concept_id,
    condition_status_source_value
)
SELECT
    nextval('condition_occurrence_id_seq') AS condition_occurrence_id,
    p.person_id,
    CASE 
        WHEN r."History of tuberculosis" = 'Yes' THEN 4285825
        WHEN r."History of Asthma" = 'Yes' THEN 317009
        WHEN r."History of GERD" = 'Yes' THEN 313217
        WHEN r."History of COPD" = 'Yes' THEN 312327
        WHEN r."History of Pneumonia" = 'Yes' THEN 319835
        WHEN r."History of Diabetes" = 'Yes' THEN 201826
        WHEN r."History of chronic renal failure" = 'Yes' THEN 4030518
        WHEN r."History of HTA" = 'Yes' THEN 320128
        WHEN r."History of Heart Disease" = 'Yes' THEN 316866
        WHEN r."History of stroke" = 'Yes' THEN 372924
        WHEN r."History of viral hepatitis" = 'Yes' THEN 40484648
        ELSE NULL
    END AS condition_concept_id,

    CAST(r."Date hospitalized...9" AS DATE) AS condition_start_date,
    NULL AS condition_start_datetime,
    COALESCE(CAST(r."Release date...10" AS DATE), CAST(r."Date hospitalized...9" AS DATE)) AS condition_end_date,
    NULL AS condition_end_datetime,

    38000245 AS condition_type_concept_id,  -- EHR Problem List Entry

    NULL AS condition_status_concept_id,
    NULL AS stop_reason,
    NULL AS provider_id,
    NULL AS visit_occurrence_id,
    NULL AS visit_detail_id,

    CASE 
        WHEN r."History of tuberculosis" = 'Yes' THEN 'History of Tuberculosis'
        WHEN r."History of Asthma" = 'Yes' THEN 'History of Asthma'
        WHEN r."History of GERD" = 'Yes' THEN 'History of GERD'
        WHEN r."History of COPD" = 'Yes' THEN 'History of COPD'
        WHEN r."History of Pneumonia" = 'Yes' THEN 'History of Pneumonia'
        WHEN r."History of Diabetes" = 'Yes' THEN 'History of Diabetes'
        WHEN r."History of chronic renal failure" = 'Yes' THEN 'History of Chronic Renal Failure'
        WHEN r."History of HTA" = 'Yes' THEN 'History of Hypertension'
        WHEN r."History of Heart Disease" = 'Yes' THEN 'History of Heart Disease'
        WHEN r."History of stroke" = 'Yes' THEN 'History of Stroke'
        WHEN r."History of viral hepatitis" = 'Yes' THEN 'History of Viral Hepatitis'
        ELSE NULL
    END AS condition_source_value,

    NULL AS condition_source_concept_id,
    NULL AS condition_status_source_value

FROM
    respiratorydisease.respiratorydiseasedataset r
JOIN
    "DSWB_cdm".person p
ON
    r."unique_code" = p.person_source_value

-- Only include rows where at least one antecedent is present
WHERE
    r."unique_code" IS NOT NULL AND (
        r."History of tuberculosis" = 'Yes' OR
        r."History of Asthma" = 'Yes' OR
        r."History of GERD" = 'Yes' OR
        r."History of COPD" = 'Yes' OR
        r."History of Pneumonia" = 'Yes' OR
        r."History of Diabetes" = 'Yes' OR
        r."History of chronic renal failure" = 'Yes' OR
        r."History of HTA" = 'Yes' OR
        r."History of Heart Disease" = 'Yes' OR
        r."History of stroke" = 'Yes' OR
        r."History of viral hepatitis" = 'Yes'
    );
