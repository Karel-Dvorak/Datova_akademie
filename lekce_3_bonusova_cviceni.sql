--  BONUSOVÁ CVIČENÍ
-- Countries: Další cvičení

/*
 * Úkol 1:
 Zjistěte celkovou populaci kontinentů.
 Zjistěte průměrnou rozlohu států rozdělených podle kontinentů
 Zjistěte počty států podle rozdělených podle hlavního náboženství
 Státy vhodně seřaďte.
 */

SELECT *
FROM countries;

SELECT 
	continent,
FROM countries c 
GROUP BY continent
ORDER BY sum_population DESC;

SELECT 
	continent,
	avg(surface_area) AS avg_surface_area
FROM countries c 
GROUP BY continent
ORDER BY avg(surface_area) DESC;

SELECT 
	religion,
	count(*) AS sum_country
FROM countries c 
WHERE religion IS NOT NULL 
GROUP BY religion
ORDER BY count(*) DESC;

/*
 * Úkol 2:
 Zjistěte celkovou populaci, průměrnou populaci a počet států pro každý kontinent
 Zjistěte celkovou rozlohu kontinentu a průměrnou rozlohu států ležících na daném kontinentu
 Zjistěte celkovou populaci a počet států rozdělených podle hlavního náboženství
 */

SELECT 
	continent,
	sum(population) AS sum_population,
	round(avg(population)) AS avg_population,
	count(country) AS sum_country
FROM countries c 
WHERE continent IS NOT null
GROUP BY continent
ORDER BY sum(population) DESC;

SELECT 
	continent,
	round(sum(surface_area)) AS sum_surface_contitnet,
	round(avg(surface_area)) AS avg_surface_continent
FROM countries c
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY sum(surface_area) DESC;

SELECT 
	religion,
	sum(population),
	count(*) AS sum_country
FROM countries c 
WHERE religion IS NOT NULL 
GROUP BY religion
ORDER BY sum(population) DESC;

/*
 * Úkol 3: Pro každý kontinent zjistěte podíl počtu vnitrozemských států (sloupec landlocked),
 *  podíl populace žijící ve vnitrozemských státech a podíl rozlohy vnitrozemských států.
 */

SELECT 
	continent,
	round(sum(landlocked)/ count(*),2) AS landlocked_cnt_share,
	round(sum(landlocked * population)/ sum(population),2) AS landlocked_population, 
	round(sum(landlocked * surface_area) / sum(surface_area),2) AS landlocked_surface_area 
FROM countries c
WHERE continent IS NOT NULL AND landlocked IS NOT NULL
GROUP BY continent; 

/*
 * Úkol 4: Zjistěte celkovou populaci ve státech rozdělených podle kontinentů a regionů
 * (sloupec region_in_world). Seřaďte je podle kontinentů abecedně a podle populace sestupně.
 */

SELECT
	continent, 
	region_in_world,
	sum(population)
FROM countries c 
WHERE continent IS NOT NULL
GROUP BY continent, region_in_world
ORDER BY continent ASC, sum(population) DESC;

/*
 * Úkol 5: Zjistěte celkovou populaci a počet států rozdělených podle kontinentů a podle náboženství.
 * Kontinenty seřaďte abecedně a náboženství v rámci kontinentů sestupně podle populace.
 */

SELECT 
	continent,
	religion,
	sum(population) AS sum_population,
	count(*) AS sum_states
FROM countries c 
WHERE continent IS NOT NULL AND religion IS NOT NULL 
GROUP BY continent, religion
ORDER BY continent ASC, sum(population) DESC;

/*
 * Úkol 6: Zjistěte průměrnou roční teplotu v regionech Afriky.
 */

SELECT 
	region_in_world,
	round(sum(surface_area * yearly_average_temperature) / sum(surface_area) ,2) AS avg_year_temparutare
FROM countries c 
WHERE region_in_world LIKE '%Africa%' AND yearly_average_temperature IS NOT NULL 
GROUP BY region_in_world; 

-- dle řešení v lekci
SELECT 
	region_in_world,
	round(sum(surface_area * yearly_average_temperature) / sum(surface_area) ,2) AS avg_year_temparutare
FROM countries c 
WHERE continent = 'Africa' AND yearly_average_temperature IS NOT NULL 
GROUP BY region_in_world; 


--    COVID-19: funkce SUM()

/*
 *Úkol 1: Vytvořte v tabulce covid19_basic nový sloupec, kde od confirmed odečtete polovinu recovered 
 *a přejmenujete ho jako novy_sloupec. Seřaďte podle data sestupně.
 */

SELECT
	*,
	confirmed - recovered/2 AS novy_sloupec
FROM covid19_basic cb
ORDER BY date DESC;

/*
 * Úkol 2: Kolik lidí se celkem uzdravilo na celém světě k 30.8.2020?
 */

SELECT
	date,
	sum(recovered) AS sum_recovered
FROM covid19_basic cb 
WHERE date = '2020-08-30';

/*
 * Úkol 3: Kolik lidí se celkem uzdravilo, a kolik se jich nakazilo na celém světě k 30.8.2020?
 */

SELECT
	date,
	sum(recovered) AS sum_recovered,
	sum(confirmed) AS sum_confirmed
FROM covid19_basic cb 
WHERE date = '2020-08-30';

/*
 * Úkol 4: Jaký je rozdíl mezi nakaženými a vyléčenými na celém světě k 30.8.2020?
 */

SELECT
	date,
	sum(confirmed) - sum(recovered) AS diffrence_confirmed_recovered
FROM covid19_basic cb 
WHERE date = '2020-08-30';

/*
 * Úkol 5: Z tabulky covi19_basic_differences zjistěte, kolik lidí se celkem nakazilo v České republice k 30.8.2020.
 */

SELECT sum(confirmed) 
FROM covid19_basic_differences cbd
WHERE date = '2020-08-30' AND country = 'Czechia';

/*
 * Úkol 6: Kolik lidí se nakazilo v jednotlivých zemích během srpna 2020?
 */

SELECT 
	country,
	sum(confirmed)
FROM covid19_basic_differences cbd 
WHERE date >= '2020-08-01' AND date <= '2020-08-31'
GROUP BY country;

/*
 * Úkol 7: Kolik lidí se nakazilo v České republice, na Slovensku a v Rakousku mezi 20.8.2020 a 30.8.2020 včetně?
 */

SELECT 
	country,
	sum(confirmed)
FROM covid19_basic_differences cbd 
WHERE date >= '2020-08-20' AND date <= '2020-08-30' AND country IN ('Austria', 'Czechia', 'Slovakia')
GROUP BY country;

SELECT 
	country,
	sum(confirmed)
FROM covid19_basic_differences cbd 
WHERE country IN ('Austria', 'Czechia', 'Slovakia') AND date >= '2020-08-20' AND date <= '2020-08-30'
GROUP BY country;

/*
 * Úkol 8: Jaký byl největší přírůstek v jednotlivých zemích?
 */

SELECT 
	country,
	max(confirmed)
FROM covid19_basic_differences cbd 
GROUP BY country;

/*
 * Úkol 9: Zjistěte největší přírůstek v zemích začínajících na C.
 */

SELECT
	country,
	max(confirmed)
FROM covid19_basic_differences cbd 
WHERE country LIKE 'C%'
GROUP BY country;

/*
 * Úkol 10: Zjistěte celkový přírůstek všech zemí s populací nad 50 milionů. Tabulku seřaďte podle datumu od srpna 2020.
 */

SELECT
	date,
	country,
	sum(confirmed) AS confirmed 
FROM covid19_basic_differences cbd 
WHERE country IN (
	SELECT DISTINCT country 
	FROM countries c 
	WHERE population > 50000000)
	AND date >= '2020-08-01'
GROUP BY date, country;

-- řešení ze cvičení s tabulkou zeměmi lookup_table

SELECT 
        date,
        country,
        sum(confirmed) as confirmed
FROM covid19_basic_differences
WHERE country in (SELECT DISTINCT country FROM lookup_table lt WHERE population>50000000)
      AND date>='2020-08-01'
GROUP BY
        date,
        country;
 f      
/*
 * Úkol 11: Zjistěte celkový počet nakažených v Arkansasu (použijte tabulku covid19_detail_us_differences).
 */
 
SELECT *
FROM covid19_detail_us_differences cdud;

SELECT
	province,
	sum(confirmed)
FROM covid19_detail_us_differences cdud
WHERE province = 'Arkansas'
GROUP BY province; 
 
/*
 * Úkol 12: Zjistětě nejlidnatější provincii v Brazílii.
 */

SELECT
	province,
	population
FROM lookup_table lt
WHERE country = 'Brazil' AND province IS NOT NULL
ORDER BY population DESC
LIMIT 1;

/*
 * Úkol 13: Zjistěte celkový a průměrný počet nakažených denně po dnech a
 *  seřaďte podle data sestupně (průměr zaokrouhlete na dvě desetinná čísla)
 */


SELECT 
	date,
	sum(confirmed) AS sum_confirmed,
	round(avg(confirmed), 2) AS avg_confirmed
FROM covid19_basic_differences cbd 
GROUP BY date
ORDER BY date DESC;

/*
 * Úkol 14: Zjistěte celkový počet nakažených lidí v jednotlivých provinciích USA dne 30.08.2020
 *  (použijte tabulku covid19_detail_us).
 */

SELECT 
	province,
	sum(confirmed)
FROM covid19_detail_us cdu 
WHERE date = '2020-08-30' -- AND country = 'US' nevím proč, když DATA jsou za US
GROUP BY province;

/*
 * Úkol 15: Zjistěte celkový přírůstek podle datumu a země.
 */

SELECT 
	date,
	country,
	sum(confirmed)
FROM covid19_basic_differences cbd 
GROUP BY date, country
ORDER BY date DESC;


-- COVID-19: funkce AVG() a COUNT()


/*
 * Úkol 1: Zjistěte průměrnou populaci ve státech ležících severně od 60 rovnoběžky.
 */

SELECT *
FROM lookup_table lt;

SELECT avg(population)
FROM lookup_table lt 
WHERE lat >= 60 
	AND province IS NOT NULL; 

/*
 * Úkol 2: Zjistěte průměrnou, nejvyšší a nejnižší populaci v zemích ležících severně od 60 rovnoběžky.
 *  Spočítejte, kolik takových zemích je. Vytvořte sloupec max_min_ratio, ve kterém nejvyšší populaci vydělíte nejnižší.
 */

SELECT 
	min(population) AS min_population,
	round(avg(population),2) AS avg_population,
	max(population)	AS max_population,
	count(DISTINCT country) AS number_country,
	max(population) / min(population) AS max_min_ratio
FROM lookup_table lt 
WHERE lat >= 60;


SELECT 
    avg(population), 
    max(population), 
    min(population), 
    count( distinct country),
    (max(population) / min(population)) AS max_min_ratio
FROM lookup_table lt 
WHERE lat >= 60;

/*
 * Úkol 3: Zjistěte průměrnou populaci a rozlohu v zemích seskupených podle náboženství.
 *  Zjistěte také počet zemí pro každé náboženství.
 */

SELECT 
	religion,
	round(avg(population)) AS avg_population,
	round(avg(surface_area)) AS avg_surface_area,
	count(country)
FROM countries c 
GROUP BY religion;

/*
 * Úkol 4: Zjistěte počet zemí, kde se platí dolarem (jakoukoli měnou, která má v názvu dolar).
 *  Zjistěte nejvyšší a nejnižší populaci mezi těmito zeměmi.
 */
SELECT 
	DISTINCT currency_name
FROM countries c;

SELECT 
	count(country),
	min(population),
	max(population)
FROM countries c 
WHERE currency_name LIKE '%Dollar%';

SELECT count(country), max(population), min(population)
FROM countries c 
WHERE LOWER(currency_name) LIKE LOWER('%dollar%')

SELECT count(country), max(population), min(population)
FROM countries c 
WHERE LOWER(currency_name) LIKE LOWER('%dollar%') OR currency_code = 'USD'
;

/*
 * Úkol 5: Zjistěte, kolik zemí platících Eurem leží v Evropě a kolik na jiných kontinentech.
 */

SELECT 
	continent,
	count(country)
FROM countries c 
WHERE currency_name LIKE 'Euro'
GROUP BY continent;

SELECT 
	continent,
	count(country)
FROM countries c 
WHERE currency_code = 'EUR'
GROUP BY continent;

/*
 * Úkol 6: Zjistěte, pro kolik zemí známe průměrnou výšku jejích obyvatel.
 */

SELECT 
	count(country) 
FROM countries c 
WHERE avg_height IS NOT NULL;

/*
 * Úkol 7: Zjistěte průměrnou výšku obyvatel na jednotlivých kontinentech.
 */

SELECT 
	continent, 
	round(avg(avg_height),2) AS avg_heightsioun
FROM countries c
WHERE avg_height IS NOT NULL
GROUP BY continent; 

-- vážený průměr

SELECT continent , round( sum(population*avg_height)/sum(population) , 2) AS weighted_average
FROM countries c 
WHERE avg_height IS NOT NULL
GROUP BY continent

/*
 * Úkol 8: Zjistěte průměrnou hustotu zalidnění pro světový region (region_in_world). 
 * Srovnejte obyčejný a vážený průměr. Váhou bude v tomto případě rozloha státu (surface_area). 
 * Výslednou tabulku uložte jako v_{jméno}_{příjmení}_population_density.
 */

CREATE OR REPLACE VIEW v_karel_dvorak_population_density AS
SELECT 
	region_in_world,
	round(avg(population_density),2) AS avg_population_density, 
	round(sum(population_density  * surface_area) / sum(surface_area),2) AS weighted_avg_density 
FROM countries c
WHERE population_density IS NOT NULL AND region_in_world IS NOT NULL
GROUP BY region_in_world ;

/*
 * Úkol 9: Načtěte tabulku (lépe řečeno pohled), který jste vytvořili v minulém úkolu.
 *  Vytvořte nový sloupec diff_avg_density, který bude absolutní hodnotou (funkce abs) 
 * rozdílu mezi obyčejným a váženým průměrem. Tabulku seřaďte podle tohoto nového sloupce sestupně.
 *  V dalším úkolu se na jeden z těchto regionů podíváme blíže, abychom si lépe 
 * ukázali rozdíl mezi obyčejným a váženým průměrem.
*/


SELECT *,
	abs(avg_population_density - weighted_avg_density) AS diff_avg_density
FROM v_karel_dvorak_population_density vkdpd
ORDER BY abs(avg_population_density - weighted_avg_density) DESC;

/*
 * Úkol 10: Vyberte název, hustotu zalidnění a rozlohu zemí v západní Evropě.
 *  Najděte stát s nejvyšší hustotou zalidnění. Spočítejte obyčejný a vážený průměr hustoty zalidnění 
 * v západní Evropě kromě státu s nejvyšší hustotou. Výsledky srovnejte s oběma průměry spočítanými ze všech zemí.
 */
-- státy západní evropy
SELECT country 
FROM countries c 
WHERE region_in_world = 'Western Europe';

-- výpočet
SELECT 
	round(avg(population_density),2) AS simple_population_density,
	round(sum(surface_area*population_density)/sum(surface_area),2) AS weighted_avg_density 
FROM countries c 
WHERE region_in_world = 'Western Europe' AND country != 'Monaco';

-- dle řešení
SELECT 
    0 AS `Monaco_included`,
    round( avg(population_density), 2 ) AS simple_avg_density ,
    round( sum(surface_area*population_density) / sum(surface_area), 2 ) AS weighted_avg_density
FROM countries c 
WHERE region_in_world = 'Western Europe' AND country != 'Monaco';

-- porovnání dle řešení
SELECT 
    0 AS `Monaco_included`,
    round( avg(population_density), 2 ) AS simple_avg_density ,
    round( sum(surface_area*population_density) / sum(surface_area), 2 ) AS weighted_avg_density
FROM countries c 
WHERE region_in_world = 'Western Europe' AND country != 'Monaco'
UNION
SELECT
    1 AS `Monaco_included`,
   avg_population_density, 
    weighted_avg_density 
FROM v_karel_dvorak_population_density vkdpd
WHERE region_in_world = 'Western Europe'
;
