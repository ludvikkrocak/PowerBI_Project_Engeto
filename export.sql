
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
ON q.partner_countries = v.partner_countries AND q.item = v.item AND q.year = v.year;


SELECT * FROM tbl_czech_export;


SELECT 
    year,
    SUM(percentage_export_tonnes) AS total_percentage,
    SUM(percentage_export_usd) AS total_percentage_usd
FROM 
    tbl_czech_export
WHERE year = 2000;