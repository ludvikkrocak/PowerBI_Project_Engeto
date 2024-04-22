
CREATE VIEW tbl_czech_export AS
SELECT 
    q.reporter_countries
    ,q.partner_countries 
    ,q.item
    ,q.year
    ,q.export_tonnes
    ,v.export_usd
FROM 
    (SELECT reporter_countries
    	,partner_countries 
        ,item
        ,year
        ,value AS export_tonnes
    FROM czech_export
    WHERE element = 'Export Quantity' AND value <> 0) q
INNER JOIN 
    (SELECT reporter_countries
    	,partner_countries 
        ,item
        ,year
        ,value AS export_usd
    FROM czech_export
    WHERE element = 'Export Value' AND value <> 0) v
ON q.partner_countries = v.partner_countries AND q.item = v.item AND q.year = v.year;





SELECT * FROM country_percentage
WHERE year = 1993 AND partner_countries LIKE '%germany%'
ORDER BY item;




CREATE VIEW country_percentage AS
SELECT 
    year
    ,partner_countries 
    ,item
    ,export_tonnes
    ,export_usd
    ,SUM(export_tonnes) OVER (PARTITION BY year, partner_countries) AS total_export_tonnes
    ,SUM(export_usd) OVER (PARTITION BY year, partner_countries) AS total_export_usd
FROM tbl_czech_export;



CREATE VIEW country_percentage_2 AS
SELECT 
    year
    ,partner_countries 
    ,item
    ,export_tonnes
    ,export_usd
    ,ROUND((total_export_tonnes / SUM(total_export_tonnes) OVER (PARTITION BY year)) * 100, 2) AS percentage_export_tonnes
    ,ROUND((total_export_usd / SUM(total_export_usd) OVER (PARTITION BY year)) * 100, 2) AS percentage_export_usd
FROM country_percentage;


SELECT * FROM country_percentage_2
WHERE year = 1993 AND (partner_countries LIKE '%germany%')
ORDER BY item;


SELECT     
    year
    ,SUM(percentage_export_tonnes)
FROM country_percentage_2
WHERE year = 2015;



DROP VIEW country_percentage_2;














CREATE TABLE czech_export AS
SELECT 
		ce.year
		,reporter_countries
		,ce.partner_countries
		,ce.item
		,export_tonnes
		,export_usd
		,country_percentage_export_tonnes AS percentage_export_tonnes
		,country_percentage_export_usd AS percentage_export_usd
FROM tbl_czech_export ce
INNER JOIN country_percentage cp
	ON ce.year = cp.year AND ce.partner_countries = cp.partner_countries
						AND ce.item = cp.item;
		
SELECT * FROM tbl_czech_export2;
