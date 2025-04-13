-- Step 1: Ensure the sequence exists for location_id
CREATE SEQUENCE IF NOT EXISTS "DSWB_cdm".location_id_seq
    START WITH 1
    INCREMENT BY 1
    OWNED BY "DSWB_cdm".location.location_id;

-- Step 2: Insert the location with valid lengths
INSERT INTO "DSWB_cdm".location (
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
    NEXTVAL('"DSWB_cdm".location_id_seq'),
    NULL,                      -- address_1
    NULL,                      -- address_2
    'Douala',                  -- city (OK, varchar(50))
    'LT',                      -- state abbreviated to fit varchar(2)
    NULL,                      -- zip
    NULL,                      -- county
    'Douala-CMR',              -- location_source_value
    4075199,                   -- country_concept_id for Cameroon
    'Cameroon',                -- country_source_value
    4.0511,                    -- latitude
    9.7679                     -- longitude
);
