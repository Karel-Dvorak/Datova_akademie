-- BONUSOVÁ CVIČENÍ 2.LEKCE --

/*
 * Countries: další cvičení
 * Abychom nepracovali stále jenom s covidem, podíváme se nyní na tabulku countries, která obsahuje údaje o státech a územích.
 *Countries: další cvičení
 * 
 * Úkol 1: Najděte národní pokrm pro všechny státy východní Evropy.
 */

SELECT 
	country,
	national_dish
FROM countries c
WHERE region_in_world = 'Eastern Europe';

/*
 * Úkol 2: Najděte všechny státy a území, jejichž měna má v názvu 'dolar'.
 *  Najděte také všechny státy a území, kde se platí americkým dolarem.
 */ 
 
-- mé řešení, které splní lépe druhou část úkolu. Ale neprocvičí LIKE
SELECT 
	country,
	currency_name,
	currency_code 
FROM countries c 
WHERE currency_name LIKE '%Dollar%'
	OR currency_code = 'USD';

-- cvičební řešení

SELECT 
	country,
	currency_name
FROM countries c 
WHERE currency_name LIKE '%dollar%';

SELECT 
	country,
	currency_name
FROM countries c 
WHERE lower(currency_name) LIKE '%US dollar%';

/*
 * Úkol 3: Ověřte, jestli je mezinárodní zkratka území (abbreviation) vždy shodná s koncovkou internetové domény (domain_tld).
 */

-- mé řešení - výsledek, náhled a kontrola hodnot(null)
SELECT 
	abbreviation,
	domain_tld, 
	CASE
		WHEN lower(abbreviation) = SUBSTRING(domain_tld, 2,5) THEN 'Yes'
		ELSE 'No'
	END AS comparison
FROM countries c
ORDER BY comparison;

-- správné řešení
SELECT *
FROM countries c 
WHERE lower(abbreviation) != SUBSTRING(domain_tld, 2,5);

/*
 * Úkol 4: Najděte všechna území, jejichž hlavní město má víceslovný název.
 */

SELECT *
FROM countries c 
WHERE capital_city LIKE '% %';

/*
 * Úkol 5: Seřaďte všechny křesťanské země podle roku, kdy získaly nezávislost (independence_date). Seřaďte je od nejstarších po nejmladší.
 */

SELECT 
	country,
	religion,
	independence_date 
FROM countries c 
WHERE religion = 'Christianity'
ORDER BY independence_date;

-- odstanění NULL hodnot

SELECT 
	country,
	religion,
	independence_date 
FROM countries c 
WHERE independence_date IS NOT NULL 
	AND religion = 'Christianity'
ORDER BY independence_date;

/*
 * Úkol 6: Vyberte země, které splňují alespoň jednu z následujících podmínek:
jejich průměrná nadmořská výška (elevation) je větší než 2000 metrů nad mořem.
průměrná roční teplota (yearly_average_temperature) je nižší než 5 stupňů nebo vyšší než 25 stupňů.
jejich populace je větší než 10 milionů obyvatel a zároveň je hustota zalidnění větší než 1000 obyvatel na kilometr čtvereční

 */
CREATE VIEW v_karel_dvorak_hostile_countrie AS 
SELECT 
	country,
	elevation,
	yearly_average_temperature,
	population,
	population_density
FROM countries c 
WHERE elevation > 2000
	OR yearly_average_temperature < 5
	OR yearly_average_temperature > 25
	OR (population > 10000000 AND population_density > 1000);

/*
 * Úkol 7: Rozšiřte tabulku s vybranými zeměmi z minulého úkolu. 
 * Pro každou podmínku zadanou v minulém úkolu vytvořte nový sloupec
 *  s binární hodnou 1/0. Hodnota bude 1, pokud daná země splňuje 
 * danou podmínku výběru a 0 jinak. Výslednou tabulku uložte 
 * jako pohled s názvem v_{jméno}_{příjmení}_hostile_countries.
 */

CREATE OR REPLACE VIEW v_karel_dvorak1_hostile_countrie AS
SELECT 
	country,
	elevation,
	yearly_average_temperature,
	population,
	population_density,
	CASE 
		WHEN elevation > 2000 THEN 1
		ELSE 0
	END AS mountains,
	CASE
		WHEN yearly_average_temperature < 5 THEN 1
		ELSE 0
	END AS cold_wheather,
	CASE
		WHEN yearly_average_temperature < 25 THEN 1
		ELSE 0
	END AS hot_wheather,
	CASE
		WHEN yearly_average_temperature < 5 THEN 1
		ELSE 0
	END AS over_population
FROM countries c 
WHERE elevation > 2000
	OR yearly_average_temperature < 5
	OR yearly_average_temperature > 25
	OR ( population > 10000000 AND population_density > 1000);

-- kratší zápis s IF podmínkami místo CASE

CREATE OR REPLACE VIEW v_marek_soukup_hostile_countries AS
SELECT country, elevation , yearly_average_temperature , population , population_density ,
    IF ( elevation > 2000, 1, 0 ) AS mountainous,
    IF ( yearly_average_temperature < 5, 1, 0 ) AS cold_weather,
    IF ( yearly_average_temperature > 25, 1, 0 ) AS hot_weather,
    IF ( population > 10000000 AND population_density > 1000 , 1 , 0 ) AS overpopulated
FROM countries c
WHERE elevation > 2000
    OR yearly_average_temperature < 5
    OR yearly_average_temperature > 25
    OR (population > 10000000 AND population_density > 1000)
    
 /*
  * Úkol 8: Načtěte pohled z minulého úkolu. Vyberte všechny země, které splňují více než jednu podmínku.
  */

SELECT *
FROM v_karel_dvorak1_hostile_countrie vkdhc 
WHERE mountains + cold_wheather + hot_wheather + over_population > 1;

/*
 * Úkol 9: Seřaďte tabulku countries podle očekávané délky života (life_expectancy) vzestupně.
 */

SELECT *
FROM countries c 
WHERE life_expectancy IS NOT NULL 
ORDER BY life_expectancy;

/*
 * Úkol 10: V minulém úkolu jsme zjistili, že některé státy mají velmi nízké hodnoty. 
 * Mimo jiné to může to být tím, že data pocházejí z dřívějších let a skutečnost se mohla změnit.
 *  Načtěte pohled v_life_expectancy_comparison, který kombinuje data z tabulky 
 * countries a z tabulky life_expectancy (zdrojem těchto panelových dat je web Our World in Data, odkaz ZDE).
 *  V dalších lekcích si ukážeme, jak takový pohled vytvořit.
 * Vytvořte nový sloupec, ve kterém odečtete očekávanou dobu dožití v roce 2019 od očekávané doby dožití v roce 1950.
 *  Seřaďte tabulku podle tohoto nového sloupce sestupně abyste zjistili,
 *  ve kterých zemích doba dožití vzrostla nejvíce za posledních 70 let.
 * Můžete se podívat i na změnu doby dožití v zemích, které byly na prvních místech tabulky v předchozím úkolu.
 */

SELECT *,
	life_expectancy_2019 - life_expectancy_1950 AS life_expectancy_diff
FROM v_life_expectancy_comparison vlec
ORDER BY life_expectancy_2019 - life_expectancy_1950 DESC;

SELECT *,
	life_expectancy_2019 - life_expectancy_1950 AS life_expectancy_diff
FROM v_life_expectancy_comparison vlec
WHERE country IN ('Zambia', 'Mozambique', 'Malawi', 'Zimbabwe', 'Angola');

/*
 * Úkol 11: Vyberte všechny země, kde je hlavním náboženstvím buddhismus.
 */

SELECT 
	country,
	religion 
FROM countries c 
WHERE religion = 'buddhism';

/*
 * Úkol 12: Vyberte země, které získaly samostatnost před rokem 1500.
 */

SELECT *
FROM countries c; 

SELECT 
	country,
	continent,
	independence_date 
FROM countries c 
WHERE independence_date < 1500;

/*
 * Úkol 13: Vyberte země s průměrnou nadmořskou výškou přes 2000 metrů nad mořem.
 */

SELECT 
	country,
	continent,
	capital_city,
	elevation 
FROM countries c 
WHERE elevation > 2000;

/*
 * Úkol 14: Vyberte země, jejichž národním symbolem není zvíře.
 */

SELECT 
	country,
	continent,
	capital_city,
	national_symbol 
FROM countries c 
WHERE national_symbol NOT LIKE 'Animal' OR national_symbol IS NULL;

-- lepší řešení
SELECT 
	country,
	continent,
	capital_city,
	national_symbol 
FROM countries c 
WHERE national_symbol IS NULL OR national_symbol != 'Animal';

/*
 * Úkol 15: Vyberte země, jejichž hlavním náboženstvím není ani křesťanství ani islám.
 * Christianity Islam
 */

SELECT 
	country,
	continent,
	capital_city,
	religion 
FROM countries c 
WHERE religion != 'Christianity' AND religion != 'Islam';

SELECT 
	country,
	continent,
	capital_city,
	religion 
FROM countries c 
WHERE religion NOT IN ('Christianity', 'Islam');

/*
 * Úkol 16: Vyberte země platící Eurem, jejichž hlavním náboženstvím není křesťanství.
 */
-- přes jméno měny
SELECT 
	country,
	continent,
	capital_city,
	currency_name,
	religion 
FROM countries c  
WHERE currency_name = 'Euro' AND religion != 'Christianity';

-- přes měnový kód
SELECT 
	country,
	continent,
	capital_city,
	currency_code,
	religion 
FROM countries c 
WHERE currency_code = 'EUR'
	AND religion != 'Christianity';

/*
 * Úkol 17: Vyberte země, jejichž průměrná roční teplota je menší než 0 stupňů nebo větší než 30 stupňů.
 */

SELECT 
	country,
	continent,
	capital_city,
	yearly_average_temperature 
FROM countries c 
WHERE yearly_average_temperature <= 0
	OR yearly_average_temperature >= 30;

/*
 * Úkol 18: Vyberte země, které získaly nezávislost v devatenáctém století.
 */

SELECT 
	country,
	continent,
	capital_city,
	independence_date
FROM countries c 
WHERE independence_date >= 1800
	AND independence_date < 1900;

/*
 * Úkol 19: Spočítejte hustotu zalidnění pomocí sloupců population a surface_area. Porovnejte jej se sloupcem population_density.
 */

SELECT 
	country,
	population_density,
	round( population / surface_area, 2) AS my_calculations,
	round(population / surface_area, 2) - round( population_density, 2) AS diff
FROM countries c ;

-- abs  - vrací absolutní hodnotu, prakticky umaže mínus
SELECT country , 
    round( population / surface_area , 2 ) AS population_density_calculated, 
    round( population_density , 2 ) AS population_density,
    abs ( round( population / surface_area , 2 ) - round( population_density , 2 ) ) AS diff
FROM countries;


/*
 * Úkol 20: Zjistěte průměrnou roční teplotu ve Fahrenheitech (9/5 * Celsius + 32).
 */

SELECT 
	country,
	yearly_average_temperature,
	9/5 * yearly_average_temperature + 32 AS temp_fahrenheit
FROM countries c;

/*
 * Úkol 21: Vytvořte novou proměnnou climate podle průměrné roční teploty. Kategorie budou následující:

méně než 0 : freezing
0-10 : chilly
11-20 : mild
21-30 : warm
30 a víc : scorching
 */


SELECT 
	country,
	yearly_average_temperature,
	CASE 
		WHEN yearly_average_temperature < 0 THEN 'freezing' 
		WHEN yearly_average_temperature >= 0 AND yearly_average_temperature <= 10 THEN 'chilly'
		WHEN yearly_average_temperature >= 11 AND yearly_average_temperature <= 20 THEN 'mild'
		WHEN yearly_average_temperature >= 21 AND yearly_average_temperature <= 30 THEN 'warm'
		ELSE 'scorching'
	END AS climate	
FROM countries c
WHERE yearly_average_temperature IS NOT NULL;

/*
 * Úkol 22: Tj. vytvořte sloupec N_S_hemisphere, který bude mít hodnotu north, 
 * pokud se země nachází na severní polokouli, south, pokud se země nachází 
 * na jižní polokouli a equator, pokud zemí prochází rovník.
 */

SELECT
	country,
	CASE 
		WHEN north < 0 THEN 'south'
		WHEN south > 0 THEN 'north'
		ELSE 'equator'
	END AS N_S_hemisphere	
FROM countries c
WHERE south IS NOT NULL 
	AND north IS NOT NULL;

-- COVID-19: ORDER BY

/*
 * Úkol 1: Vyberte sloupec country, date a confirmed z tabulky covid19_basic pro Rakousko. Seřaďte sestupně podle sloupce date.
 */

SELECT 
	country,
	date,
	confirmed 
FROM covid19_basic cb 
WHERE country = 'Austria'
ORDER BY date DESC;

/*
 * Úkol 2: Vyberte pouze sloupec deaths v České republice.
 */

SELECT 
	deaths 
FROM covid19_basic cb 
WHERE country = 'Czechia'; 

/*
 * Úkol 3: Vyberte pouze sloupec deaths v České republice. Seřaďte sestupně podle sloupce date.
 */

SELECT 
	deaths 
FROM covid19_basic cb 
WHERE country = 'Czechia'
ORDER BY date DESC; 

/*
 * Úkol 4: Zjistěte, kolik nakažených bylo k poslednímu srpnu 2020 po celém světě.
 */

SELECT 
	sum(confirmed)
FROM covid19_basic cb
WHERE date = '2020-08-31';

-- V řešení cvičení s převodem CAST

SELECT 
    SUM(confirmed)
FROM covid19_basic
WHERE date = CAST('2020-08-31' AS date);

/*
 * Úkol 5: Vyberte seznam provincií v US a seřadte jej podle názvu.
 */

SELECT DISTINCT
	province 
FROM covid19_detail_us cdu  
ORDER BY province DESC;

/*
 * Úkol 6: Vyberte pouze Českou republiku, seřaďte podle datumu a vytvořte nový sloupec udávající rozdíl mezi recovered a confirmed.
 */

SELECT 
	*,
	abs(recovered - confirmed) AS diff
FROM covid19_basic cb 
WHERE country = 'Czechia'
ORDER BY date;

/*
 * Úkol 7: Vyberte 10 zemí s největším přírůstkem k 1.7.2020 a seřaďte je od největšího nárůstů k nejmenšímu.
 */

SELECT 
	country,
	confirmed 
FROM covid19_basic_differences cbd 
WHERE date = '2020-07-01'
ORDER BY confirmed DESC
LIMIT 10;

/*
 * Úkol 8: Vytvořte sloupec, kde přiřadíte 1 těm zemím, které mají 
 * přírůstek nakažených vetši než 10000 k 30.8.2020. Seřaďte je sestupně podle velikosti přírůstku nakažených.
 */

SELECT 
	country,
	confirmed,
	CASE 
		WHEN confirmed > 10000 THEN 1
		ELSE 0
	END AS check_day
FROM covid19_basic_differences cbd 
WHERE date = '2020-08-30'
ORDER BY confirmed DESC; 

/*
 * Úkol 9: Zjistěte, kterým datumem začíná a končí tabulka covid19_detail_us.
 */

SELECT 
	min(date),
	max(date)
FROM covid19_detail_us cdu  
;
-- řešení ve cvičení, asi kvůli distinct
SELECT DISTINCT
	date
FROM covid19_detail_us
ORDER BY date;

SELECT DISTINCT
	date
FROM covid19_detail_us cdu 
ORDER BY date DESC;

/*
 * Úkol 10: Seřaďte tabulku covid19_basic podle států od A po Z a podle data sestupně.
 */

SELECT
	*
FROM covid19_basic cb 
ORDER BY country, date DESC;

-- COVID-19: CASE Expression

/*
 * Úkol 1 Vytvořte nový sloupec flag_vic_nez_10000. Zemím, které měly dne 30. 8. 2020
 *  denní přírůstek nakažených vyšší než 10000, přiřaďte hodnotu 1, ostatním hodnotu 0.
 *  Seřaďte země sestupně podle počtu nově potvrzených případů.
 */

SELECT 
	country,
	confirmed,
	CASE 
		WHEN confirmed > 10000 THEN 1
		ELSE 0
	END AS flag_vic_nez_10000
FROM covid19_basic_differences cbd
WHERE date = '2020-08-30'
ORDER BY confirmed DESC;

/*
 * Úkol 2 Vytvořte nový sloupec flag_evropa a označte slovem 
 * Evropa země Německo, Francie, Španělsko. Zbytek zemí označte slovem Ostatni.
 */

SELECT 
	*,
	CASE 
		WHEN country IN ('Germany', 'France', 'Spain') THEN 'Europe'
		ELSE 'Others'
	END AS flag_evropa
FROM covid19_basic_differences cbd;

/*
 * Úkol 3 Vytvořte nový sloupec s názvem flag_ge. Do něj uložte pro všechny země, 
 * začínající písmeny "Ge", heslo GE zeme, ostatní země označte slovem Ostatni.
 */

SELECT 
	*,
	CASE 
		WHEN country LIKE 'Ge%' THEN 'GE zeme'
		ELSE 'Ostatní'
	END AS flag_ge
FROM covid19_basic_differences cbd 
;

/*
 * Úkol 4 Využijte tabulku covid19_basic_differences a vytvořte nový sloupec category. 
 * Ten bude obsahovat tři kategorie podle počtu nově potvrzených případů: 0-1000, 1000-10000 a >10000. 
 * Výslednou tabulku seřaďte podle data sestupně. 
 * Vhodně také ošetřete možnost chybějících nebo chybně zadaných dat.
 */

SELECT *,
	CASE 
		WHEN confirmed IS NULL OR confirmed  < 1000 THEN '0 - 1000'
		WHEN confirmed <= 10000 THEN '1000 - 10000'
		WHEN confirmed > 10000 THEN 'vice nez 10000'
		ELSE 'error'
	END AS category
FROM covid19_basic_differences cbd 
ORDER BY date DESC;


/*
 * Úkol 5 Vytvořte nový sloupec do tabulky covid19_basic_differences a označte hodnotou 1 ty řádky, 
 * které popisují Čínu, USA nebo Indii a zároveň mají více než 10 tisíc nově nakažených v daném dni.
 */

-- US, India, China
SELECT
	*,
	CASE 
		WHEN country IN ('US', 'India', 'China') 
		AND confirmed IS NOT NULL AND confirmed > 10000 THEN 1
		ELSE 0
	END AS new_column
FROM covid19_basic_differences cbd
ORDER BY confirmed DESC;

/*
 * Úkol 6 Vytvořte nový sloupec flag_end_a, kde označíte heslem A zeme ty země, jejichž název končí písmenem A.
 *  Ostatní země označte jako ne A zeme.
 */

SELECT
	*,
	CASE 
		WHEN country LIKE '%a' THEN 'A zeme'
		ELSE 'ne A zeme'
	END	AS flag_end_a
FROM covid19_basic cb;

-- COVID-19: WHERE, IN a LIKE --
/*
 * Úkol 1 Vytvořte view obsahující kumulativní průběh jen ve Spojených státech, Číně a Indii. Použijte syntaxi s IN.
 */

CREATE OR REPLACE VIEW v_karel_kumul AS
SELECT *
FROM covid19_basic cb 
WHERE country IN ('US', 'China', 'India'); 

/*
 * Úkol 2 Vyfiltrujte z tabulky covid19_basic pouze země, které mají populaci větší než 100 milionů.
 */

-- zaleží na znalosti informací v tabulkách
SELECT 
	country 
FROM covid19_basic cb
WHERE country IN
	(SELECT 
		country
	FROM countries c 
	WHERE population >= 100000000
);
SELECT 
        *
FROM covid19_basic cbd    
WHERE country IN
        (SELECT DISTINCT 
                country 
         FROM lookup_table lt 
         WHERE population>=100000000
        );

/*
 *Úkol 3 Vyfiltrujte z tabulky covid19_basic pouze země, které jsou zároveň obsaženy v tabulce covid19_detail_us.
 */

SELECT
	*
FROM covid19_basic cb 
WHERE country IN (
	SELECT DISTINCT -- DISTINCT??
		country
	FROM covid19_detail_us cdu
);

/*
 * Úkol 4 Vyfiltrujte z tabulky covid19_basic seznam zemí, které měly alespoň jednou denní nárůst větší než 10 tisíc nově nakažených.
 */


SELECT DISTINCT 
	country 
FROM covid19_basic cb 
WHERE country IN (
	SELECT DISTINCT 
		country 
	FROM covid19_basic_differences cbd
	WHERE confirmed > 10000);

/*
 * Úkol 5 Vyfiltrujte z tabulky covid19_basic seznam zemí, které nikdy neměly denní nárůst počtu nakažených větší než 1000.
 */

SELECT DISTINCT 
	country 
FROM covid19_basic cb 
WHERE country NOT IN (
	SELECT DISTINCT 
		country 
	FROM covid19_basic_differences cbd
	WHERE confirmed > 1000);

/*
 * Úkol 6 Vyfiltrujte z tabulky covid19_basic seznam zemí, které nezačínají písmenem A.
 */
SELECT DISTINCT 
	country
FROM covid19_basic cb 
WHERE country NOT LIKE 'A%';



