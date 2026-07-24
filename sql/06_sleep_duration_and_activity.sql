WITH daily_records AS (
    -- Wir betrachten jeden Tag EINZELN (kein Nutzer-Durchschnitt!)
    SELECT 
        a.Id,
        a.ActivityDate,
        
        -- Aktivität an genau DEM Tag
        CASE 
            WHEN a.VeryActiveMinutes >= 20 THEN 'Very Active Day'
            WHEN a.FairlyActiveMinutes >= 15 OR a.LightlyActiveMinutes >= 220 THEN 'Fairly Active Day'
            WHEN a.LightlyActiveMinutes >= 140 THEN 'Lightly Active Day'
            ELSE 'Sedentary Day'
        END AS day_activity_type,
        
        -- Schlafqualität an genau DEM Tag
        COUNTIF(s.value > 1) AS minutes_awake_that_night
    FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_dailyActivity` a
    INNER JOIN `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_minuteSleep` s
       ON CAST(a.Id AS STRING) = CAST(s.Id AS STRING)
      AND CAST(a.ActivityDate AS DATE) = CAST(TIMESTAMP(s.date) AS DATE)
    GROUP BY a.Id, a.ActivityDate, a.VeryActiveMinutes, a.FairlyActiveMinutes, a.LightlyActiveMinutes
)

SELECT 
    day_activity_type,
    ROUND(100.0 * COUNTIF(minutes_awake_that_night < 20) / COUNT(*), 1) AS pct_unterbrechungsfrei,
    ROUND(100.0 * COUNTIF(minutes_awake_that_night BETWEEN 20 AND 60) / COUNT(*), 1) AS pct_unruhig,
    ROUND(100.0 * COUNTIF(minutes_awake_that_night > 60) / COUNT(*), 1) AS pct_sehr_unruhig,
    COUNT(*) AS total_days_recorded -- Zeigt jetzt Tage an, nicht Nutzer!
FROM daily_records
GROUP BY day_activity_type;