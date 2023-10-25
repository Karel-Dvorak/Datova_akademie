
-- BONUSOVÁ CVIČENÍ --

/*
 * BONUSOVÁ CVIČENÍ
	COVID-19: SELECT, ORDER BY a LIMIT

	Úkol 1: Ukažte všechny záznamy z tabulky covid19_basic.
*/

SELECT *
FROM covid19_basic cb; 

-- Úkol 2: Ukažte jen prvních 20 záznamů z tabulky covid19_basic.

SELECT *
FROM covid19_basic cb
LIMIT 20;

-- Úkol 3: Seřaďte celou tabulku covid19_basic vzestupně podle sloupce date.

SELECT *
FROM covid19_basic cb
ORDER BY date;
-- default nastave vzestupně (ASC)

-- Úkol 4: Seřaďte celou tabulku covid19_basic sestupně podle sloupce date.

SELECT *
FROM covid19_basic cb
ORDER BY date DESC;

-- Úkol 5: Vyberte jen sloupec country z tabulky covid19_basic.

SELECT 
	country
FROM covid19_basic cb; 

-- Úkol 6: Vyberte jen sloupce country a date z tabulky covid19_basic.

SELECT 
	date,
	country
FROM covid19_basic cb 

--    ÚKOLY NA WHERE    --

-- Úkol 1: Vyberte z tabulky covid19_basic jen záznamy s Rakouskem (Austria).

SELECT *
FROM covid19_basic cb 
WHERE country = 'Austria';

-- Úkol 2: Vyberte jen sloupce country, date a confirmed pro Rakousko z tabulky covid19_basic.

SELECT 
	date,
	country,
	confirmed 
FROM covid19_basic cb
WHERE country = 'Austria';

-- Úkol 3: Vyberte všechny sloupce k datu 30. 8. 2020 z tabulky covid19_basic.

SELECT *
FROM covid19_basic cb 
WHERE date <= '2020-08-30';
-- ORDER BY date DESC; pro ověření

-- Úkol 4: Vyberte všechny sloupce k datu 30. 8. 2020 v České republice z tabulky covid19_basic.

SELECT 
	country
FROM covid19_basic cb;
-- Czechia

SELECT *
FROM covid19_basic cb 
WHERE date = '2020-08-30' 
 AND country = 'Czechia';

-- Úkol 5: Vyberte všechny sloupce pro Českou republiku a Rakousko z tabulky covid19_basic.

SELECT *
FROM covid19_basic cb 
WHERE country = 'Czechia'
	OR country = 'Austria';

-- Úkol 6: Vyberte všechny sloupce z covid19_basic, kde počet nakažených je roven 1 000, nebo 100 000.

SELECT 
	*
FROM covid19_basic cb
WHERE confirmed = '1000' 
	OR confirmed = '100000';

-- Úkol 7: Vyberte všechny sloupce z tabulky covid19_basic, ve kterých je počet nakažených mezi 10 a 20 a navíc pouze v den 30. 8. 2020.

SELECT *
FROM covid19_basic cb 
WHERE confirmed >= 10
	AND confirmed <= 20
	AND date = '2020-08-30';
-- symbol menší nebo větší se píše VŽDY před rovnítko (<=, >=)

-- Úkol 8: Vyberte všechny sloupce z covid19_basic, u kterých je počet nakažených větší než jeden milion dne 15. 8. 2020.

SELECT *
FROM covid19_basic cb 
WHERE confirmed > 1000000
	AND date = '2020-08-15';

-- Úkol 9: Vyberte sloupce date, country a confirmed v Anglii a Francii z tabulky covid19_basic a seřaďte je sestupně podle data.
-- France, United Kingdom

SELECT 
	date,
	country,
	confirmed 
FROM covid19_basic cb 
WHERE country = 'France'
	OR country = 'United Kingdom'
ORDER BY date DESC;

-- Úkol 10: Vyberte z tabuky covid19_basic_differences přírůstky nakažených v České republice v září 2020.

SELECT
	confirmed 
FROM covid19_basic_differences cbd
WHERE country = 'Czechia'
	AND date >= '2020-09-01'
	AND date <= '2020-09-30';

-- Úkol 11: Z tabulky lookup_table zjistěte počet obyvatel Rakouska.
/* 
prohlednutí tabulky
SELECT *
FROM lookup_table lt; 
*/

SELECT 
	population 
FROM lookup_table lt
WHERE country = 'Austria';

-- Úkol 12: Z tabulky lookup_table vyberte jen země, které mají počet obyvatel větší než 500 milionů.

SELECT 
	country 
FROM lookup_table lt 
WHERE population > 500000000;

-- Úkol 13: Zjistěte počet nakažených v Indii dne 30. srpna 2020 z tabulky covid19_basic.

SELECT 
	confirmed 
FROM covid19_basic cb 
WHERE country = 'India'
	AND date = '2020-08-30';

-- Úkol 14: Zjistěte počet nakažených na Floridě z tabulky covid19_detail_us dne 30. srpna 2020.

SELECT
	admin2 
FROM covid19_detail_us cdu
WHERE province = 'Florida';

SELECT
	admin2,
	confirmed 
FROM covid19_detail_us cdu 
WHERE province = 'Florida'
	AND date = '2020-08-30';
