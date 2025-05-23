-- Create the sequence
CREATE SEQUENCE IF NOT EXISTS "DSWB_cdm".provider_id_seq
    START WITH 1
    INCREMENT BY 1
    OWNED BY "DSWB_cdm".provider.provider_id;

-- insert into the provider table
INSERT INTO "DSWB_cdm".provider
(
    provider_id, -- autogenerated key.
    provider_name, -- General practitioners
    npi, -- #Set to NULL
    dea,
    specialty_concept_id,
    care_site_id, -- #Foreign key for care_site table
    year_of_birth,
    gender_concept_id,
    provider_source_value,
    specialty_source_value,
    specialty_source_concept_id,
    gender_source_value,
    gender_source_concept_id
)
SELECT
    NEXTVAL('"DSWB_cdm".provider_id_seq') AS provider_id,
    'Default Provider' AS provider_name,
    NULL AS npi,
    NULL AS dea,
    NULL AS specialty_concept_id,
    NULL AS care_site_id,
    NULL AS year_of_birth,
    NULL AS gender_concept_id,
    'Default_Provider' AS provider_source_value,
    NULL AS specialty_source_value,
    NULL AS specialty_source_concept_id,
    NULL AS gender_source_value,
    NULL AS gender_source_concept_id
FROM (SELECT 1) AS dummy;
