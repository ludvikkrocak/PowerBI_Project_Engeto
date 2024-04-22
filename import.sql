
CREATE TABLE tbl_czech_import AS
SELECT 
    q.reporter_countries
    ,q.partner_countries 
    ,q.item
    ,q.year
    ,q.import_tonnes
    ,v.import_usd
    ,ROUND((q.import_tonnes / SUM(q.import_tonnes) OVER (PARTITION BY q.year)) * 100, 2) AS percentage_import_tonnes
    ,ROUND((v.import_usd / SUM(v.import_usd) OVER (PARTITION BY q.year)) * 100, 2) AS percentage_import_usd
FROM 
    (SELECT reporter_countries
    	,partner_countries 
        ,item
        ,year
        ,value AS import_tonnes
    FROM czech_import
    WHERE element = 'Import Quantity' AND value <> 0) q
INNER JOIN 
    (SELECT reporter_countries
    	,partner_countries 
        ,item
        ,year
        ,value AS import_usd
    FROM czech_import
    WHERE element = 'Import Value' AND value <> 0) v
ON q.partner_countries = v.partner_countries AND q.item = v.item AND q.year = v.year
GROUP BY year, partner_countries;

SELECT * FROM tbl_czech_import;



SELECT
    SUM(percentage_import_tonnes) AS total_percentage,
    SUM(percentage_import_usd) AS total_percentage_usd
FROM 
    tbl_czech_import
WHERE year = 2000;

CREATE VIEW country_percentage_import AS
SELECT 
		year
		,partner_countries
		,percentage_import_tonnes AS country_percentage_import_tonnes
		,percentage_import_usd AS country_percentage_import_usd
FROM 
    tbl_czech_import
GROUP BY year, partner_countries;

DROP TABLE tbl_czech_import2

CREATE TABLE tbl_czech_import2 AS
SELECT 
		ci.year
		,reporter_countries
		,ci.partner_countries
		,ci.item
		,import_tonnes
		,import_usd
		,country_percentage_import_tonnes AS percentage_import_tonnes
		,country_percentage_import_usd AS percentage_import_usd
FROM tbl_czech_import ci
LEFT JOIN country_percentage_import cpi
	ON ci.year = cpi.year AND ci.partner_countries = cpi.partner_countries;

SELECT * FROM tbl_czech_import2;