
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