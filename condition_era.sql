-- Définir le schéma de travail
SET search_path TO "DSWB_cdm";

-- 0. Réinitialiser proprement la table condition_era
TRUNCATE TABLE condition_era RESTART IDENTITY CASCADE;

-- (Par sécurité, on remet la séquence à 1 même si le TRUNCATE l’a fait)
ALTER SEQUENCE condition_era_id_seq RESTART WITH 1;

-- 1. Créer la séquence si nécessaire
CREATE SEQUENCE IF NOT EXISTS condition_era_id_seq 
    START 1 INCREMENT 1 OWNED BY condition_era.condition_era_id;

-- 2. Construire les condition_era avec persistance de 30 jours
WITH sorted_conditions AS (
  SELECT
    person_id,
    condition_concept_id,
    condition_start_date,
    COALESCE(condition_end_date, condition_start_date) AS end_date
  FROM condition_occurrence
  WHERE condition_concept_id IN (
    SELECT concept_id FROM concept
    WHERE standard_concept = 'S' 
      AND domain_id = 'Condition' 
      AND invalid_reason IS NULL
  )
),
paired AS (
  SELECT 
    sc.*,
    LAG(end_date) OVER (
      PARTITION BY person_id, condition_concept_id 
      ORDER BY condition_start_date
    ) AS prev_end_date
  FROM sorted_conditions sc
),
flagged AS (
  SELECT *,
    CASE 
      WHEN prev_end_date IS NULL THEN 1
      WHEN condition_start_date > prev_end_date + INTERVAL '30 days' THEN 1
      ELSE 0
    END AS era_start_flag
  FROM paired
),
grouped AS (
  SELECT *,
    SUM(era_start_flag) OVER (
      PARTITION BY person_id, condition_concept_id 
      ORDER BY condition_start_date
      ROWS UNBOUNDED PRECEDING
    ) AS era_group
  FROM flagged
),
era_build AS (
  SELECT
    person_id,
    condition_concept_id,
    MIN(condition_start_date) AS condition_era_start_date,
    MAX(end_date) AS condition_era_end_date,
    COUNT(*) AS condition_occurrence_count
  FROM grouped
  GROUP BY person_id, condition_concept_id, era_group
)

-- 3. Insertion dans la table condition_era
INSERT INTO condition_era (
  condition_era_id,
  person_id,
  condition_concept_id,
  condition_era_start_date,
  condition_era_end_date,
  condition_occurrence_count
)
SELECT
  nextval('condition_era_id_seq'),
  person_id,
  condition_concept_id,
  condition_era_start_date,
  condition_era_end_date,
  condition_occurrence_count
FROM era_build;
