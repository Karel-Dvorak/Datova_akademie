-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
CREATE OR REPLACE VIEW v_karel_dvorak_third_question AS 
WITH base AS (
	SELECT
		DISTINCT date,
		foodstuffs,
		value
	FROM t_karel_dvorak_project_sql_primary_final tkdpspf
	ORDER BY foodstuffs 
),
	lagged AS (
	SELECT
		date,
		foodstuffs,
		value,
		LAG(value,1) OVER (PARTITION BY foodstuffs ORDER BY date) AS lag_value
	FROM base
)
SELECT
	*,
	round(((value/lag_value)*100)-100,2) AS y_y
FROM lagged
;

-- Počet let kdy bylo zdražení menší než 3%
WITH  base AS (
SELECT
	DISTINCT date,
	foodstuffs,
	y_y,
	CASE 
		WHEN y_y <= 3 THEN 'růst do 3%'
		WHEN y_y >= 3 AND y_y <= 10 THEN 'růst do 10%'
		ELSE 'jiné'
	END AS grow
FROM v_karel_dvorak_third_question vkdtq
)
SELECT
	foodstuffs,
	grow,
	count(grow)
FROM base
WHERE grow = 'růst do 3%'
GROUP BY foodstuffs
ORDER BY count(grow) DESC  
;

/*
 * top 5 nejpomaleji zdražujících potravin
 */
SELECT *
FROM v_karel_dvorak_third_question vkdtq 
WHERE foodstuffs = 'Banány žluté'
-- foodstuffs = 'Šunkový salám'
-- foodstuffs = 'Rýže loupaná dlouhozrnná'
-- foodstuffs = 'Cukr krystalový'
-- foodstuffs = 'Přírodní minerální voda uhličitá'
