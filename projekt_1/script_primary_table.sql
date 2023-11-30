/*
 * Potřebují k tomu od vás připravit robustní datové podklady, ve kterých bude 
 * možné vidět porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období.
 * 
 * czechia_payroll – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
 * czechia_payroll_calculation – Číselník kalkulací v tabulce mezd.
 * czechia_payroll_industry_branch – Číselník odvětví v tabulce mezd.
 * czechia_payroll_unit – Číselník jednotek hodnot v tabulce mezd.
 * czechia_payroll_value_type – Číselník typů hodnot v tabulce mezd.
 * czechia_price – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
 * czechia_price_category – Číselník kategorií potravin, které se vyskytují v našem přehledu.
 * 
 * t_{jmeno}_{prijmeni}_project_SQL_primary_final (pro data mezd a cen potravin za Českou republiku 
 * sjednocených na totožné porovnatelné období – společné roky)
*/

CREATE OR REPLACE TABLE t_karel_dvorak_project_SQL_primary_final
SELECT 
	base.`year`,
	base.industry_name,
	base.avg_wages,
	a.foodstuffs,
	a.value,
	a.price_value,
	a.price_unit
FROM ( 
	SELECT
		cpay.payroll_year AS `year`,
		cpib2.name AS industry_name,
		round(avg(cpay.value)) AS avg_wages
	FROM czechia_payroll cpay
	JOIN czechia_payroll_industry_branch cpib2 
		ON cpib2.code = cpay.industry_branch_code
	WHERE cpay.unit_code = 200
		AND cpay.calculation_code = 200
		AND cpay.value_type_code = 5958
		AND cpay.industry_branch_code IS NOT NULL
	GROUP BY cpay.payroll_year, cpay.industry_branch_code  
	HAVING `year` BETWEEN 2006 AND 2018
	) base
LEFT JOIN 
	(
	SELECT 
		year(cp.date_from) AS `year`,
		cpc.name AS foodstuffs,
		round(avg(cp.value),2) AS value,
		cpc.price_value AS price_value,
		cpc.price_unit AS price_unit
	FROM czechia_price cp
	JOIN czechia_price_category cpc 
		ON cp.category_code = cpc.code 
	GROUP BY cp.category_code, year(cp.date_from) 
	) a
ON base.`year` = a.`year`
;
