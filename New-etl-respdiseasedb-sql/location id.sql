-- Se placer dans le bon schéma
SET search_path TO "DSWB_cdm";

-- 1. Vider proprement la table location
TRUNCATE TABLE location RESTART IDENTITY CASCADE;

-- 2. Supprimer la séquence si elle existe (pour la recréer ensuite)
DROP SEQUENCE IF EXISTS location_id_seq;

-- 3. Recréer la séquence
CREATE SEQUENCE location_id_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- 4. Insérer la ville de Douala
INSERT INTO location (
    location_id,
    address_1,
    address_2,
    city,
    state,
    zip,
    county,
    location_source_value,
    country_concept_id,
    country_source_value,
    latitude,
    longitude
)
VALUES (
    nextval('location_id_seq'),
    NULL,
    NULL,
    'Douala',
    'CM',  -- Code ISO 3166-2 du Cameroun
    NULL,
    NULL,
    'Douala',
    4075199,  -- Concept ID pour Cameroun
    'CM',
    4.0511,
    9.7679
);
