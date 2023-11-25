
-- Spojování tabulek pomocí JOIN

/*
 * Úkol 1: Spojte tabulky czechia_price a czechia_price_category. Vypište všechny dostupné sloupce.
 */

SELECT *
FROM czechia_price cp 
JOIN czechia_price_category cpc 
	ON cpc.code = cp.category_code; 

-- INNER se u JOIN nepoužívá
-- používat aliasy je velice doporučováno

/*
 * Úkol 2: Předchozí příklad upravte tak, že vhodně přejmenujete tabulky a vypíšete ID a jméno kategorie potravin a cenu.
 */

SELECT
	cp.id,
	cpc.name,
	cp.value 
FROM czechia_price cp 
JOIN czechia_price_category cpc 
	ON cpc.code = cp.category_code;

/*
 * Úkol 3: Přidejte k tabulce cen potravin i informaci o krajích ČR a vypište informace o cenách společně s názvem kraje.
 */

SELECT
	cp.*,
	cr.name 
FROM czechia_price cp 
LEFT JOIN czechia_region cr 
	ON cp.region_code = cr.code;

-- Rozdíl v počtech řádků levého a vnitřního spojení:

SELECT COUNT(1) total_number_of_rows
FROM czechia_price cp
LEFT JOIN czechia_region cr
    ON cp.region_code = cr.code;

SELECT COUNT(1) total_number_of_rows
FROM czechia_price cp
INNER JOIN czechia_region cr
    ON cp.region_code = cr.code;

/*
 * Úkol 4: Využijte v příkladě z předchozího úkolu RIGHT JOIN s výměnou pořadí tabulek. Jak se změní výsledky?
 */

SELECT
	cp.*,
	cr.name 
FROM czechia_region cr 
RIGHT JOIN czechia_price cp 
	ON cp.region_code = cr.code;

-- Výsledný výpis se nějak nezmění. Dotazy jsou ekvivalentní.

/*
 * Úkol 5: K tabulce czechia_payroll připojte všechny okolní tabulky. Využijte ERD model ke zjištění, které to jsou.
 */

SELECT 
	*
FROM czechia_payroll cp 
JOIN czechia_payroll_calculation cpc 
	ON cpc.code = cp.calculation_code 
JOIN czechia_payroll_industry_branch cpib 
	ON cpib.code = cp.industry_branch_code 
JOIN czechia_payroll_unit cpu 
	ON cpu.code = cp.unit_code 
JOIN czechia_payroll_value_type cpvt 
	ON cpvt.code = cp.value_type_code;

-- přetáhnout si ER Diagram vedle okna s kodem






