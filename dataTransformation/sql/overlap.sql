-- voorwaarde:
-- prepare.sql uitgevoerd
-- routes.sql uitgevoerd

DROP TABLE IF EXISTS overlap;

SELECT a.medewerker AS medewerkerA,
	b.medewerker AS medewerkerB,
	ST_Intersection(a.route, b.route) AS overlap
INTO overlap
FROM routes a, routes b
WHERE a.medewerker < b.medewerker;

ALTER TABLE overlap ADD COLUMN len integer;

UPDATE overlap
SET len =
(SELECT ST_Length(overlap));


------------------------------------------------------------
-- Schrijf CSV
------------------------------------------------------------

COPY overlap
TO '/tmp/overlap.csv' -- in tmp mag iedereen altijd schrijven
WITH DELIMITER ',' CSV HEADER;
