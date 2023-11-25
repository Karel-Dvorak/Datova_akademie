-- WINDOWS FUNCTION


WITH dates AS (
	SELECT DISTINCT 
		date
	FROM covid19_basic_differences cbd 
),
lagged AS (
	SELECT
		date,
		LAG(date) OVER (ORDER BY date) AS lage_date
		FROM dates
),
diffed AS (
	SELECT 
		date,
		lage_date,
		DATEDIFF(date, lage_date) AS diff 
	FROM lagged
)
SELECT
*
FROM diffed

WHERE diff > 1





