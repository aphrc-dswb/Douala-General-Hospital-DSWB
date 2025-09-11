SET search_path TO "DSWB_cdm";

-- 1) Créer la séquence si elle n'existe pas
CREATE SEQUENCE IF NOT EXISTS provider_id_seq
  START WITH 1
  OWNED BY provider.provider_id;

-- 2) Associer la séquence à la colonne provider_id (pour RESTART IDENTITY)
ALTER TABLE provider
  ALTER COLUMN provider_id SET DEFAULT nextval('provider_id_seq');

-- 3) Vider la table et remettre la séquence à 1
TRUNCATE TABLE provider RESTART IDENTITY CASCADE;

-- 4) Ré-injecter vos données en récupérant le care_site_id de "Douala General Hospital"
INSERT INTO provider (
    provider_id,
    provider_name,
    npi,
    dea,
    specialty_concept_id,
    care_site_id,
    year_of_birth,
    gender_concept_id,
    provider_source_value,
    specialty_source_value,
    specialty_source_concept_id,
    gender_source_value,
    gender_source_concept_id
)
SELECT
    nextval('provider_id_seq')             AS provider_id,
    'General practitioners'                AS provider_name,
    NULL                                   AS npi,
    NULL                                   AS dea,
    NULL                                   AS specialty_concept_id,
    cs.care_site_id                        AS care_site_id,
    NULL                                   AS year_of_birth,
    NULL                                   AS gender_concept_id,
    'General practitioners'                AS provider_source_value,
    NULL                                   AS specialty_source_value,
    NULL                                   AS specialty_source_concept_id,
    NULL                                   AS gender_source_value,
    NULL                                   AS gender_source_concept_id
FROM care_site cs
WHERE cs.care_site_name = 'Douala General Hospital'
;
