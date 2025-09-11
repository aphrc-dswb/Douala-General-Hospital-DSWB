SET search_path TO "DSWB_cdm";
TRUNCATE TABLE observation RESTART IDENTITY CASCADE;

ALTER SEQUENCE "DSWB_cdm".observation_id_seq RESTART WITH 1;

INSERT INTO observation
(
    observation_id,            -- PK
    person_id,                 -- FK → person.person_id
    observation_concept_id,    -- concept ID de l’observation
    observation_date,          -- date de l’observation
    observation_datetime,      -- datetime (NULL ici)
    observation_type_concept_id,-- 32818 = EHR administration record

    value_as_concept_id,       -- 4188539/4188540 = Yes/No

    provider_id,               -- FK → visit_occurrence.provider_id
    visit_occurrence_id,       -- FK → visit_occurrence.visit_occurrence_id
    observation_source_value  -- verbatim

)
-- 1) Smoking status
SELECT
    nextval('observation_id_seq')::INTEGER,
    p.person_id,
    1005973::INTEGER,                                             -- Smoking status
    CAST(r."Date hospitalized...9" AS DATE),
    NULL::timestamp without time zone,
    32818,
    CASE WHEN TRIM(r."Smoking status") = 'Yes' THEN 4188539
         WHEN TRIM(r."Smoking status") = 'No'  THEN 4188540
         ELSE NULL END,
    1,
    vo.visit_occurrence_id,

    'Smoking status'   
FROM respiratorydisease.respiratorydiseasedataset AS r
JOIN "DSWB_cdm".person           AS p  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence AS vo ON vo.person_id = p.person_id
                                        AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Smoking status" IS NOT NULL
  AND TRIM(r."Smoking status") IN ('Yes','No')

UNION ALL

-- 2) Alcohol consumption
SELECT
    nextval('observation_id_seq'),
    p.person_id,
    1586197,                                                       -- Alcohol consumption
    CAST(r."Date hospitalized...9" AS DATE),
    NULL::timestamp without time zone,
    32818,
    CASE WHEN TRIM(r."Alcohol consumption") = 'Yes' THEN 4188539
         WHEN TRIM(r."Alcohol consumption") = 'No'  THEN 4188540
         ELSE NULL END,
    1,
    vo.visit_occurrence_id,

    'Alcohol consumption'
FROM respiratorydisease.respiratorydiseasedataset AS r
JOIN "DSWB_cdm".person           AS p  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence AS vo ON vo.person_id = p.person_id
                                        AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Alcohol consumption" IS NOT NULL
  AND TRIM(r."Alcohol consumption") IN ('Yes','No')

UNION ALL

-- 3) Recent surgery
SELECT
    nextval('observation_id_seq'),
    p.person_id,
    35826898,                                                       -- Recent surgery
    CAST(r."Date hospitalized...9" AS DATE),
    NULL::timestamp without time zone,
    32818,
    CASE WHEN TRIM(r."Recent surgery") = 'Yes' THEN 4188539
         WHEN TRIM(r."Recent surgery") = 'No'  THEN 4188540
         ELSE NULL END,
    1,
    vo.visit_occurrence_id,
    'Recent surgery'
FROM respiratorydisease.respiratorydiseasedataset AS r
JOIN "DSWB_cdm".person           AS p  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence AS vo ON vo.person_id = p.person_id
                                        AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Recent surgery" IS NOT NULL
  AND TRIM(r."Recent surgery") IN ('Yes','No')

UNION ALL

-- 4) Pregnancy
SELECT
    nextval('observation_id_seq'),
    p.person_id,
    4128331,                                                       -- Pregnancy
    CAST(r."Date hospitalized...9" AS DATE),
    NULL::timestamp without time zone,
    32818,
    CASE WHEN TRIM(r."Pregnancy") = 'Yes' THEN 4188539
         WHEN TRIM(r."Pregnancy") = 'No'  THEN 4188540
         ELSE NULL END,
    1,
    vo.visit_occurrence_id,
    'Pregnancy'
FROM respiratorydisease.respiratorydiseasedataset AS r
JOIN "DSWB_cdm".person           AS p  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence AS vo ON vo.person_id = p.person_id
                                        AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Pregnancy" IS NOT NULL
  AND TRIM(r."Pregnancy") IN ('Yes','No')

UNION ALL

-- 5) Weight loss
SELECT
    nextval('observation_id_seq'),
    p.person_id,
    37311267,                                                       -- Weight loss
    CAST(r."Date hospitalized...9" AS DATE),
    NULL::timestamp without time zone,
    32818,
    CASE WHEN TRIM(r."Weight loss") = 'Yes' THEN 4188539
         WHEN TRIM(r."Weight loss") = 'No'  THEN 4188540
         ELSE NULL END,
    1,
    vo.visit_occurrence_id,
    'Weight loss'
FROM respiratorydisease.respiratorydiseasedataset AS r
JOIN "DSWB_cdm".person           AS p  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence AS vo ON vo.person_id = p.person_id
                                        AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Weight loss" IS NOT NULL
  AND TRIM(r."Weight loss") IN ('Yes','No')

UNION ALL

-- 6) Anorexia
SELECT
    nextval('observation_id_seq'),
    p.person_id,
    37613120,                                                       -- Anorexia
    CAST(r."Date hospitalized...9" AS DATE),
    NULL::timestamp without time zone,
    32818,
    CASE WHEN TRIM(r."Anorexia") = 'Yes' THEN 4188539
         WHEN TRIM(r."Anorexia") = 'No'  THEN 4188540
         ELSE NULL END,
    1,
    vo.visit_occurrence_id,
    'Anorexia'
FROM respiratorydisease.respiratorydiseasedataset AS r
JOIN "DSWB_cdm".person           AS p  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence AS vo ON vo.person_id = p.person_id
                                        AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Anorexia" IS NOT NULL
  AND TRIM(r."Anorexia") IN ('Yes','No')

UNION ALL

-- 7) Asthenia
SELECT
    nextval('observation_id_seq'),
    p.person_id,
    437113,                                                       -- Asthenia
    CAST(r."Date hospitalized...9" AS DATE),
    NULL::timestamp without time zone,
    32818,
    CASE WHEN TRIM(r."Asthenia") = 'Yes' THEN 4188539
         WHEN TRIM(r."Asthenia") = 'No'  THEN 4188540
         ELSE NULL END,
    1,
    vo.visit_occurrence_id,
    'Asthenia'
FROM respiratorydisease.respiratorydiseasedataset AS r
JOIN "DSWB_cdm".person           AS p  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence AS vo ON vo.person_id = p.person_id
                                        AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Asthenia" IS NOT NULL
  AND TRIM(r."Asthenia") IN ('Yes','No')

UNION ALL

-- 8) Night sweating
SELECT
    nextval('observation_id_seq'),
    p.person_id,
    40767224,                                                       -- Night sweating
    CAST(r."Date hospitalized...9" AS DATE),
    NULL::timestamp without time zone,
    32818,
    CASE WHEN TRIM(r."Night sweating") = 'Yes' THEN 4188539
         WHEN TRIM(r."Night sweating") = 'No'  THEN 4188540
         ELSE NULL END,

    1,
    vo.visit_occurrence_id,

    'Night sweating'
FROM respiratorydisease.respiratorydiseasedataset AS r
JOIN "DSWB_cdm".person           AS p  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence AS vo ON vo.person_id = p.person_id
                                        AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Night sweating" IS NOT NULL
  AND TRIM(r."Night sweating") IN ('Yes','No')

UNION ALL

-- 9) Fever
SELECT
    nextval('observation_id_seq'),
    p.person_id,
    437663,                                                       -- Fever
    CAST(r."Date hospitalized...9" AS DATE),
    NULL::timestamp without time zone,
    32818,
    CASE WHEN TRIM(r."Fever") = 'Yes' THEN 4188539
         WHEN TRIM(r."Fever") = 'No'  THEN 4188540
         ELSE NULL END,
    1,
    vo.visit_occurrence_id,
    'Fever'
FROM respiratorydisease.respiratorydiseasedataset AS r
JOIN "DSWB_cdm".person           AS p  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence AS vo ON vo.person_id = p.person_id
                                        AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Fever" IS NOT NULL
  AND TRIM(r."Fever") IN ('Yes','No')

UNION ALL

-- 10) Cough
SELECT
    nextval('observation_id_seq'),
    p.person_id,
    254761,                                                       -- Cough
    CAST(r."Date hospitalized...9" AS DATE),
    NULL::timestamp without time zone,
    32818,
    CASE WHEN TRIM(r."Cough") = 'Yes' THEN 4188539
         WHEN TRIM(r."Cough") = 'No'  THEN 4188540
         ELSE NULL END,
    1,
    vo.visit_occurrence_id,
    'Cough'
FROM respiratorydisease.respiratorydiseasedataset AS r
JOIN "DSWB_cdm".person           AS p  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence AS vo ON vo.person_id = p.person_id
                                        AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Cough" IS NOT NULL
  AND TRIM(r."Cough") IN ('Yes','No')

UNION ALL

-- 11) Expectoration
SELECT
    nextval('observation_id_seq'),
    p.person_id,
    4078502,  -- non standard                                                     -- Expectoration
    CAST(r."Date hospitalized...9" AS DATE),
    NULL::timestamp without time zone,
    32818,
    CASE WHEN TRIM(r."Expectoration") = 'Yes' THEN 4188539
         WHEN TRIM(r."Expectoration") = 'No'  THEN 4188540
         ELSE NULL END,
    1,
    vo.visit_occurrence_id,

    'Expectoration'
FROM respiratorydisease.respiratorydiseasedataset AS r
JOIN "DSWB_cdm".person           AS p  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence AS vo ON vo.person_id = p.person_id
                                        AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Expectoration" IS NOT NULL
  AND TRIM(r."Expectoration") IN ('Yes','No')

UNION ALL

-- 12) Hemoptysis(look like observation)
SELECT
    nextval('observation_id_seq'),
    p.person_id,
    261687,                                                       -- Hemoptysis
    CAST(r."Date hospitalized...9" AS DATE),
    NULL::timestamp without time zone,
    32818,
    CASE WHEN TRIM(r."Hemoptysis") = 'Yes' THEN 4188539
         WHEN TRIM(r."Hemoptysis") = 'No'  THEN 4188540
         ELSE NULL END,
    1,
    vo.visit_occurrence_id,
    'Hemoptysis'
FROM respiratorydisease.respiratorydiseasedataset AS r
JOIN "DSWB_cdm".person           AS p  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence AS vo ON vo.person_id = p.person_id
                                        AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Hemoptysis" IS NOT NULL
  AND TRIM(r."Hemoptysis") IN ('Yes','No')

UNION ALL

-- 13) Dyspnea (condition)
SELECT
    nextval('observation_id_seq'),
    p.person_id,
    312437,                                                       -- Dyspnea
    CAST(r."Date hospitalized...9" AS DATE),
    NULL::timestamp without time zone,
    32818,
    CASE WHEN TRIM(r."Dyspnea") = 'Yes' THEN 4188539
         WHEN TRIM(r."Dyspnea") = 'No'  THEN 4188540
         ELSE NULL END,
    1,
    vo.visit_occurrence_id,
    'Dyspnea'
FROM respiratorydisease.respiratorydiseasedataset AS r
JOIN "DSWB_cdm".person           AS p  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence AS vo ON vo.person_id = p.person_id
                                        AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Dyspnea" IS NOT NULL
  AND TRIM(r."Dyspnea") IN ('Yes','No')

UNION ALL

-- 14) Chest pain (condition)
SELECT
    nextval('observation_id_seq'),
    p.person_id,
    77670,                                                       -- Chest pain
    CAST(r."Date hospitalized...9" AS DATE),
    NULL::timestamp without time zone,
    32818,
    CASE WHEN TRIM(r."Chest pain") = 'Yes' THEN 4188539
         WHEN TRIM(r."Chest pain") = 'No'  THEN 4188540
         ELSE NULL END,
    1,
    vo.visit_occurrence_id,
    'Chest pain'
FROM respiratorydisease.respiratorydiseasedataset AS r
JOIN "DSWB_cdm".person           AS p  ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence AS vo ON vo.person_id = p.person_id
                                        AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Chest pain" IS NOT NULL
  AND TRIM(r."Chest pain") IN ('Yes','No')
;
