SET search_path TO "DSWB_cdm";

-- Recréation de la séquence si nécessaire
CREATE SEQUENCE IF NOT EXISTS observation_id_seq;

-- Insertion des antécédents médicaux dans la table observation
INSERT INTO observation (
    observation_id,
    person_id,
    observation_concept_id,
    observation_date,
    observation_type_concept_id,
    value_as_concept_id,
    provider_id,
    visit_occurrence_id,
    observation_source_value
)
SELECT
    nextval('observation_id_seq'),
    p.person_id,
    CASE 
        WHEN r."History of tuberculosis" = 'Yes' THEN 4285825
        WHEN r."History of Asthma" = 'Yes' THEN 4193005
        WHEN r."History of GERD" = 'Yes' THEN 4319980
        WHEN r."History of COPD" = 'Yes' THEN 443761
        WHEN r."History of Pneumonia" = 'Yes' THEN 4304394
        WHEN r."History of Diabetes" = 'Yes' THEN 201820
        WHEN r."History of chronic renal failure" = 'Yes' THEN 4030518
        WHEN r."History of HTA" = 'Yes' THEN 320128
        WHEN r."History of Heart Disease" = 'Yes' THEN 316866
        WHEN r."History of stroke" = 'Yes' THEN 372924
        WHEN r."History of viral hepatitis" = 'Yes' THEN 40484648
        ELSE NULL
    END,
    CAST(r."Date hospitalized...9" AS DATE),
    32818,  -- EHR Observation
    CASE 
        WHEN r."History of tuberculosis" = 'Yes' OR r."History of Asthma" = 'Yes' OR
             r."History of GERD" = 'Yes' OR r."History of COPD" = 'Yes' OR
             r."History of Pneumonia" = 'Yes' OR r."History of Diabetes" = 'Yes' OR
             r."History of chronic renal failure" = 'Yes' OR r."History of HTA" = 'Yes' OR
             r."History of Heart Disease" = 'Yes' OR r."History of stroke" = 'Yes' OR
             r."History of viral hepatitis" = 'Yes' 
        THEN 4188539  -- Yes
        ELSE 4188540  -- No
    END,
    pr.provider_id,
    vo.visit_occurrence_id,
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
    END
FROM respiratorydisease.respiratorydiseasedataset r
JOIN person p ON r."unique_code" = p.person_source_value
LEFT JOIN visit_occurrence vo ON vo.person_id = p.person_id AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
LEFT JOIN provider pr ON pr.provider_id = 1
WHERE r."unique_code" IS NOT NULL AND (
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
