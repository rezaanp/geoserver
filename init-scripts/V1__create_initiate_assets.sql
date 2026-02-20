-- LANGKAH 1: Aktifkan extension (hanya sekali)
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;

-- Schema terpusat
CREATE SCHEMA IF NOT EXISTS city_assets AUTHORIZATION geoadmin;

-- ===== TABEL TITIK =====

-- E-Kiosk
CREATE TABLE city_assets.ekiosks (
    id SERIAL PRIMARY KEY,
    asset_id VARCHAR(50) UNIQUE NOT NULL,
    geom GEOMETRY(POINT, 4326) NOT NULL,
    location_name VARCHAR(80) NOT NULL, 
    connection_type VARCHAR(30),
    owner VARCHAR(30),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'maintenance')),
    installation_date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_ekiosks_geom ON city_assets.ekiosks USING GIST(geom);

-- WiFi Public (dengan radius dinamis)
CREATE TABLE city_assets.wifi_public (
    id SERIAL PRIMARY KEY,
    asset_id VARCHAR(50) UNIQUE NOT NULL,
    geom GEOMETRY(POINT, 4326) NOT NULL,
    location_name VARCHAR(80) NOT NULL, 
    bandwidth VARCHAR(30),
    ssid VARCHAR(30) NOT NULL,
    password VARCHAR(30),
    coverage_radius_m INTEGER CHECK (coverage_radius_m > 0), 
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'maintenance')),
    installation_date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_wifi_public_geom ON city_assets.wifi_public USING GIST(geom);

-- CCTV
CREATE TABLE city_assets.cctv_cameras (
    id SERIAL PRIMARY KEY,
    asset_id VARCHAR(50) UNIQUE NOT NULL,
    geom GEOMETRY(POINT, 4326) NOT NULL,
    location_name VARCHAR(80) NOT NULL,         
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
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'maintenance')),
    installation_date DATE DEFAULT CURRENT_DATE,
    last_maintenance DATE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_cctv_geom ON city_assets.cctv_cameras USING GIST(geom);