CREATE VIEW v_wifi_coverage AS
SELECT
  ROW_NUMBER() OVER () AS gid,
  id AS wifi_id,
  ST_Buffer(
    geom::geography,
    coverage_radius_m
  )::geometry(Polygon, 4326) AS geom
FROM city_assets.wifi_public
WHERE coverage_radius_m IS NOT NULL
  AND coverage_radius_m > 0;

CREATE OR REPLACE VIEW public.v_cctv_coverage AS
WITH base AS (
  SELECT
    c.id AS cctv_id,
    c.geom AS center,
    c.coverage_radius_m::double precision AS radius_m,
    radians(c.azimuth_deg::double precision) AS azimuth,
    radians(c.field_of_view_deg::double precision) AS fov,
    c.field_of_view_deg
  FROM city_assets.cctv_cameras c
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




