
-- 3. LEKCE --

SELECT *
FROM czechia_payroll cp;
/*
 * Úkol 1: Spočítejte počet řádků v tabulce czechia_price.
 */

SELECT count(1)
FROM czechia_price cp; 

/*
 * Úkol 2: Spočítejte počet řádků v tabulce czechia_payroll s konkrétním sloupcem jako argumentem funkce COUNT().
 */

SELECT 
	count(id) AS row_count
FROM czechia_payroll cp; 

-- vs. nesprávné řešení se sloupcem, který má v hodnotách NULL

SELECT COUNT(value) AS rows_count
FROM czechia_payroll;

/*
 * Úkol 3: Z kolika záznamů v tabulce czechia_payroll jsme schopni vyvodit průměrné počty zaměstnanců?
 */

SELECT count(id) AS rows_of_known_employees 
FROM czechia_payroll cp
WHERE   
    value_type_code = 316 AND 
    value IS NOT NULL;

/*
 * Úkol 4: Vypište všechny cenové kategorie a počet řádků každé z nich v tabulce czechia_price.
 */

SELECT 
	category_code,
	count(id) AS rows_in_category 
FROM czechia_price cp2 
GROUP BY category_code ;

/*
 * Úkol 5: Rozšiřte předchozí dotaz o dodatečné rozdělení dle let měření.
 */

SELECT 
	category_code,
	YEAR(date_from) AS year_of_entry,
	count(id) AS rows_in_category 
FROM czechia_price cp2 
GROUP BY category_code, year_of_entry
ORDER BY year_of_entry, category_code;


-- Funkce SUM()

/*
 * Úkol 1: Sečtěte všechny průměrné počty zaměstnanců v datové sadě průměrných platů v České republice.
 */

SELECT 
	sum(value_type_code) AS rows_sum_employees
FROM czechia_payroll cp
WHERE value_type_code = 316;

/*
 * Úkol 2: Sečtěte průměrné ceny pro jednotlivé kategorie pouze v Jihomoravském kraji.
 */

SELECT
	category_code,
	sum(value) AS rows_sum_midle
FROM czechia_price cp2
WHERE region_code IN (
	SELECT code
	FROM czechia_region cr
	WHERE name = 'Jihomoravský kraj'
	)
GROUP BY category_code ;

SELECT
    category_code,
    SUM(value) AS sum_of_average_prices
FROM czechia_price
WHERE region_code = 'CZ064'
GROUP BY category_code;
/*
 * Úkol 3: Sečtěte průměrné ceny potravin za všechny kategorie, u kterých měření probíhalo od (date_from) 15. 1. 2018.
 */

SELECT
	sum(value) AS rows_sum_midle
FROM czechia_price cp2
WHERE date_from = '2018-01-15';
-- přetypování

SELECT
	sum(value) AS rows_sum_midle
FROM czechia_price cp2
WHERE date_from = CAST('2018-01-15' AS date);

/*
 * Úkol 4: Vypište tři sloupce z tabulky czechia_price: kód kategorie, počet řádků pro ni a sumu hodnot průměrných cen. 
 * To vše pouze pro data v roce 2018.
 */

SELECT 
	category_code,
	count(1) AS row_count,
	sum(value) AS sum_of_average_prices
FROM czechia_price cp 
WHERE YEAR(date_from) = 2018
GROUP BY category_code ;

-- Proč je pro kapra jenom 15 řádků?

SELECT * FROM czechia_price_category;

SELECT DISTINCT MONTH(date_from)
FROM czechia_price
WHERE
    category_code = 2000001 AND
    YEAR(date_from) = 2018;
   
SELECT DISTINCT MONTH(date_from)
FROM czechia_price
WHERE
    category_code = 111101 AND
    YEAR(date_from) = 2018;

-- Další agregační funkce
   
/*
 * Úkol 1: Vypište maximální hodnotu průměrné mzdy z tabulky czechia_payroll.
 */

SELECT *
FROM czechia_payroll_value_type cpvt ;

SELECT 
	max(value)
FROM czechia_payroll cp 
WHERE value_type_code = 5958;

/*
 * Úkol 2: Na základě údajů v tabulce czechia_price vyberte pro každou kategorii potravin její minimum v letech 2015 až 2017.
 */

SELECT 
	category_code, 
	min(value)
FROM czechia_price cp
WHERE YEAR(date_from) BETWEEN 2015 AND 2017
GROUP BY category_code;

/*
 * Úkol 3: Vypište kód (případně i název) odvětví s historicky nejvyšší průměrnou mzdou.
 */

SELECT 
	industry_branch_code 
FROM czechia_payroll cp 
WHERE value IN (
	SELECT 
	max(value)
	FROM czechia_payroll cp2 
	WHERE value_type_code = 5958);

-- i název odvětví
SELECT
    *
FROM czechia_payroll_industry_branch
WHERE code IN (
    SELECT
        industry_branch_code
    FROM czechia_payroll
    WHERE value IN (
        SELECT
            MAX(value)
        FROM czechia_payroll
        WHERE value_type_code = 5958
    )
);

/*
 * Úkol 4: Pro každou kategorii potravin určete její minimum, maximum a vytvořte nový sloupec s názvem difference,
 *  ve kterém budou hodnoty "rozdíl do 10 Kč", "rozdíl do 40 Kč" a "rozdíl nad 40 Kč" na základě rozdílu minima a maxima.
 *  Podle tohoto rozdílu data seřaďte.
 */

SELECT
    category_code,
    MIN(value),
    MAX(value),
    CASE
        WHEN MAX(value) - MIN(value) < 10 THEN 'rozdíl do 10 Kč'
        WHEN MAX(value) - MIN(value) < 40 THEN 'rozdíl do 40 Kč'
        ELSE 'rozdíl nad 40 Kč'
    END AS difference
FROM czechia_price
GROUP BY category_code
ORDER BY difference;

-- korektněší řazení:

SELECT 
	category_code,
	min(value),
	max(value),
	CASE 
		WHEN MAX(value) - MIN(value) < 10 THEN 'rozdíl do 10 Kč'
        WHEN MAX(value) - MIN(value) < 40 THEN 'rozdíl do 40 Kč'
        ELSE 'rozdíl nad 40 Kč'
	END AS difference
FROM czechia_price cp 
GROUP BY category_code 
ORDER BY max(value) - min(value);

/*
 * Úkol 5: Vyberte pro každou kategorii potravin minimum, maximum a aritmetický průměr 
 * (v našem případě průměr z průměrů) zaokrouhlený na dvě desetinná místa.
 */

SELECT category_code,
	min(value) AS historical_minimum,
	max(value) AS historial_maximum,
	round(avg(value),2) AS average 
FROM czechia_price cp
GROUP BY category_code;

/*
 * Úkol 6: Rozšiřte předchozí dotaz tak, že data budou rozdělena i podle kódu kraje
 *  a seřazena sestupně podle aritmetického průměru.
 */
SELECT *
FROM czechia_price cp; 

SELECT category_code,
	region_code,
	min(value) AS historical_minimum,
	max(value) AS historial_maximum,
	round(avg(value),2) AS average 
FROM czechia_price cp
GROUP BY category_code, region_code 
ORDER BY average DESC;

/*
 *      Další operace v klauzuli SELECT
 */

-- Úkol 1: Vyzkoušejte si následující dotazy. Co vypisují a proč?

SELECT SQRT(-16); 		-- odmocina
SELECT 10/0;			-- dělění nulou
SELECT FLOOR(1.56);		-- zaokrouhlední dolů
SELECT FLOOR(-1.56);	-- zaokrouhlední dolů
SELECT CEIL(1.56);		-- zaokrouhlední nahoru
SELECT CEIL(-1.56);		-- zaokrouhlední nahoru
SELECT ROUND(1.56);		-- zaokrouhlení na desetinná místa(defaloutně na 0)
SELECT ROUND(-1.56);	-- zaokrouhlení na desetinná místa(defaloutně na 0)

/*
 * Úkol 2: Vypočítejte průměrné ceny kategorií potravin bez použití funkce AVG() s přesností na dvě desetinná místa.
 */

SELECT category_code,
	round(avg(value),2) AS avg_average, -- kontrolní řádek
	round(sum(value)/count(value),2) AS average 
FROM czechia_price cp 
GROUP BY category_code;

/*
 * Úkol 3: Jaké datové typy budou mít hodnoty v následujících dotazech? 
 */

SELECT 1;				-- Integer
SELECT 1.0;				-- Decimal
SELECT 1 + 1;			-- Integer
SELECT 1 + 1.0;			-- Decimal
SELECT 1 + '1';			-- Double
SELECT 1 + 'a';			-- chyba, nelze Double
SELECT 1 + '12tatata';	-- Double (pokud obsahuje číslo, tak si ho vytáhne)

/*
 * Úkol 4: Vyzkoušejte si spustit dotazy, jež operují s textovými řetězci.
 */

SELECT CONCAT('Hi, ', 'Engeto lektor here!');

SELECT CONCAT('We have ', COUNT(DISTINCT category_code), ' price categories.') AS info
FROM czechia_price;

SELECT name,
    SUBSTRING(name, 1, 2) AS prefix,
    SUBSTRING(name, -2, 2) AS suffix,
    LENGTH(name)
FROM czechia_price_category;

/*
 * Úkol 5: Vyzkoušejte si operátor modulo (zbytek po celočíselném dělení).
 */






SELECT date_from,
	year(date_from),
	month(date_from),
	dayofweek(date_from), 
	weekday(date_from),
	monthname(date_from) 
FROM czechia_price ;

SELECT *
FROM t_karel_dvorak_project_sql_secondary_final tkdpssf 