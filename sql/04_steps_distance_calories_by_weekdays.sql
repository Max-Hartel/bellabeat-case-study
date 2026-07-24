--Steps, distance and calories sorted by weekdays

SELECT 
  FORMAT_DATE('%A', ActivityDate) AS wochentag,
  EXTRACT(DAYOFWEEK FROM ActivityDate) AS wochentag_num,
  ROUND(AVG(TotalDistance), 2) AS avg_distanz_km,
  ROUND(AVG(TotalSteps), 0) AS avg_schritte,
  ROUND(AVG(Calories), 0) AS avg_kalorien
FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_dailyActivity`
GROUP BY wochentag, wochentag_num
ORDER BY wochentag_num;