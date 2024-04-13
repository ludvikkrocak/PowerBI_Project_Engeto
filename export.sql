
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