-- voorwaarde:
-- prepare.sql uitgevoerd.

DROP TABLE IF EXISTS distance;

SELECT a.medewerker AS medewerkerA,
	b.medewerker AS medewerkerB,
	ST_Distance(a.geom, b.geom) AS distance
INTO distance
FROM adressen1903 a, adressen1903 b
WHERE a.medewerker < b.medewerker;

------------------------------------------------------------
-- Schrijf CSV
------------------------------------------------------------

COPY distance
TO '/tmp/distance.csv' -- in tmp mag iedereen altijd schrijven
WITH DELIMITER ',' CSV HEADER;
