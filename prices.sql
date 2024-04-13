
CREATE TABLE tbl_gross_harvest_value_USD AS
SELECT area
	  ,cpp.item
	  ,cpp.year
	  ,value
	  ,element
	  ,(cpp.
	  value * typh.production_tonne) AS gross_harvest_value_USD
	  ,(cpp.value * typh.yield_per_hectare) AS gross_hectar_harvest_value_USD
FROM czech_producer_prices cpp
INNER JOIN 
			tbl_yield_per_hectare typh
ON
    cpp.year = typh.year
    	AND cpp.item = typh.item
WHERE unit = 'USD';

SELECT * FROM tbl_gross_harvest_value_USD

