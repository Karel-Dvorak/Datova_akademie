/*
 * Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce,
 *  projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
 */
CREATE OR REPLACE VIEW v_karel_dvorak_five_question AS 

SELECT *
FROM t_karel_dvorak_project_sql_secondary_final tkdpssf 
WHERE country = 'Czech Republic';



SELECT *
FROM v_karel_dvorak_second_question vkdsq ;

SELECT *
FROM v_karel_dvorak_four_question vq4 
JOIN v_karel_dvorak_five_question vq5 
ON vq4.`date` = vq5.`year` ;


SELECT *
FROM v_karel_dvorak_five_question vkdfq 
