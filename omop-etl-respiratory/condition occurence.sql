CREATE SEQUENCE IF NOT EXISTS "DSWB_cdm".condition_occurrence_id_seq
    START WITH 1
    INCREMENT BY 1
    OWNED BY "DSWB_cdm".condition_occurrence.condition_occurrence_id;

WITH source_data AS (
    SELECT 
        sd."unique_code" AS patient_id,
        p.person_id,
        sd."Date hospitalized...9"::date AS condition_start_date,
        sd."Release date...10"::date AS condition_end_date,
        unnest(array[
            CASE WHEN sd."History of tuberculosis" = 'Yes' THEN 154283005 ELSE NULL END,
            CASE WHEN sd."History of Asthma" = 'Yes' THEN 195967001 ELSE NULL END,
            CASE WHEN sd."History of GERD" = 'Yes' THEN 40845000 ELSE NULL END,
            CASE WHEN sd."History of COPD" = 'Yes' THEN 13645005 ELSE NULL END,
            CASE WHEN sd."History of Pneumonia" = 'Yes' THEN 233604007 ELSE NULL END,
            CASE WHEN sd."History of Diabetes" = 'Yes' THEN 201820 ELSE NULL END,
            CASE WHEN sd."History of chronic renal failure" = 'Yes' THEN 709044004 ELSE NULL END,
            CASE WHEN sd."History of HTA" = 'Yes' THEN 38341003 ELSE NULL END,
            CASE WHEN sd."History of Heart Disease" = 'Yes' THEN 49601007 ELSE NULL END,
            CASE WHEN sd."History of stroke" = 'Yes' THEN 230690007 ELSE NULL END,
            CASE WHEN sd."History of viral hepatitis" = 'Yes' THEN 40468003 ELSE NULL END
        ]) AS condition_concept_id,

        unnest(array[
            'History of tuberculosis',
            'History of asthma',
            'History of gerd',
            'History of copd',
            'History of pneumonia',
            'History of diabetes',
            'History of chronic renal failure',
            'History of hta',
            'History of heart disease',
            'History of stroke',
            'History of viral hepatitis'
        ]) AS condition_source_value

    FROM respiratorydisease.respiratorydiseasedataset sd
    JOIN "DSWB_cdm".person p ON p.person_source_value = sd."unique_code"

    UNION ALL

    SELECT 
        sd."unique_code" AS patient_id,
        p.person_id,
        sd."Date hospitalized...9"::date AS condition_start_date,
        sd."Release date...10"::date AS condition_end_date,
        
        -- Type of hepatitis mapping
        CASE 
            WHEN sd."Type of hepatitis" = 'Viral hepatitis C' THEN 197494
            WHEN sd."Type of hepatitis" = 'Viral hepatitis B' THEN 4281232
            ELSE NULL 
        END AS condition_concept_id,
        sd."Type of hepatitis" AS condition_source_value

    FROM respiratorydisease.respiratorydiseasedataset sd
    JOIN "DSWB_cdm".person p ON p.person_source_value = sd."unique_code"

    UNION ALL

    SELECT 
        sd."unique_code" AS patient_id,
        p.person_id,
        sd."Date hospitalized...9"::date AS condition_start_date,
        sd."Release date...10"::date AS condition_end_date,
        
        -- Final diagnosis (1) mapping
        CASE sd."name of final diagnosis"
            WHEN 'Asthma' THEN 195967001
            WHEN 'AVC and complication' THEN 230690007
            WHEN 'Bronchitis' THEN 32398004
            WHEN 'Cancer' THEN 254837009
            WHEN 'COPD' THEN 13645005
            WHEN 'Kaposi' THEN 109385007
            WHEN 'Other' THEN 44814645
            WHEN 'Pneumonia' THEN 233604007
            WHEN 'Pulmonary embolism' THEN 59282003
            WHEN 'sepsis' THEN 91302008
            WHEN 'Tuberculosis' THEN 56717001
            ELSE NULL
        END AS condition_concept_id,
        sd."name of final diagnosis" AS condition_source_value

    FROM respiratorydisease.respiratorydiseasedataset sd
    JOIN "DSWB_cdm".person p ON p.person_source_value = sd."unique_code"

    UNION ALL

    SELECT 
        sd."unique_code" AS patient_id,
        p.person_id,
        sd."Date hospitalized...9"::date AS condition_start_date,
        sd."Release date...10"::date AS condition_end_date,
        
        -- Signs and symptoms mapping
        unnest(array[
            CASE WHEN sd."Anorexia" = 'Yes' THEN 267064002 ELSE NULL END,
            CASE WHEN sd."Asthenia" = 'Yes' THEN 84229001 ELSE NULL END,
            CASE WHEN sd."Night sweating" = 'Yes' THEN 248651008 ELSE NULL END,
            CASE WHEN sd."Fever" = 'Yes' THEN 386661006 ELSE NULL END,
            CASE WHEN sd."Cough" = 'Yes' THEN 49727002 ELSE NULL END,
            CASE WHEN sd."Expectoration" = 'Yes' THEN 11833005 ELSE NULL END,
            CASE WHEN sd."Hemoptysis" = 'Yes' THEN 66857006 ELSE NULL END,
            CASE WHEN sd."Dyspnea" = 'Yes' THEN 267036007 ELSE NULL END
        ]) AS condition_concept_id,

        unnest(array[
            'anorexia',
            'asthenia',
            'night sweating',
            'fever',
            'cough',
            'expectoration',
            'hemoptysis',
            'dyspnea'
        ]) AS condition_source_value

    FROM respiratorydisease.respiratorydiseasedataset sd
    JOIN "DSWB_cdm".person p ON p.person_source_value = sd."unique_code"
),

-- Final insertion
insert_data AS (
    SELECT
        NEXTVAL('"DSWB_cdm".condition_occurrence_id_seq') AS condition_occurrence_id,
        person_id,
        condition_concept_id,
        condition_start_date,
        condition_start_date::timestamp AS condition_start_datetime,
        condition_end_date,
        condition_end_date::timestamp AS condition_end_datetime,
        32817 AS condition_type_concept_id, -- From EHR
        32890 AS condition_status_concept_id,
        NULL::text AS stop_reason,
        NULL::int AS provider_id,
        NULL::int AS visit_occurrence_id,
        NULL::int AS visit_detail_id,
        condition_source_value,
        0 AS condition_source_concept_id,
        NULL::text AS condition_status_source_value
    FROM source_data
    WHERE condition_concept_id IS NOT NULL
)
INSERT INTO "DSWB_cdm".condition_occurrence (
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
SELECT * FROM insert_data;
