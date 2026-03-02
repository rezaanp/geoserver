-- LANGKAH 1: Aktifkan extension (hanya sekali)
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;

-- Schema terpusat
CREATE SCHEMA IF NOT EXISTS infrasrtucture AUTHORIZATION geoadmin;

-- ===== TABEL TITIK =====

-- 1. ACCESS POINT
CREATE TABLE infrasrtucture.access_points (
    id SERIAL PRIMARY KEY,
    asset_id VARCHAR(50) UNIQUE NOT NULL,
    geom GEOMETRY(POINT, 4326) NOT NULL,
    location_name VARCHAR(80) NOT NULL,
    persil_number VARCHAR(50),
    deployment_type VARCHAR(20) CHECK (deployment_type IN ('EKSISTING', 'PLAN')),
    
    -- Spesifikasi Teknis
    ssid VARCHAR(100),
    password VARCHAR(100),
    access_type VARCHAR(20) CHECK (access_type IN ('Public', 'Private')),
    bandwidth_mbps INTEGER,
    provider VARCHAR(50),
    ip_address VARCHAR(15),
    placement VARCHAR(80),
    
    -- Geospatial Coverage
    coverage_radius_m INTEGER CHECK (coverage_radius_m > 0),
    azimuth_deg INTEGER CHECK (azimuth_deg BETWEEN 0 AND 360),
    field_of_view_deg INTEGER CHECK (field_of_view_deg BETWEEN 0 AND 360),
    
    -- Manajemen Aset
    serial_number VARCHAR(100),
    status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'MAINTENANCE')),
    description TEXT,
    
    -- Timestamps
    installation_date DATE DEFAULT CURRENT_DATE,
    last_maintenance DATE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_ap_geom ON infrasrtucture.access_points USING GIST(geom);

-- 2. SMART POLE
CREATE TABLE infrasrtucture.smart_poles (
    id SERIAL PRIMARY KEY,
    asset_id VARCHAR(50) UNIQUE NOT NULL,
    geom GEOMETRY(POINT, 4326) NOT NULL,
    location_name VARCHAR(80) NOT NULL,
    persil_number VARCHAR(50),
    deployment_type VARCHAR(20) CHECK (deployment_type IN ('EKSISTING', 'PLAN')),
    
    -- Konektivitas & Jaringan
    provider VARCHAR(50),
    ssid VARCHAR(100),
    password VARCHAR(100),
    bandwidth_mbps INTEGER,
    ip_address VARCHAR(15),
    connection_type VARCHAR(80),
    
    -- Fitur Smart Pole
    camera_type VARCHAR(80),
    stream_url VARCHAR(255),
    has_panic_button BOOLEAN DEFAULT FALSE,
    has_ev_charging BOOLEAN DEFAULT FALSE,
    has_air_sensor BOOLEAN DEFAULT FALSE,
    
    -- Geospatial Coverage
    coverage_radius_m INTEGER CHECK (coverage_radius_m > 0),
    azimuth_deg INTEGER CHECK (azimuth_deg BETWEEN 0 AND 360),
    field_of_view_deg INTEGER CHECK (field_of_view_deg BETWEEN 0 AND 360),
    
    -- Manajemen Aset
    serial_number VARCHAR(100),
    status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'MAINTENANCE')),
    description TEXT,
    
    -- Timestamps
    installation_date DATE DEFAULT CURRENT_DATE,
    last_maintenance DATE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_sp_geom ON infrasrtucture.smart_poles USING GIST(geom);

-- 3. HOLE (Manhole/Handhole)
CREATE TABLE infrasrtucture.manholes (
    id SERIAL PRIMARY KEY,
    asset_id VARCHAR(50) UNIQUE NOT NULL,
    geom GEOMETRY(POINT, 4326) NOT NULL,
    location_name VARCHAR(80) NOT NULL,
    persil_number VARCHAR(50),
    -- Hole biasanya tidak memiliki status plan/eksisting yang kompleks, tapi distandarisasi
    deployment_type VARCHAR(20) CHECK (deployment_type IN ('EKSISTING', 'PLAN')),
    
    -- Spesifikasi Hole
    hole_type VARCHAR(50),
    
    -- Manajemen Aset
    serial_number VARCHAR(100),
    status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'MAINTENANCE')),
    description TEXT,
    
    -- Timestamps
    installation_date DATE DEFAULT CURRENT_DATE,
    last_maintenance DATE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_mh_geom ON infrasrtucture.manholes USING GIST(geom);

-- 4. ALPRO TELCO (ODP/ODC/Closure)
CREATE TABLE infrasrtucture.telco_active_equipment (
    id SERIAL PRIMARY KEY,
    asset_id VARCHAR(50) UNIQUE NOT NULL,
    geom GEOMETRY(POINT, 4326) NOT NULL,
    location_name VARCHAR(80) NOT NULL,
    persil_number VARCHAR(50),
    deployment_type VARCHAR(20) CHECK (deployment_type IN ('EKSISTING', 'PLAN')),
    
    -- Spesifikasi Alat
    equipment_type VARCHAR(50),
    provider VARCHAR(50),
    placement VARCHAR(80),
    
    -- Manajemen Aset
    serial_number VARCHAR(100),
    status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'MAINTENANCE')),
    description TEXT,
    
    -- Timestamps
    installation_date DATE DEFAULT CURRENT_DATE,
    last_maintenance DATE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_tae_geom ON infrasrtucture.telco_active_equipment USING GIST(geom);

-- 5. TOWER
CREATE TABLE infrasrtucture.towers (
    id SERIAL PRIMARY KEY,
    asset_id VARCHAR(50) UNIQUE NOT NULL,
    geom GEOMETRY(POINT, 4326) NOT NULL,
    location_name VARCHAR(80) NOT NULL,
    persil_number VARCHAR(50),
    deployment_type VARCHAR(20) CHECK (deployment_type IN ('EKSISTING', 'PLAN')),
    
    -- Spesifikasi Tower
    owner VARCHAR(50),
    tower_class VARCHAR(20),
    detail_type VARCHAR(50), -- sst, dll
    tenant_info TEXT,
    connection_type VARCHAR(80),
    
    -- Geospatial Coverage
    coverage_radius_m INTEGER CHECK (coverage_radius_m > 0),
    azimuth_deg INTEGER CHECK (azimuth_deg BETWEEN 0 AND 360),
    field_of_view_deg INTEGER CHECK (field_of_view_deg BETWEEN 0 AND 360),
    
    -- Manajemen Aset
    serial_number VARCHAR(100),
    status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'MAINTENANCE')),
    description TEXT,
    
    -- Timestamps
    installation_date DATE DEFAULT CURRENT_DATE,
    last_maintenance DATE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_tower_geom ON infrasrtucture.towers USING GIST(geom);

-- 6. JALUR KABEL (Cable Route)
CREATE TABLE infrasrtucture.cable_routes (
    id SERIAL PRIMARY KEY,
    asset_id VARCHAR(50) UNIQUE NOT NULL,
    geom GEOMETRY(LINESTRING, 4326) NOT NULL,
    location_name VARCHAR(80) NOT NULL, -- Nama Rute
    persil_number VARCHAR(50),
    deployment_type VARCHAR(20) CHECK (deployment_type IN ('EKSISTING', 'PLAN')),
    
    -- Spesifikasi Kabel
    cable_medium VARCHAR(20),
    strand_count INTEGER, -- Pair (cooper) atau Core (optic)
    provider VARCHAR(50),
    installation_method VARCHAR(80), -- Jenis Instalasi
    start_point VARCHAR(100),
    end_point VARCHAR(100),
    
    -- Manajemen Aset
    serial_number VARCHAR(100),
    status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'MAINTENANCE')),
    description TEXT,
    
    -- Timestamps
    installation_date DATE DEFAULT CURRENT_DATE,
    last_maintenance DATE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_cr_geom ON infrasrtucture.cable_routes USING GIST(geom);

-- 7. CCTV (Disesuaikan dengan input atribut + Standar DDL)
CREATE TABLE infrasrtucture.cctv_cameras (
    id SERIAL PRIMARY KEY,
    asset_id VARCHAR(50) UNIQUE NOT NULL,
    geom GEOMETRY(POINT, 4326) NOT NULL,
    location_name VARCHAR(80) NOT NULL,
    persil_number VARCHAR(50),
    deployment_type VARCHAR(20) CHECK (deployment_type IN ('EKSISTING', 'PLAN')),
    
    camera_type VARCHAR(80) NOT NULL,
    power_source VARCHAR(80),
    connection_type VARCHAR(80),
    placement VARCHAR(80),
    ip_address VARCHAR(15),
    owner VARCHAR(50),
    url VARCHAR(255),
    
    coverage_radius_m INTEGER CHECK (coverage_radius_m > 0),
    azimuth_deg INTEGER CHECK (azimuth_deg BETWEEN 0 AND 360),
    field_of_view_deg INTEGER CHECK (field_of_view_deg BETWEEN 0 AND 360),
    
    serial_number VARCHAR(100),
    status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'MAINTENANCE')),
    description TEXT, -- Keterangan
    
    installation_date DATE DEFAULT CURRENT_DATE,
    last_maintenance DATE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_cctv_geom ON infrasrtucture.cctv_cameras USING GIST(geom);