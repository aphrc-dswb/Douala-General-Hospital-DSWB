SET search_path TO "DSWB_cdm";
TRUNCATE TABLE "DSWB_cdm".condition_occurrence RESTART IDENTITY CASCADE;
ALTER SEQUENCE "DSWB_cdm".condition_occurrence_id_seq RESTART WITH 1;
-- (1) S'assurer que la séquence existe
CREATE SEQUENCE IF NOT EXISTS condition_occurrence_id_seq;

-- (2) Insertion des diagnostics principaux
INSERT INTO condition_occurrence (
    condition_occurrence_id,
    person_id,
    condition_concept_id,
    condition_start_date,
    condition_start_datetime,
    condition_end_date,
    condition_end_datetime,
    condition_type_concept_id,         -- 32817 = EHR diagnostic
    condition_status_concept_id,
    stop_reason,
    provider_id,
    visit_occurrence_id,
    visit_detail_id,
    condition_source_value,
    condition_source_concept_id,
    condition_status_source_value
)
SELECT
    nextval('condition_occurrence_id_seq'),
    p.person_id,
    CASE LOWER(TRIM(r."name of final diagnosis"))
        WHEN 'cancer' THEN 4194405
        WHEN 'pulmonary embolism' THEN 440417
        WHEN 'pneumonia' THEN 255848
        WHEN 'tuberculosis' THEN 434557
        WHEN 'asthma' THEN 317009
        WHEN 'bronchitis' THEN 256451
        WHEN 'kaposi' THEN 434584
        WHEN 'copd' THEN 255573
        WHEN 'sepsis' THEN 132797
        ELSE NULL
    END,
    CAST(r."Date hospitalized...9" AS DATE),
    NULL,
    COALESCE(CAST(r."Release date...10" AS DATE), CAST(r."Date hospitalized...9" AS DATE)),
    NULL,
    32817,
    NULL,
    NULL,
    1,
    vo.visit_occurrence_id,
    NULL,
    LEFT(r."name of final diagnosis", 50),
    NULL,
    NULL
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p ON r."unique_code" = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo ON vo.person_id = p.person_id
    AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."name of final diagnosis" IS NOT NULL
  AND LOWER(TRIM(r."name of final diagnosis")) IN (
    'cancer', 'pulmonary embolism', 'pneumonia', 'tuberculosis',
    'asthma', 'bronchitis', 'kaposi', 'copd', 'sepsis'
);

-- (3) Insertion des diagnostics secondaires
INSERT INTO condition_occurrence (
    condition_occurrence_id,
    person_id,
    condition_concept_id,
    condition_start_date,
    condition_start_datetime,
    condition_end_date,
    condition_end_datetime,
    condition_type_concept_id,
    condition_status_concept_id,
    stop_reason,
    provider_id,
    visit_occurrence_id,
    visit_detail_id,
    condition_source_value,
    condition_source_concept_id,
    condition_status_source_value
)
SELECT
    nextval('condition_occurrence_id_seq'),
    p.person_id,
    CASE LOWER(TRIM(r."Name of final diagnosis 2"))
        WHEN 'bone tuberculosis' THEN 80626
        WHEN 'pulmonary embolism' THEN 440417
        WHEN 'acute community-acquired pneumonia' THEN 4293463
        WHEN 'asthma' THEN 317009
        WHEN 'acute bronchitis' THEN 260139
        WHEN 'pulmonary tuberculosis' THEN 253954
        WHEN 'pneumothorax' THEN 253796
        WHEN 'pleural tuberculosis' THEN 253954
        WHEN 'chronic cor pulmonale' THEN 432586
        WHEN 'purulent pleurisy' THEN 4318553
        WHEN 'hemopneumothorax' THEN 432961
        WHEN 'pulmonary kaposi' THEN 433740
        WHEN 'copd' THEN 255573
        WHEN 'pleuropulmonary kaposi' THEN 433740
        WHEN 'pleuropulmonary tuberculosis' THEN 253954
        WHEN 'lymphoma' THEN 443392
        WHEN 'sequelae of tuberculosis' THEN 4090205
        WHEN 'diffuse intestinal pneumonia' THEN 4058243
        WHEN 'chylous pleurisy' THEN 78786
        WHEN 'aspergillus graft' THEN 4085138
        WHEN 'bronchiectasis' THEN 256449
        WHEN 'hemothorax' THEN 4135466
        WHEN 'aspiration pneumonia' THEN 4309106
        WHEN 'pneumocystosis' THEN 438350
        WHEN 'lung abscess' THEN 4024110
        WHEN 'chronic respiratory failure' THEN 314971
        WHEN 'htap' THEN 192680
        WHEN 'diffuse interstitial pneumonia' THEN 4273378
        WHEN 'mediastinal tuberculosis' THEN 4219077
        WHEN 'peritoneal tuberculosis' THEN 4112387
        WHEN 'infectious pleurisy' THEN 4198126
        WHEN 'pulmonary fibrosis' THEN 4120272
        WHEN 'nosocomial pneumonia' THEN 4143092
        WHEN 'pleuropulmonary metastasis' THEN 45769094
        WHEN 'multi-tuberculosis immune reconstitution syndrome' THEN 4139034
        WHEN 'bifocal tuberculosis immune reconstitution syndrome' THEN 4139034
        WHEN 'febrile gastroenteritis' THEN 4167082
        WHEN 'tuberculous pyopneumothorax' THEN 4141120
        WHEN 'neuromeningeal tuberculosis' THEN 4112387
        WHEN 'abdominal tuberculosis' THEN 4112387
        WHEN 'tuberculous pericarditis' THEN 4108799
        WHEN 'lymph node tuberculosis' THEN 4219077
        WHEN 'osteovertebral tuberculosis' THEN 4112387
        WHEN 'chronic bronchitis' THEN 255841
        WHEN 'tuberculous meningitis' THEN 441775
        WHEN 'pleurisy' THEN 4198126
        WHEN 'sleep apnea syndrome' THEN 313459
        WHEN 'hemoptysis' THEN 261687
        WHEN 'inhalation pneumonia' THEN 4153356
        WHEN 'cavum tumor' THEN 4263515
        WHEN 'tuberculosis' THEN 434557
        WHEN 'pleural endometriosis' THEN 36713394
        WHEN 'pleural tuberculosis' THEN 261495
        WHEN 'inflammatory pleurisy' THEN 4198126
        WHEN 'pleuropnaumopathy to be investigated' THEN 4252581
        WHEN 'pulmonary + lymph node tuberculosis' THEN 4219077
        WHEN 'covid-19' THEN 37311061
        WHEN 'post covid' THEN 37311061
        ELSE NULL
    END,
    CAST(r."Date hospitalized...9" AS DATE),
    NULL,
    COALESCE(CAST(r."Release date...10" AS DATE), CAST(r."Date hospitalized...9" AS DATE)),
    NULL,
    32817,
    NULL,
    NULL,
    1,
    vo.visit_occurrence_id,
    NULL,
    LEFT(r."Name of final diagnosis 2", 50),
    NULL,
    NULL
FROM respiratorydisease.respiratorydiseasedataset r
JOIN "DSWB_cdm".person p ON r.unique_code = p.person_source_value
JOIN "DSWB_cdm".visit_occurrence vo ON vo.person_id = p.person_id
    AND vo.visit_start_date = CAST(r."Date hospitalized...9" AS DATE)
WHERE r."Name of final diagnosis 2" IS NOT NULL
  AND LOWER(TRIM(r."Name of final diagnosis 2")) IN (
    'bone tuberculosis', 'pulmonary embolism', 'acute community-acquired pneumonia',
    'asthma', 'acute bronchitis', 'pulmonary tuberculosis', 'pneumothorax',
    'pleural tuberculosis', 'chronic cor pulmonale', 'purulent pleurisy',
    'hemopneumothorax', 'pulmonary kaposi', 'copd', 'pleuropulmonary kaposi',
    'pleuropulmonary tuberculosis', 'lymphoma', 'sequelae of tuberculosis',
    'diffuse intestinal pneumonia', 'chylous pleurisy', 'aspergillus graft',
    'bronchiectasis', 'hemothorax', 'aspiration pneumonia', 'pneumocystosis',
    'lung abscess', 'chronic respiratory failure', 'htap', 'diffuse interstitial pneumonia',
    'mediastinal tuberculosis', 'peritoneal tuberculosis', 'infectious pleurisy',
    'pulmonary fibrosis', 'nosocomial pneumonia', 'pleuropulmonary metastasis',
    'multi-tuberculosis immune reconstitution syndrome',
    'bifocal tuberculosis immune reconstitution syndrome', 'febrile gastroenteritis',
    'tuberculous pyopneumothorax', 'neuromeningeal tuberculosis', 'abdominal tuberculosis',
    'tuberculous pericarditis', 'lymph node tuberculosis', 'osteovertebral tuberculosis',
    'chronic bronchitis', 'tuberculous meningitis', 'pleurisy', 'sleep apnea syndrome',
    'hemoptysis', 'inhalation pneumonia', 'cavum tumor', 'tuberculosis',
    'pleural endometriosis', 'pleural tuberculosis', 'inflammatory pleurisy',
    'pleuropnaumopathy to be investigated', 'pulmonary + lymph node tuberculosis',
    'covid-19', 'post covid'
);

UPDATE condition_occurrence
SET condition_end_date = condition_start_date
WHERE condition_end_date IS NOT NULL
  AND condition_end_date < condition_start_date;

