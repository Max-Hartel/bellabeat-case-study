-- Aggregating mean sleep and activity by user

WITH daily_sleep_aggregated AS (
    -- 1. Minutengenaue Schlafdaten aggregieren
    SELECT 
        CAST(Id AS STRING) AS Id,
        CAST(TIMESTAMP(date) AS DATE) AS sleep_date,
        COUNTIF(value > 1) AS total_minutes_awake
    FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_minuteSleep`
    GROUP BY Id, sleep_date
),

joined_data AS (
    -- 2. Verknüpfung mit den Aktivitätsdaten
    SELECT 
        CAST(a.Id AS STRING) AS Id,
        a.SedentaryMinutes,
        a.LightlyActiveMinutes,
        a.FairlyActiveMinutes,
        a.VeryActiveMinutes,
        s.total_minutes_awake
    FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_dailyActivity` a
    INNER JOIN daily_sleep_aggregated s
       ON CAST(a.Id AS STRING) = s.Id
      AND CAST(a.ActivityDate AS DATE) = s.sleep_date
),

user_metrics AS (
    -- 3. Durchschnitte pro Nutzer berechnen
    SELECT 
        Id,
        AVG(SedentaryMinutes) AS avg_sedentary,
        AVG(LightlyActiveMinutes) AS avg_lightly,
        AVG(FairlyActiveMinutes) AS avg_fairly,
        AVG(VeryActiveMinutes) AS avg_very,
        AVG(total_minutes_awake) AS avg_time_awake
    FROM joined_data
    GROUP BY Id
),

user_categorized AS (
    -- 4. Kaskadierende Kategorisierung für exakt alle 24 User
    SELECT 
        Id,
        CASE 
            WHEN avg_very >= 20 THEN 'Very Active'
            WHEN avg_fairly >= 15 OR avg_lightly >= 220 THEN 'Fairly Active'
            WHEN avg_lightly >= 140 THEN 'Lightly Active'
            ELSE 'Sedentary'
        END AS user_type,
        
        -- Deine verbesserte Schlafqualitäts-Kategorie
        CASE 
            WHEN avg_time_awake < 20 THEN 'Unterbrechungsfrei'
            WHEN avg_time_awake BETWEEN 20 AND 60 THEN 'Unruhiger Schlaf'
            WHEN avg_time_awake > 60 THEN 'Sehr unruhig'
            ELSE 'Unbekannt'
        END AS sleep_type
    FROM user_metrics
)

-- 5. Auswertung aller 4 Gruppen
SELECT 
    user_type,
    ROUND(100.0 * COUNTIF(sleep_type = 'Unterbrechungsfrei') / COUNT(*), 1) AS pct_unterbrechungsfrei,
    ROUND(100.0 * COUNTIF(sleep_type = 'Unruhiger Schlaf') / COUNT(*), 1) AS pct_unruhig,
    ROUND(100.0 * COUNTIF(sleep_type = 'Sehr unruhig') / COUNT(*), 1) AS pct_sehr_unruhig,
    COUNT(*) AS total_users_in_group
FROM user_categorized
GROUP BY user_type
ORDER BY 
    CASE user_type
        WHEN 'Sedentary' THEN 1
        WHEN 'Lightly Active' THEN 2
        WHEN 'Fairly Active' THEN 3
        WHEN 'Very Active' THEN 4
    END;