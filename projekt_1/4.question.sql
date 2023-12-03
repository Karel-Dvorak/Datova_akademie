-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

-- vytvoření pohledu s meziročními nárůsty a poklesy mezd a cen potravin
CREATE OR REPLACE VIEW v_karel_dvorak_four_question AS 
WITH base AS (
SELECT 
	date,
	round(avg(avg_wages))AS year_avg_wages,
	round(avg(value),2) AS year_avg_value
FROM t_karel_dvorak_project_sql_primary_final tkdpspf  
GROUP BY date
),
lagged AS (
	SELECT 
		date,
		year_avg_wages,
		LAG(year_avg_wages) OVER (ORDER BY date) AS lag_year_avg_wages,
		year_avg_value,
		LAG(year_avg_value) OVER (ORDER BY date) AS lag_year_avg_value
	FROM base
)
SELECT
	date,
	round(((year_avg_wages/lag_year_avg_wages)*100)-100,2) AS y_y_wages,
	round(((year_avg_value/lag_year_avg_value)*100)-100,2) AS y_y_value
FROM lagged
;

-- porovnávací tabulka
SELECT *
FROM v_karel_dvorak_four_question vkdfq 
;

