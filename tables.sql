/*
			Tables production
*/

CREATE TABLE tbl_yield_per_hectare AS
SELECT
    ch.year
    ,ch.item
    ,ch.value AS harvested_area
    ,cp.value AS production_tonne
    ,ROUND((cp.value / ch.value), 2) AS yield_per_hectare
FROM
    czech_harvested AS ch
INNER JOIN
    czech_production AS cp
ON
    ch.year = cp.year
    	AND ch.item = cp.item
WHERE ch.value > 0 AND cp.value > 0
ORDER BY production_tonne DESC;

SELECT * 
FROM tbl_yield_per_hectare;

SELECT * 
FROM tbl_yield_per_hectare
ORDER BY harvested_area DESC;

SELECT *
FROM tbl_yield_per_hectare
ORDER BY yield_per_hectare DESC;

DROP TABLE tbl_yield_per_hectare;


/*
			Tables population
*/

SELECT * 
FROM czech_population cp 
WHERE year = 2021

SELECT DISTINCT domain, domain_code, area, element, Item, unit, flag_description, note
FROM czech_population cp 


/*
			Tables employment
*/

SELECT DISTINCT `indicator` 
FROM czech_agri_employment cae ;

SELECT area, sex, year, unit, value
FROM czech_agri_employment cae ;

CREATE TABLE tbl_czech_agri_worker_share_in_total_employees AS
SELECT area,
       sex,
       year,
       unit,
       value
FROM czech_agri_employment cae
WHERE indicator LIKE '%Share of employees in agriculture, forestry and fishing in total employees%';

SELECT * FROM tbl_czech_agri_worker_share_in_total_employees ;

CREATE TABLE tbl_czech_agri_worker_payroll AS
SELECT area,
       sex,
       year,
       unit,
       value
FROM czech_agri_employment cae
WHERE indicator LIKE '%Agriculture value added per worker (constant 2015 US$)%';

SELECT * FROM tbl_czech_agri_worker_payroll e


SELECT area,
       sex,
       year,
       unit,
       value
FROM czech_agri_employment cae
WHERE indicator LIKE '%Share of employment in agriculture, forestry and fishing in total employment%';

-- CREATE TABLE tbl_czech_agri_worker_share_in_total_employees AS
SELECT area,
       sex,
       year,
       unit,
       value
FROM czech_agri_employment cae
WHERE indicator LIKE '%Share of employment in crop and animal production, hunting and related service activities%';

SELECT *
FROM czech_agri_employment cae
WHERE indicator LIKE '%Share of employment in crop and animal production, hunting and related service activities%';


/*
			Tables prices
*/

CREATE TABLE tbl_gross_harvest_value_USD AS
SELECT area
	  ,cpp.item
	  ,cpp.year
	  ,value
	  ,element
	  ,(cpp.value * typh.production_tonne) AS gross_harvest_value_USD
	  ,(cpp.value * typh.yield_per_hectare) AS gross_hectar_harvest_value_USD
FROM czech_producer_prices cpp
INNER JOIN 
			tbl_yield_per_hectare typh
ON
    cpp.year = typh.year
    	AND cpp.item = typh.item
WHERE unit = 'USD';

SELECT * FROM tbl_gross_harvest_value_USD

/*
			Tables export
*/

CREATE TABLE tbl_czech_export AS
SELECT 
    q.reporter_countries
    ,q.partner_countries 
    ,q.item
    ,q.year
    ,q.export_tonnes
    ,v.export_thousands_usd
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
        ,value AS export_thousands_usd
    FROM czech_export
    WHERE element = 'Export Value' AND value <> 0) v
ON q.partner_countries = v.partner_countries AND q.item = v.item AND q.year = v.year;


SELECT *
FROM tbl_czech_export

/*
			Tables import
*/

SELECT *
FROM czech_import ci ;

CREATE TABLE tbl_czech_import AS
SELECT 
    q.reporter_countries
    ,q.partner_countries 
    ,q.item
    ,q.year
    ,q.import_tonnes
    ,v.import_thousands_usd
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
        ,value AS import_thousands_usd
    FROM czech_import
    WHERE element = 'Import Value' AND value <> 0) v
ON q.partner_countries = v.partner_countries AND q.item = v.item AND q.year = v.year;

SELECT *
FROM tbl_czech_import ;