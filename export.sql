
CREATE TABLE tbl_czech_export AS
SELECT 
    q.reporter_countries
    ,q.partner_countries 
    ,q.item
    ,q.year
    ,q.export_tonnes
    ,v.export_usd
    ,(q.export_tonnes / SUM(q.export_tonnes) OVER (PARTITION BY q.year)) * 100 AS percentage_export_tonnes
    ,(v.export_usd / SUM(v.export_usd) OVER (PARTITION BY q.year)) * 100 AS percentage_export_usd
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
ON q.partner_countries = v.partner_countries AND q.item = v.item AND q.year = v.year
GROUP BY year, partner_countries;


SELECT * FROM tbl_czech_export;


SELECT
    SUM(percentage_export_tonnes) AS total_percentage,
    SUM(percentage_export_usd) AS total_percentage_usd
FROM 
    tbl_czech_export
WHERE year = 2000;

-- CREATE VIEW country_percentage AS
SELECT 
		year
		,partner_countries
		,percentage_export_tonnes AS country_percentage_export_tonnes
		,percentage_export_usd AS country_percentage_export_usd
FROM 
    tbl_czech_export
GROUP BY year, partner_countries;


SELECT 
		ce.year
		,ce.partner_countries
		,ce.item
		,export_tonnes
		,export_usd
		,country_percentage_export_tonnes
		,country_percentage_export_usd
--		,SUM(percentage_export_tonnes) AS total_percentage
FROM tbl_czech_export ce
LEFT JOIN country_percentage cp
	ON ce.year = cp.year AND ce.partner_countries = cp.partner_countries
WHERE ce.year = 2000;
		

