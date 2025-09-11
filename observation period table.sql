SET search_path TO "DSWB_cdm";

-- Créer la séquence si elle n'existe pas
CREATE SEQUENCE IF NOT EXISTS observation_period_id_seq;

-- Insérer dans observation_period
INSERT INTO observation_period (
    observation_period_id,
    person_id,
    observation_period_start_date,
    observation_period_end_date,
    period_type_concept_id
)
SELECT
    nextval('observation_period_id_seq') AS observation_period_id,
    p.person_id,
    CAST(r."Date hospitalized...9" AS DATE) AS observation_period_start_date,
    COALESCE(CAST(r."Release date...10" AS DATE), CAST(r."Date hospitalized...9" AS DATE)) AS observation_period_end_date,
    32818 AS period_type_concept_id  -- "EHR administration record"
FROM
    respiratorydisease.respiratorydiseasedataset r
JOIN
    "DSWB_cdm".person p
ON
    r."unique_code" = p.person_source_value
WHERE
    r."unique_code" IS NOT NULL;
