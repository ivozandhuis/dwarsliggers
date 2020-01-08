# Doel
De scripten in deze directory doen berekeningen op de geografische informatie (woonadressen van werklieden en stratenplan van 1903) die is gemaakt in QGIS. Het rekent de looproute uit naar de werkplaats, overlap in de looproute per paar van werklieden en de geografische afstand (hemelbreed) tussen werklieden.

# Voorwaarden
De scripten in deze directory zijn ontwikkeld voor onderstaande stack van tools.

Installeer daarom:
* PostgreSQL 9.6.5
* PostGIS 2.3
* pgRouting 2.4

Hieronder de installatie die ik heb doorlopen op een schone Ubuntu 16.04 machine (september 2017).

## instaleer PostgreSQL 9.6.5 on Ubuntu 16.04
> sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main"
> wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
> sudo apt-get update
> sudo apt-get install postgresql-9.6

## instaleer PostGIS 2.3
> sudo apt-get install postgresql-9.6-postgis-2.3 postgresql-contrib-9.6

Voor de commandline tool shp2pgsql:
> sudo apt-get install postgis

## instaleer pgrouting 2.4
> sudo apt-get install postgresql-9.6-pgrouting

## extensions toevoegen aan PostgreSQL
Opstarten console:
> sudo -u postgres psql

Uitvoeren commando's:
Voor adminpack:
> CREATE EXTENSION adminpack;

Voor PostGIS (in een speciaal aan te maken database gisdb)
> CREATE DATABASE gisdb;
> \connect gisdb;

> CREATE SCHEMA postgis;
> ALTER DATABASE gisdb SET search_path=public, postgis, contrib;
> \connect gisdb;  -- to force new search path to take effect

> CREATE EXTENSION postgis SCHEMA postgis;

Check:
> SELECT postgis_full_version();

Je moet nu allerlei versienummers krijgen. Druk evt. "q" om te sluiten.

Voor pgRouting (in een speciaal aangemaakte database gisdb)
> CREATE  EXTENSION pgrouting;

Check:
> SELECT * FROM pgr_version();

Je moet nu allerlei versienummers krijgen. Druk evt. "q" om te sluiten.

Nu is de stack van tools geinstalleerd en kunnen we aan het werk.
Sluit de PSQL-console:
> \q

# Voorbereiding
Inlezen van de GIS informatie die we gemaakt hebben in QGIS in PostGIS.
(1) sql-bestanden maken van shp-files.
(paden zijn vanaf de wortel van Gitrepository)

Verwijder indien nodig de tabellen:
> sudo -u postgres psql
> \connect gisdb
> DROP TABLE adressen1903;
> DROP TABLE stratenpatroon1903;
> \q

> shp2pgsql -I -s 28992 data/sources/gis/adressen1903.shp adressen1903 > data/sources/gis/adressen1903.sql
> shp2pgsql -I -s 28992 data/sources/gis/stratenpatroon_1903.shp stratenpatroon1903 > data/sources/gis/stratenpatroon_1903.sql

(2) inlezen in PostGIS
> sudo -u postgres psql -d gisdb -f data/sources/gis/adressen1903.sql
> sudo -u postgres psql -d gisdb -f data/sources/gis/stratenpatroon_1903.sql

# prepare.sql
Maakt topology van het stratenplan. Deze topology is nodig om mee te kunnen rekenen.

> sudo -u postgres psql -d gisdb -f dataTransformation/sql/prepare.sql

Deze topology kun je nu bekijken in QGIS. Maak een aparte PostGIS laag aan, waarbij je koppelt met de database.

# routes.sql
Bepaalt kortste pad naar de werkplaats van elke medewerker volgens algoritme van Dijkstra.
Bekijk daarvoor eerst welk nummer het dichtsbijzijnde kruispunt van de werkplaats heeft gekregen bij de vorige stap en pas dat aan in routes.sql.
Resultaat: /tmp/routes.csv

> sudo -u postgres psql -d gisdb -f dataTransformation/sql/routes.sql

# overlap.sql
Bepaalt de overlap tussen wandelroutes per paar van medewerkers.
Resultaat: /tmp/overlap.csv

> sudo -u postgres psql -d gisdb -f dataTransformation/sql/overlap.sql

# distance.sql
Bepaalt de "geographical distance" per paar van medewerkers.
Resultaat: /tmp/distance.csv

> sudo -u postgres psql -d gisdb -f dataTransformation/sql/distance.sql

# verplaats de resultaten naar de juiste dirs in de repository

> cp /tmp/routes.csv data/constructs/csv/
> cp /tmp/overlap.csv data/constructs/csv/
> cp /tmp/distance.csv data/constructs/csv/
