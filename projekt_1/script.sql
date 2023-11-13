
/*
 * Primární tabulky:
 * czechia_payroll – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
 * czechia_payroll_calculation – Číselník kalkulací v tabulce mezd.
 * czechia_payroll_industry_branch – Číselník odvětví v tabulce mezd.
 * czechia_payroll_unit – Číselník jednotek hodnot v tabulce mezd.
 * czechia_payroll_value_type – Číselník typů hodnot v tabulce mezd.
 * czechia_price – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
 * czechia_price_category – Číselník kategorií potravin, které se vyskytují v našem přehledu.
 */

-- value_type_code = průměrný počet zaměstnaných osob
-- value_type_code = 5958 je průměrná hrubá mzda na zaměstnance
-- unit_code = 200 Kč
-- unit_code = 
-- calculation code = 200 přepočtený na plné úvazky
SELECT
	*
FROM czechia_payroll cp
WHERE unit_code = 200
	AND industry_branch_code = 'F'
	AND calculation_code = 200
	AND payroll_year = 2018
ORDER BY payroll_year, payroll_quarter ;

SELECT *
FROM czechia_payroll_unit cpu;

SELECT *
FROM czechia_payroll_calculation cpc ;

SELECT *
FROM czechia_payroll_industry_branch cpib ;


SELECT *
FROM czechia_payroll_value_type cpvt;
