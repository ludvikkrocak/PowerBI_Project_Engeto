
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