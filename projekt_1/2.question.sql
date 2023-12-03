-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
CREATE OR REPLACE VIEW v_karel_dvorak_second_question AS 
SELECT 
	date,
	floor(avg_wages/value) AS max_buy,
	price_unit,
	industry_name,
	value
FROM t_karel_dvorak_project_sql_primary_final tkdpspf 
WHERE foodstuffs IN ( 'Mléko polotučné pasterované', 'Chléb konzumní kmínový')
ORDER BY industry_name;

-- data za první a poslední srovnatelná období pro jednotlivé komodity zvlášť, mléko v litrech a chleba v kilogramech
SELECT 
	date,
	industry_name,
	max_buy,
	price_unit
FROM v_karel_dvorak_second_question vkdsq 
WHERE date IN (2006, 2018)
ORDER BY date, industry_name;

-- pohled pro první a poslední srovnatelné období pro nákup mléka a chleba dohromady(množství litrů mléka a množství kilogramů chleba)
CREATE OR REPLACE VIEW v_karel_dvorak_second_question_bonus AS 
SELECT 
	date,
	avg_wages,
	price_unit,
	industry_name,
	value
FROM t_karel_dvorak_project_sql_primary_final tkdpspf 
WHERE foodstuffs IN ( 'Mléko polotučné pasterované', 'Chléb konzumní kmínový')
ORDER BY industry_name;

-- data pro první a poslední srovnatelné období pro nákup mléka a chleba dohromady(množství litrů mléka a množství kilogramů chleba)
WITH base AS (
	SELECT 
		*,
		LAG(value) OVER (ORDER BY date, industry_name) AS lag_value
	FROM v_karel_dvorak_second_question_bonus vkdsqb
	WHERE date IN (2006,2018)
	ORDER BY date, industry_name, price_unit
), 
lagged AS (
	SELECT 
		date,
		industry_name,
		floor(avg_wages /(value + lag_value)) AS milch_bread,
		CASE 
			WHEN value = lag_value THEN 'incorrect'
			ELSE 'correct'
		END AS correct
	FROM base
	WHERE price_unit = 'l'
)
SELECT 
	date,
	industry_name,
	milch_bread,
	'l + kg' AS amount
FROM lagged
WHERE correct = 'correct'
;


