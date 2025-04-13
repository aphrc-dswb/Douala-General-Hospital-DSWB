-- Step 1: Create the sequence if it doesn't exist
CREATE SEQUENCE IF NOT EXISTS "DSWB_cdm"."observation_id_seq"
    START WITH 1
    INCREMENT BY 1
    OWNED BY "DSWB_cdm".observation.observation_id;

-- Step 2: Insert data into the observation table
INSERT INTO "DSWB_cdm".observation (
    observation_id,
    person_id,
    observation_concept_id,
    observation_date,
    observation_datetime,
    observation_type_concept_id,
    value_as_number,
    value_as_string,
    value_as_concept_id,
    qualifier_concept_id,
    unit_concept_id,
    provider_id,
    visit_occurrence_id,
    visit_detail_id,
    observation_source_value,
    observation_source_concept_id,
    unit_source_value,
    qualifier_source_value,
    value_source_value,
    observation_event_id,
    obs_event_field_concept_id
)
SELECT
    NEXTVAL('"DSWB_cdm"."observation_id_seq"') AS observation_id,
    p.person_id,
    
    -- Map the concept ID of the observation
    CASE obs_name
        WHEN 'Smoking status' THEN 4305491  -- Smoking behavior
        WHEN 'Alcohol consumption' THEN 4052040  -- Alcohol consumption
        WHEN 'Recent surgery' THEN 4214956  -- Surgical history
    END AS observation_concept_id,

    sd."Date hospitalized...9"::date AS observation_date,
    sd."Date hospitalized...9"::timestamp AS observation_datetime,
    
    32818 AS observation_type_concept_id,
    NULL AS value_as_number,

    obs_value AS value_as_string,

    CASE 
        WHEN obs_value ILIKE 'yes' THEN 4188539  -- Yes
        WHEN obs_value ILIKE 'no' THEN 4188540   -- No
        ELSE NULL
    END AS value_as_concept_id,

    NULL AS qualifier_concept_id,
    NULL AS unit_concept_id,
    NULL AS provider_id,
    NULL AS visit_occurrence_id,
    NULL AS visit_detail_id,

    obs_value AS observation_source_value,
    0 AS observation_source_concept_id,
    NULL AS unit_source_value,
    NULL AS qualifier_source_value,
    NULL AS value_source_value,
    NULL AS observation_event_id,
    NULL AS obs_event_field_concept_id

FROM respiratorydisease.respiratorydiseasedataset sd
JOIN "DSWB_cdm".person p ON p.person_source_value = sd."unique_code"

-- UNNEST to normalize the 3 observation columns
CROSS JOIN LATERAL (
    VALUES 
        ('Smoking status', sd."Smoking status"),
        ('Alcohol consumption', sd."Alcohol consumption"),
        ('Recent surgery', sd."Recent surgery")
) AS obs(obs_name, obs_value)

WHERE obs_value IS NOT NULL;
