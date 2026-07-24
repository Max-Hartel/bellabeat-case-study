-- Creates an overview of basic informtion of the data and schema.

SELECT 
  table_name AS Tabelle, 
  column_name AS Spalte, 
  data_type AS Datentyp
FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name LIKE 'clean_%'
ORDER BY table_name, ordinal_position;

SELECT 
  COUNT(DISTINCT Id) AS anzahl_user,                  -- Amount of users
  MIN(ActivityDate) AS erster_tag,                    -- Start date of the data
  MAX(ActivityDate) AS letzter_tag,                   -- End date of the data
  COUNT(*) AS gesamt_zeilen,                          -- Scale of table
  ROUND(AVG(TotalSteps), 0) AS avg_schritte_pro_tag   -- AVG of steps
FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_dailyActivity`;