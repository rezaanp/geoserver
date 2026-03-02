-- 1. VIEW COVERAGE ACCESS POINT
CREATE OR REPLACE VIEW infrasrtucture.v_access_points_coverage AS
WITH base AS (
  SELECT
    ap.id AS ap_id,
    ap.geom AS center,
    ap.coverage_radius_m::double precision AS radius_m,
    radians(ap.azimuth_deg::double precision) AS azimuth,
    radians(ap.field_of_view_deg::double precision) AS fov,
    ap.field_of_view_deg
  FROM infrasrtucture.access_points ap
  WHERE
    ap.geom IS NOT NULL
    AND ap.coverage_radius_m > 0
    AND ap.field_of_view_deg > 0
),
circle AS (
  SELECT
    ap_id,
    ST_Buffer(
      center::geography,
      radius_m
    )::geometry(MultiPolygon,4326) AS geom
  FROM base
  WHERE field_of_view_deg >= 360
),
angles AS (
  SELECT
    ap_id,
    center,
    radius_m,
    azimuth,
    fov,
    generate_series(
      (azimuth - fov / 2)::numeric,
      (azimuth + fov / 2)::numeric,
      GREATEST((fov / 16.0)::numeric, radians(1)::numeric)
    )::double precision AS angle
  FROM base
  WHERE field_of_view_deg < 360
),
arc_points AS (
  SELECT
    ap_id,
    center,
    ST_Project(
      center::geography,
      radius_m,
      angle
    )::geometry AS geom,
    angle
  FROM angles
),
sector AS (
  SELECT
    ap_id,
    ST_MakePolygon(
      ST_MakeLine(
        ARRAY[
          center
        ] || ARRAY_AGG(geom ORDER BY angle) || ARRAY[
          center
        ]
      )
    ) AS geom
  FROM arc_points
  GROUP BY ap_id, center
)
SELECT
  row_number() OVER () AS gid,
  ap_id,
  ST_CollectionExtract(
    ST_MakeValid(geom),
    3
  )::geometry(MultiPolygon,4326) AS geom
FROM (
  SELECT * FROM circle
  UNION ALL
  SELECT * FROM sector
) g
WHERE geom IS NOT NULL;

-- 2. VIEW COVERAGE SMART POLE
CREATE OR REPLACE VIEW infrasrtucture.v_smart_poles_coverage AS
WITH base AS (
  SELECT
    sp.id AS sp_id,
    sp.geom AS center,
    sp.coverage_radius_m::double precision AS radius_m,
    radians(sp.azimuth_deg::double precision) AS azimuth,
    radians(sp.field_of_view_deg::double precision) AS fov,
    sp.field_of_view_deg
  FROM infrasrtucture.smart_poles sp
  WHERE
    sp.geom IS NOT NULL
    AND sp.coverage_radius_m > 0
    AND sp.field_of_view_deg > 0
),
circle AS (
  SELECT
    sp_id,
    ST_Buffer(
      center::geography,
      radius_m
    )::geometry(MultiPolygon,4326) AS geom
  FROM base
  WHERE field_of_view_deg >= 360
),
angles AS (
  SELECT
    sp_id,
    center,
    radius_m,
    azimuth,
    fov,
    generate_series(
      (azimuth - fov / 2)::numeric,
      (azimuth + fov / 2)::numeric,
      GREATEST((fov / 16.0)::numeric, radians(1)::numeric)
    )::double precision AS angle
  FROM base
  WHERE field_of_view_deg < 360
),
arc_points AS (
  SELECT
    sp_id,
    center,
    ST_Project(
      center::geography,
      radius_m,
      angle
    )::geometry AS geom,
    angle
  FROM angles
),
sector AS (
  SELECT
    sp_id,
    ST_MakePolygon(
      ST_MakeLine(
        ARRAY[
          center
        ] || ARRAY_AGG(geom ORDER BY angle) || ARRAY[
          center
        ]
      )
    ) AS geom
  FROM arc_points
  GROUP BY sp_id, center
)
SELECT
  row_number() OVER () AS gid,
  sp_id,
  ST_CollectionExtract(
    ST_MakeValid(geom),
    3
  )::geometry(MultiPolygon,4326) AS geom
FROM (
  SELECT * FROM circle
  UNION ALL
  SELECT * FROM sector
) g
WHERE geom IS NOT NULL;

-- 3. VIEW COVERAGE TOWER
CREATE OR REPLACE VIEW infrasrtucture.v_towers_coverage AS
WITH base AS (
  SELECT
    t.id AS tower_id,
    t.geom AS center,
    t.coverage_radius_m::double precision AS radius_m,
    radians(t.azimuth_deg::double precision) AS azimuth,
    radians(t.field_of_view_deg::double precision) AS fov,
    t.field_of_view_deg
  FROM infrasrtucture.towers t
  WHERE
    t.geom IS NOT NULL
    AND t.coverage_radius_m > 0
    AND t.field_of_view_deg > 0
),
circle AS (
  SELECT
    tower_id,
    ST_Buffer(
      center::geography,
      radius_m
    )::geometry(MultiPolygon,4326) AS geom
  FROM base
  WHERE field_of_view_deg >= 360
),
angles AS (
  SELECT
    tower_id,
    center,
    radius_m,
    azimuth,
    fov,
    generate_series(
      (azimuth - fov / 2)::numeric,
      (azimuth + fov / 2)::numeric,
      GREATEST((fov / 16.0)::numeric, radians(1)::numeric)
    )::double precision AS angle
  FROM base
  WHERE field_of_view_deg < 360
),
arc_points AS (
  SELECT
    tower_id,
    center,
    ST_Project(
      center::geography,
      radius_m,
      angle
    )::geometry AS geom,
    angle
  FROM angles
),
sector AS (
  SELECT
    tower_id,
    ST_MakePolygon(
      ST_MakeLine(
        ARRAY[
          center
        ] || ARRAY_AGG(geom ORDER BY angle) || ARRAY[
          center
        ]
      )
    ) AS geom
  FROM arc_points
  GROUP BY tower_id, center
)
SELECT
  row_number() OVER () AS gid,
  tower_id,
  ST_CollectionExtract(
    ST_MakeValid(geom),
    3
  )::geometry(MultiPolygon,4326) AS geom
FROM (
  SELECT * FROM circle
  UNION ALL
  SELECT * FROM sector
) g
WHERE geom IS NOT NULL;

-- 4. VIEW COVERAGE CCTV (Disesuaikan agar konsisten dengan view lainnya)
CREATE OR REPLACE VIEW infrasrtucture.v_cctv_coverage AS
WITH base AS (
  SELECT
    c.id AS cctv_id,
    c.geom AS center,
    c.coverage_radius_m::double precision AS radius_m,
    radians(c.azimuth_deg::double precision) AS azimuth,
    radians(c.field_of_view_deg::double precision) AS fov,
    c.field_of_view_deg
  FROM infrasrtucture.cctv_cameras c
  WHERE
    c.geom IS NOT NULL
    AND c.coverage_radius_m > 0
    AND c.field_of_view_deg > 0
),
circle AS (
  SELECT
    cctv_id,
    ST_Buffer(
      center::geography,
      radius_m
    )::geometry(MultiPolygon,4326) AS geom
  FROM base
  WHERE field_of_view_deg >= 360
),
angles AS (
  SELECT
    cctv_id,
    center,
    radius_m,
    azimuth,
    fov,
    generate_series(
      (azimuth - fov / 2)::numeric,
      (azimuth + fov / 2)::numeric,
      GREATEST((fov / 16.0)::numeric, radians(1)::numeric)
    )::double precision AS angle
  FROM base
  WHERE field_of_view_deg < 360
),
arc_points AS (
  SELECT
    cctv_id,
    center,
    ST_Project(
      center::geography,
      radius_m,
      angle
    )::geometry AS geom,
    angle
  FROM angles
),
sector AS (
  SELECT
    cctv_id,
    ST_MakePolygon(
      ST_MakeLine(
        ARRAY[
          center
        ] || ARRAY_AGG(geom ORDER BY angle) || ARRAY[
          center
        ]
      )
    ) AS geom
  FROM arc_points
  GROUP BY cctv_id, center
)
SELECT
  row_number() OVER () AS gid,
  cctv_id,
  ST_CollectionExtract(
    ST_MakeValid(geom),
    3
  )::geometry(MultiPolygon,4326) AS geom
FROM (
  SELECT * FROM circle
  UNION ALL
  SELECT * FROM sector
) g
WHERE geom IS NOT NULL;