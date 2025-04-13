-- Step 1: Create the sequence for auto-generating care_site_id
CREATE SEQUENCE IF NOT EXISTS "DSWB_cdm"."care_site_id_seq"
START WITH 1
INCREMENT BY 1
OWNED BY "DSWB_cdm"."care_site".care_site_id;

-- Step 2: Set default value for care_site_id column using the sequence
ALTER TABLE "DSWB_cdm"."care_site"
ALTER COLUMN care_site_id SET DEFAULT nextval('"DSWB_cdm"."care_site_id_seq"');


-- Step 4: Insert data into the care_site table
INSERT INTO "DSWB_cdm"."care_site" (
    care_site_name, 
    place_of_service_concept_id,
    location_id,
    care_site_source_value,
    place_of_service_source_value
)
SELECT
    'Douala General Hospital' AS care_site_name, -- Example name for the care site
    NULL AS place_of_service_concept_id, -- Default value
    1 AS location_id, -- Foreign key reference, update with valid ID if necessary
    NULL AS care_site_source_value, -- Default value
    NULL AS place_of_service_source_value -- Default value
FROM respiratorydisease."respiratorydiseasedataset";

--in this code i dont mentionned the person ID