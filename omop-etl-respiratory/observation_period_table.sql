-- Step 1: Create the sequence if not already created
CREATE SEQUENCE IF NOT EXISTS "DSWB_cdm".observation_period_id_seq
    START WITH 1
    INCREMENT BY 1
    OWNED BY "DSWB_cdm".observation_period.observation_period_id;

-- Step 2: Insert into observation_period (only rows with non-null release date)
INSERT INTO "DSWB_cdm".observation_period (
    observation_period_id,
    person_id,
    observation_period_start_date,
    observation_period_end_date,
    period_type_concept_id
)
SELECT
    NEXTVAL('"DSWB_cdm".observation_period_id_seq') AS observation_period_id,
    p.person_id,
    sd."Date hospitalized...9"::date AS observation_period_start_date,
    sd."Release date...10"::date AS observation_period_end_date,
    32818 AS period_type_concept_id
FROM respiratorydisease.respiratorydiseasedataset sd
JOIN "DSWB_cdm".person p ON p.person_source_value = sd."unique_code"
WHERE sd."Date hospitalized...9" IS NOT NULL
  AND sd."Release date...10" IS NOT NULL;
