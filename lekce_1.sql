-- Domácí úkoly první lekce

/*
 * Úkol 1: Vypište všechna data z tabulky healthcare_provider.
 */
SELECT *
FROM healthcare_provider hp;

/*
 * Úkol 2: Vypište pouze sloupce se jménem a typem poskytovatele ze stejné tabulky jako v předchozím příkladu.
 */

SELECT 
	name, provider_type
FROM healthcare_provider hp;

/*
 * Úkol 3: Předchozí dotaz upravte tak, že vypíše pouze prvních 20 záznamů v tabulce.
 */
SELECT 
	name, provider_type
FROM healthcare_provider hp
LIMIT 20;

/*
 * Úkol 4: Vypište z tabulky healthcare_provider záznamy seřazené podle kódu kraje vzestupně.
 */
SELECT 
	*
FROM healthcare_provider hp
ORDER BY region_code ASC;

/*
 * Úkol 5: Vypište ze stejné tabulky jako v předchozím příkladě 
 * sloupce se jménem poskytovatele, kódem kraje a kódem okresu. 
 * Data seřaďte podle kódu okresu sestupně. Nakonec vyberte pouze prvních 500 záznamů.
 */


SELECT 
	name,
	region_code,
	district_code 
FROM healthcare_provider hp 
ORDER BY district_code DESC
LIMIT 500;


/*
 * WHERE
 * Úkol 1: Vyberte z tabulky healthcare_provider všechny záznamy 
 * poskytovatelů zdravotních služeb, kteří poskytují služby v Praze (kraj Praha).
 */

SELECT *
FROM czechia_region cr;

SELECT *
FROM healthcare_provider hp
WHERE region_code = 'CZ010'

/*
 * *Úkol 2: Vyberte ze stejné tabulky název a kotaktní informace poskytovatelů,
 *  kteří nemají místo poskytování v Praze (kraj Praha).
 */

SELECT
	name,
	phone,
	website, 
	email
FROM healthcare_provider hp
WHERE region_code != 'CZ010';

/*
Úkol 3: Vypište názvy poskytovatelů, kódy krajů místa 
poskytování a místa sídla u takových poskytovatelů, 
u kterých se tyto hodnoty rovnají.
*/

SELECT 
	name,
	region_code,
	residence_region_code 
FROM healthcare_provider hp 
WHERE region_code = residence_region_code;

/*
 *Úkol 4: Vypište název a telefon takových poskytovatelů, kteří svůj telefon vyplnili do registru.
 */

SELECT
	name,
	phone 
FROM healthcare_provider hp
WHERE phone != 'NULL';

SELECT 
	name,
	phone
FROM healthcare_provider hp 
WHERE phone IS NOT NULL;

/*
 * Úkol 5: Vypište název poskytovatele a kód okresu u poskytovatelů, 
 * kteří mají místo poskytování služeb v okresech Benešov a Beroun.
 *  Záznamy seřaďte vzestupně podle kódu okresu.
 */
SELECT 
	*
FROM czechia_district cd; 

SELECT 
	name,
	district_code
FROM healthcare_provider hp
WHERE district_code = 'CZ0201' OR district_code = 'CZ0202'
ORDER BY district_code;

-- Ekvivaletní a lepší

SELECT 
	name,
	district_code
FROM healthcare_provider hp
WHERE district_code IN ('CZ0201', 'CZ0202')
ORDER BY district_code;

/*
 * TVORBA TABULEK / CREATE TABLE
 */
/*
 * Úkol 1: Vytvořte tabulku t_{jméno}_{příjmení}_providers_south_moravia z 
 * tabulky healthcare_provider vyberte pouze Jihomoravský kraj.
 */

SELECT *
FROM czechia_region cr;

CREATE TABLE t_karel_dvorak_providers_south_moravia AS
SELECT *
FROM healthcare_provider hp 
WHERE region_code = 'CZ064';

SELECT *
FROM t_karel_dvorak_providers_south_moravia tkdpsm;

-- smazání tabulky

DROP TABLE IF EXISTS t_karel_dvorak_providers_south_moravia;

/*
 * Úkol 2: Vytvořte tabulku t_{jméno}_{příjmení}_resume,
 *  kde budou sloupce date_start, date_end, job, education.
 *  Sloupcům definujte vhodné datové typy.
 */
CREATE TABLE t_karel_dvorak_resume (
	date_start date,
	date_end date,
	job varchar(255),
	education varchar(255)
);

SELECT *
FROM t_karel_dvorak_resume tkdr;

INSERT INTO t_karel_dvorak_resume 
VALUES ('2023-01-15', '2023-01-19', 'mechanic','maturita');

INSERT INTO t_karel_dvorak_resume 
VALUES 
	('2023-01-15', '2023-01-19', 'mechanic','maturita'),
	('2023-01-15', '2023-01-19', 'pilot','ING'),
	('2023-01-15', '2023-01-19', 'support','gradue');

INSERT INTO t_karel_dvorak_resume (date_start, date_end, education)
VALUES 
('2023-01-15', '2023-01-19', 'TNT'),
('2023-01-18', '2023-01-20', 'pilot'),
('2023-01-16', '2023-01-23','ING');

-- mazání

DELETE FROM t_karel_dvorak_resume 
WHERE job = 'support';

-- záměna dat
UPDATE t_karel_dvorak_resume 
SET education = 'Duble ING'
WHERE job = 'pilot';

-- přidání sloupce
ALTER TABLE t_karel_dvorak_resume
ADD COLUMN instution varchar(255);

-- smazání sloupce
ALTER TABLE t_karel_dvorak_resume 
DROP COLUMN instution;

-- přejmenování sloupce
ALTER TABLE t_karel_dvorak_resume 
RENAME COLUMN job TO new_job;

-- smazání tabulky

DROP TABLE t_karel_dvorak_resume;

