-- Cleans data from duplicates and nulls/missing values

SELECT 
  Id, 
  date, 
  COUNT(*) AS anzahl_eintraege
FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_minuteSleep`
GROUP BY Id, date
HAVING COUNT(*) > 1;


-- keine Dupliakte gefunden


SELECT 
  Id, 
  date, 
  COUNT(*) AS anzahl_eintraege
FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_minuteSleep`
GROUP BY Id, date
HAVING COUNT(*) > 1;



-- Duplikate gefunden
-- entferne Duplikate mit:

CREATE OR REPLACE VIEW `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_minuteSleep` AS 
SELECT DISTINCT * EXCEPT(date), PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', date) AS date 
FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.minuteSleep_merged`;


-- Suchen nach Null-Werten

SELECT * FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_dailyActivity`
WHERE Id IS NULL 
   OR ActivityDate IS NULL 
   OR TotalSteps IS NULL 
   OR Calories IS NULL;

-- keine Nullwerte gefunden

-- Prüfen von 0-Werten und Plasubilität (0 steps, aber x calories)

SELECT 
  Id, 
  ActivityDate, 
  TotalSteps, 
  Calories
FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_dailyActivity`
WHERE TotalSteps = 0
ORDER BY Calories DESC;

-- 50 0-Werte mit x calories gefunden
-- Um Zusammenhänge zwischen den Daten reliabel zu halten, werden die 0-Werte aus dem Arbeitssatz gelöscht (nicht den Rohdaten). Es gab zb. einen Eintrag mit 0 steps aber 4500 calories, was nicht plausibel ist.

CREATE OR REPLACE VIEW `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_dailyActivity` AS 
SELECT * FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.dailyActivity_merged`
WHERE TotalSteps > 0;

-- schauen, ob es Duplikate von ID'S gibt mit identischen Werten dahinter in allen weiteren 9 Tabellen. Hierfür zähle ich alle vorhanden Reihen und vergleiche sie mit durch CONCAT zusammengeführten ID

SELECT 'hourlyCalories' AS Tabelle, COUNT(*) AS Alle_Zeilen, COUNT(DISTINCT CONCAT(Id, ActivityHour)) AS Eindeutige_Zeilen FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_hourlyCalories`
UNION ALL
SELECT 'hourlyIntensities', COUNT(*), COUNT(DISTINCT CONCAT(Id, ActivityHour)) FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_hourlyIntensities`
UNION ALL
SELECT 'hourlySteps', COUNT(*), COUNT(DISTINCT CONCAT(Id, ActivityHour)) FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_hourlySteps`
UNION ALL
SELECT 'minuteCalories', COUNT(*), COUNT(DISTINCT CONCAT(Id, ActivityMinute)) FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_minuteCalories`
UNION ALL
SELECT 'minuteIntensities', COUNT(*), COUNT(DISTINCT CONCAT(Id, ActivityMinute)) FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_minuteIntensities`
UNION ALL
SELECT 'minuteMETs', COUNT(*), COUNT(DISTINCT CONCAT(Id, ActivityMinute)) FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_minuteMETs`
UNION ALL
SELECT 'minuteSteps', COUNT(*), COUNT(DISTINCT CONCAT(Id, ActivityMinute)) FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_minuteSteps`
UNION ALL
SELECT 'heartrate_seconds', COUNT(*), COUNT(DISTINCT CONCAT(Id, Time)) FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_heartrate_seconds`
UNION ALL
SELECT 'weightLogInfo', COUNT(*), COUNT(DISTINCT CONCAT(Id, Date)) FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_weightLogInfo`;