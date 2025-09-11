SET search_path TO "DSWB_cdm";

-- Étape 1 : Vider proprement la table et réinitialiser la séquence
TRUNCATE TABLE person RESTART IDENTITY CASCADE;

-- Étape 2 : Recréer la séquence si nécessaire (ne fera rien si déjà existante)
ALTER SEQUENCE person_id_seq RESTART WITH 1;

-- Étape 3 : Insérer les données dans la table person
INSERT INTO person (
    person_id,
    gender_concept_id,
    year_of_birth,
    month_of_birth,
    day_of_birth,
    birth_datetime,
    race_concept_id,           -- 38003600 = African
    ethnicity_concept_id,      -- 38003564 = Not Hispanic or Latino
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
    nextval('person_id_seq') AS person_id,
    CASE 
        WHEN LOWER(TRIM(r."Sex")) = 'male' THEN 8507
        WHEN LOWER(TRIM(r."Sex")) = 'female' THEN 8532
        ELSE 8551
    END AS gender_concept_id,
    (CAST(r."Year of consultation" AS INTEGER) - CAST(r."Age" AS INTEGER)) AS year_of_birth,
    NULL AS month_of_birth,
    NULL AS day_of_birth,
    NULL AS birth_datetime,
    38003600 AS race_concept_id,               -- African
    38003564 AS ethnicity_concept_id,          -- Not Hispanic or Latino
    1 AS location_id,
    1 AS provider_id,
    1 AS care_site_id,
    r."unique_code" AS person_source_value,
    r."Sex" AS gender_source_value,
    NULL AS gender_source_concept_id,
    'African' AS race_source_value,
    NULL AS race_source_concept_id,
    'Not Hispanic or Latino' AS ethnicity_source_value,
    NULL AS ethnicity_source_concept_id
FROM respiratorydisease.respiratorydiseasedataset r
WHERE r."unique_code" IS NOT NULL;
