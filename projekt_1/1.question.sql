-- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?


-- vytvoření celkové pohledu na růst a pokles mezdy
CREATE OR REPLACE VIEW v_karel_dvorak_first_question AS
WITH base AS (
	SELECT 
		DISTINCT date,
		industry_name,
		avg_wages
	FROM t_karel_dvorak_project_sql_primary_final t
	ORDER BY industry_name, date
), 
lagged AS (
	SELECT
		date,
		industry_name,
		avg_wages,
		LAG(avg_wages) OVER (PARTITION BY industry_name ORDER BY date) AS lag_wages
	FROM base
)
SELECT 
	*,
	avg_wages - lag_wages AS diff,
	CASE	
		WHEN avg_wages - lag_wages >=1 THEN 'Rising'
		WHEN avg_wages - lag_wages < 1 tHEN 'Falling'
	END AS rising_falling
FROM lagged
; 

-- Mzdy klesají v těchto letech a odvětvých
SELECT *
FROM v_karel_dvorak_first_question vkdfq 
WHERE rising_falling = 'Falling'
;

-- Největší propady mezd
SELECT 
	date,
	industry_name,
	diff,
	rising_falling
FROM v_karel_dvorak_first_question vkdfq
WHERE rising_falling = 'Falling'
ORDER BY diff ASC
;

-- Nejhorší roky v poklesu mezd
SELECT 
	date,
	count(date) AS sum_date 
FROM v_karel_dvorak_first_question vkdfq
WHERE rising_falling = 'Falling'
GROUP BY date
ORDER BY count(date)DESC
;
