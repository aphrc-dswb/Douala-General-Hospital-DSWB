SET search_path TO "DSWB_cdm";

-- 1) On purge la table et on réinitialise l’identité
TRUNCATE TABLE care_site RESTART IDENTITY CASCADE;

-- 2) On force la remise à 1 de la séquence
ALTER SEQUENCE care_site_id_seq RESTART WITH 1;

-- 3) On réassigne la propriété (optionnel si déjà fait avant)
ALTER SEQUENCE care_site_id_seq OWNED BY care_site.care_site_id;

-- 4) On réinsère enfin nos données
INSERT INTO care_site (
    care_site_id,
    care_site_name,
    place_of_service_concept_id,
    location_id,
    care_site_source_value,
    place_of_service_source_value
)
VALUES (
    nextval('care_site_id_seq'),
    'Douala General Hospital',
    NULL,
    1,
    'Douala General Hospital',
    NULL
);
