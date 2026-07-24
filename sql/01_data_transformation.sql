/*Data Import Challenge:
--The original Fitbit CSV files used the US format (MM/DD/YYYY HH:MM:SS AM/PM) for date and time columns. Importing them directly into Google BigQuery caused errors because the auto-detect feature could not natively interpret this format as TIMESTAMP or DATE. Additionally, certain column names (such as Calories in hourlyCalories) were incorrectly standardized to Value by the system. This standardizes timestamps across raw tables and creates cleaned views.
*/

-- 1. Daily Activity (Wird direkt übernommen, da Auto-Detect bereits geklappt hat)
CREATE OR REPLACE VIEW `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_dailyActivity` AS 
SELECT Id, ActivityDate, TotalSteps, TotalDistance, TrackerDistance, LoggedActivitiesDistance, VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance, SedentaryActiveDistance, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes, Calories 
FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.dailyActivity_merged`;

-- 2. Heartrate Seconds (Zeitstempel mit AM/PM)
CREATE OR REPLACE VIEW `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_heartrate_seconds` AS 
SELECT Id, PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', Time) AS Time, Value 
FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.heartrate_seconds_merged`;

-- 3. Hourly Calories (Zeitstempel mit AM/PM)
CREATE OR REPLACE VIEW `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_hourlyCalories` AS 
SELECT 
  Id, 
  PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', Time) AS ActivityHour, 
  Value AS Calories
FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.hourlyCalories_merged`;

-- 4. Hourly Intensities (Zeitstempel mit AM/PM)
CREATE OR REPLACE VIEW `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_hourlyIntensities` AS 
SELECT Id, PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', ActivityHour) AS ActivityHour, TotalIntensity, AverageIntensity 
FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.hourlyIntensities_merged`;

-- 5. Hourly Steps (Zeitstempel mit AM/PM)
CREATE OR REPLACE VIEW `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_hourlySteps` AS 
SELECT Id, PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', ActivityHour) AS ActivityHour, StepTotal 
FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.hourlySteps_merged`;

-- 6. Minute Calories (Zeitstempel mit AM/PM)
CREATE OR REPLACE VIEW `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_minuteCalories` AS 
SELECT Id, PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', ActivityMinute) AS ActivityMinute, Calories 
FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.minuteCaloriesNarrow_merged`;

-- 7. Minute Intensities (Zeitstempel mit AM/PM)
CREATE OR REPLACE VIEW `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_minuteIntensities` AS 
SELECT Id, PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', ActivityMinute) AS ActivityMinute, Intensity 
FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.minuteIntensitiesNarrow_merged`;

-- 8. Minute METs (Zeitstempel mit AM/PM)
CREATE OR REPLACE VIEW `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_minuteMETs` AS 
SELECT Id, PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', ActivityMinute) AS ActivityMinute, METs 
FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.minuteMETsNarrow_merged`;

-- 9. Minute Sleep (Zeitstempel mit AM/PM)
CREATE OR REPLACE VIEW `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_minuteSleep` AS 
SELECT Id, PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', date) AS date, value, logId 
FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.minuteSleep_merged`;

-- 10. Minute Steps (Zeitstempel mit AM/PM)
CREATE OR REPLACE VIEW `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_minuteSteps` AS 
SELECT Id, PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', ActivityMinute) AS ActivityMinute, Steps 
FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.minuteStepsNarrow_merged`;

-- 11. Weight Log Info (Zeitstempel mit AM/PM)
CREATE OR REPLACE VIEW `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.clean_weightLogInfo` AS 
SELECT Id, PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', Date) AS Date, WeightKg, WeightPounds, Fat, BMI, IsManualReport, LogId 
FROM `my-first-project-490515.CapStone_project_fitbit_fitness_tracker.weightLogInfo_merged`;