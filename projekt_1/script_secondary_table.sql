/* 
 * Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací 
 * dalších evropských států ve stejném období, jako primární přehled pro ČR.
 */

-- countries - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.
-- economies - HDP, GINI, daňová zátěž, atd. pro daný stát a rok.

-- t_{jmeno}_{prijmeni}_project_SQL_secondary_final (pro dodatečná data o dalších evropských státech).

CREATE OR REPLACE TABLE t_karel_dvorak_project_SQL_secondary_final
SELECT 
	country,
	`year`,
	GDP,
	gini,
	population
FROM economies e 
WHERE `year` BETWEEN 2006 AND 2018
	AND country IN (
		SELECT country
		FROM countries c
		WHERE continent = 'Europe'
	)
ORDER BY country, `year`;
