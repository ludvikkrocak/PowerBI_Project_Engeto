
CREATE VIEW czech_export AS
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
    FROM cz_export
    WHERE element = 'Export Quantity' AND value <> 0) q
INNER JOIN 
    (SELECT reporter_countries
    	,partner_countries 
        ,item
        ,year
        ,value AS export_usd
    FROM cz_export
    WHERE element = 'Export Value' AND value <> 0) v
ON q.partner_countries = v.partner_countries AND q.item = v.item AND q.year = v.year;



CREATE VIEW country_percentage AS
WITH country_total AS (
    SELECT 
        year
        ,partner_countries 
        ,item
        ,export_tonnes
        ,export_usd
        ,SUM(export_tonnes) OVER (PARTITION BY year, partner_countries) AS total_export_tonnes
        ,SUM(export_usd) OVER (PARTITION BY year, partner_countries) AS total_export_usd
    FROM czech_export
)
SELECT 
    year
    ,partner_countries 
    ,item
    ,export_tonnes
    ,export_usd
    ,total_export_tonnes
    ,total_export_usd
    ,ROUND((total_export_tonnes / SUM(total_export_tonnes) OVER (PARTITION BY year)) * 100, 2) AS percentage_export_tonnes
    ,ROUND((total_export_usd / SUM(total_export_usd) OVER (PARTITION BY year)) * 100, 2) AS percentage_export_usd
FROM country_total;



DROP TABLE tbl_czech_export;

CREATE TABLE tbl_czech_export AS
SELECT 
		ce.year
		,ce.partner_countries
		,ce.item
		,ce.export_tonnes
		,ce.export_usd
		,total_export_tonnes
		,total_export_usd
		,percentage_export_tonnes
		,percentage_export_usd
FROM czech_export ce
LEFT JOIN country_percentage cp
	ON ce.year = cp.year AND ce.partner_countries = cp.partner_countries AND ce.item = cp.item;
		
SELECT * FROM tbl_czech_export;





SELECT * FROM country_percentage
WHERE year = 2022 AND (partner_countries LIKE '%germany%')
ORDER BY item;


SELECT     
    year
    ,SUM(percentage_export_tonnes)
FROM country_percentage
WHERE year = 2015;
