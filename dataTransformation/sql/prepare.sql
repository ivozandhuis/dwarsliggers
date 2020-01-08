-- voorwaarden:
-- Software geinstalleerd en adressen en straten ingelezen (zie readme.md)

-- Add "source" and "target" column
ALTER TABLE stratenpatroon1903 ADD COLUMN "source" int4;
ALTER TABLE stratenpatroon1903 ADD COLUMN "target" int4;

-- Run topology function
SELECT pgr_createTopology('stratenpatroon1903', 0.00001, 'geom', 'gid');

-- AnalyzeGraph
SELECT pgr_analyzeGraph('stratenpatroon1903',0.00001,'geom','gid');

-- Check the wrong vertices in QGIS

-- Create Indices
CREATE INDEX source_idx ON stratenpatroon1903("source");
CREATE INDEX target_idx ON stratenpatroon1903("target");

-- Add "len" column
ALTER TABLE stratenpatroon1903 ADD COLUMN "len" float8;

UPDATE stratenpatroon1903
SET len =
(SELECT ST_Length(geom));

-- Add Reverse cost
ALTER TABLE stratenpatroon1903 ADD COLUMN reverse_cost double precision;
UPDATE stratenpatroon1903 SET reverse_cost = len;
