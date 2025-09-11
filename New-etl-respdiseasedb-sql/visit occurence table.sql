SET search_path TO "DSWB_cdm";

-- Réinitialiser proprement la table visit_occurrence
TRUNCATE TABLE visit_occurrence RESTART IDENTITY CASCADE;


-- Recréer la séquence (si besoin) et la réinitialiser à 1
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class WHERE relname = 'visit_occurrence_id_seq'
    ) THEN
        CREATE SEQUENCE visit_occurrence_id_seq;
    ELSE
        ALTER SEQUENCE visit_occurrence_id_seq RESTART WITH 1;
    END IF;
END$$;

-- Insérer les données
INSERT INTO visit_occurrence (
    visit_occurrence_id,
    person_id,
    visit_concept_id,
    visit_start_date,
    visit_start_datetime,
    visit_end_date,
    visit_end_datetime,
    visit_type_concept_id,
    provider_id,
    care_site_id,
    visit_source_value,
    visit_source_concept_id,
    admitted_from_concept_id,
    admitted_from_source_value,
    discharged_to_concept_id,
    discharged_to_source_value,
    preceding_visit_occurrence_id
)
SELECT
    nextval('visit_occurrence_id_seq'),
    p.person_id,
    9201,  -- Inpatient Visit
    CAST(r."Date hospitalized...9" AS DATE),
    NULL,
    COALESCE(CAST(r."Release date...10" AS DATE), CAST(r."Date hospitalized...9" AS DATE)),
    NULL,
    32818,  -- EHR administration record
    1,      -- provider_id (associé au provider déjà inséré)
    1,      -- care_site_id (Douala General Hospital)
    'Hospitalization',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p
  ON r."unique_code" = p.person_source_value
WHERE r."Date hospitalized...9" IS NOT NULL;
