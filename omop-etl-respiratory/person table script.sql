CREATE SEQUENCE IF NOT EXISTS "DSWB_cdm"."person_id_seq"
START WITH 1
INCREMENT BY 1
OWNED BY "DSWB_cdm"."person".person_id;

SELECT * FROM "DSWB_cdm"."person" ORDER BY person_id DESC LIMIT 5;


INSERT INTO "DSWB_cdm"."person" (
    person_id, -- Auto-generated if managed by the database
    gender_concept_id, -- Male = 8507, Female = 8532
    year_of_birth, 
    month_of_birth,
    day_of_birth,
    birth_datetime,
    race_concept_id, -- 38003600 = African
    ethnicity_concept_id, -- 38003564 = Not Hispanic or Latino
    location_id,
    provider_id,
    care_site_id,
    person_source_value,
    gender_source_value,
    gender_source_concept_id,
    race_source_value,
    race_source_concept_id,
    ethnicity_source_value,
    ethnicity_source_concept_id
)
SELECT
	  nextval('"DSWB_cdm"."person_id_seq"') AS person_id, -- Generate value from sequence
    
    -- Mapping gender to OMOP concept_id
    CASE 
        WHEN "Sex" = 'male' THEN 8507
        WHEN "Sex" = 'female' THEN 8532
        ELSE NULL 
    END AS gender_concept_id,

    -- Compute year of birth based on consultation year and age
    ("Year of consultation" - "Age") AS year_of_birth,

    -- No available source columns for month and day of birth
    NULL AS month_of_birth,
    NULL AS day_of_birth,
    NULL AS birth_datetime,

    -- Default race value (modify if other races exist)
    38003600 AS race_concept_id,

    -- Default ethnicity value
    38003564 AS ethnicity_concept_id,

    -- Foreign keys (should be updated if valid references exist)
    NULL AS location_id,
    NULL AS provider_id,
    NULL AS care_site_id,

    -- Patient's unique source identifier
    "unique_code" AS person_source_value,

    -- Source value for gender
    "Sex" AS gender_source_value,

    -- Gender source concept ID (no mapping available)
    NULL AS gender_source_concept_id,

    -- Race and ethnicity source values (if available)
    NULL AS race_source_value,
    NULL AS race_source_concept_id,
    NULL AS ethnicity_source_value,
    NULL AS ethnicity_source_concept_id

FROM respiratorydisease."respiratorydiseasedataset";
