-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
CREATE OR REPLACE VIEW v_karel_dvorak_second_question AS 
SELECT 
	date,
	floor(avg_wages/value) AS max_buy,
	price_unit,
	industry_name,
	value
FROM t_karel_dvorak_project_sql_primary_final tkdpspf 
WHERE foodstuffs IN ( 'Mléko polotučné pasterované', 'Chléb konzumní kmínový')
ORDER BY industry_name;

-- data za první a poslední srovnatelná období pro jednotlivé komodity zvlášť, mléko v litrech a chleba v kilogramech
SELECT 
	date,
	industry_name,
	max_buy,
	price_unit
FROM v_karel_dvorak_second_question vkdsq 
WHERE date IN (2006, 2018)
ORDER BY date, industry_name;

