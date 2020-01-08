-- LET OP! Halve poging om de afstand over de weg tussen twee werklieden te bepalen

-- Voorwaarde:
-- prepare.sql uitgevoerd

------------------------------------------------------------
-- Zoek het dichtstbijzijnde straatdeel van elke medewerker
------------------------------------------------------------
DROP TABLE IF EXISTS starting_nodes;

SELECT m.medewerker, t.source, t.target
INTO starting_nodes
FROM stratenpatroon1903 t, adressen1903 m,
	(SELECT a.medewerker,
		MIN(ST_Distance(c.geom, a.geom)) AS min_dis
	FROM stratenpatroon1903 c, adressen1903 a
	GROUP BY a.medewerker
	) AS x
WHERE x.min_dis = ST_Distance(t.geom, m.geom)
	AND x.medewerker = m.medewerker
ORDER BY m.medewerker;

------------------------------------------------------------
-- Bepaal twee routes naar de CWS
-- Dit zijn er twee: vanaf het ene uiteinde van het straatdeel ("source")
-- en vanaf het andere uiteinde van het straatdeel ("target").
------------------------------------------------------------
DROP TABLE IF EXISTS temp_paths;

SELECT *,
(
	SELECT ST_Union(geom)
	FROM pgr_dijkstra('
		SELECT gid AS id,
			source::int4,
			target::int4,
			len::float8 AS cost
		FROM stratenpatroon1903',
		starting_nodes.source::integer,
		909, -- find out which node is closest to CWS -> use QGIS to view topology in PostgreSQL-database
		false,
		false)
	LEFT JOIN stratenpatroon1903 s
	ON (id2=s.gid)
) AS route_source,
(
	SELECT ST_Union(geom)
	FROM pgr_dijkstra('
		SELECT gid AS id,
			source::int4,
			target::int4,
			len::float8 AS cost
		FROM stratenpatroon1903',
		starting_nodes.target::integer,
		909, -- find out which node is closest to CWS -> view topology in PostgreSQL-database in QGIS
		false,
		false)
	LEFT JOIN stratenpatroon1903 s
	ON (id2=s.gid)
) AS route_target
INTO temp_paths
FROM starting_nodes;

------------------------------------------------------------
-- Bepaal de kortste route van de twee (en lengte), per medewerker
------------------------------------------------------------
DROP TABLE IF EXISTS routes;

SELECT medewerker,
	CASE 	WHEN ST_Length(route_source) <= ST_Length(route_target)
		THEN route_source
		ELSE route_target
	END AS route
INTO routes
FROM temp_routes
ORDER BY medewerker;

ALTER TABLE routes ADD COLUMN len integer;

UPDATE routes
SET len =
(SELECT ST_Length(route));

------------------------------------------------------------
-- Verwijder tussentabellen: starting_nodes, temp_routes
------------------------------------------------------------
DROP TABLE IF EXISTS starting_nodes;
DROP TABLE IF EXISTS temp_routes;

------------------------------------------------------------
-- Schrijf CSV
------------------------------------------------------------

COPY routes
TO '/tmp/routes.csv' -- in tmp mag iedereen altijd schrijven
WITH DELIMITER ',' CSV HEADER;
