SET search_path TO "DSWB_cdm";

TRUNCATE TABLE cdm_source;

INSERT INTO cdm_source (
  cdm_source_name,
  cdm_source_abbreviation,
  cdm_holder,
  source_description,
  source_documentation_reference,
  cdm_etl_reference,
  source_release_date,
  cdm_release_date,
  cdm_version,
  cdm_version_concept_id,
  vocabulary_version
) VALUES (
  'Douala General Hospital CDM',
  'DGH',
  'Data Science Without Borders',
  'This CDM instance contains respiratory and general hospital data from Douala General Hospital.',
  'https://github.com/aphrc-dswb/Douala-General-Hospital-DSWB/tree/main/omop-etl-respiratory',
  'OMOP ETL using R and SQL',
  CURRENT_DATE,
  CURRENT_DATE,
  '5.4',
  756265,
  to_char(CURRENT_DATE, 'YYYYMMDD')
);
