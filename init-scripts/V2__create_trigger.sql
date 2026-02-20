-- Trigger untuk auto-update timestamp
CREATE OR REPLACE FUNCTION city_assets.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_ekiosks_update BEFORE UPDATE ON city_assets.ekiosks
  FOR EACH ROW EXECUTE FUNCTION city_assets.update_updated_at_column();

CREATE TRIGGER trg_wifi_update BEFORE UPDATE ON city_assets.wifi_public
  FOR EACH ROW EXECUTE FUNCTION city_assets.update_updated_at_column();

CREATE TRIGGER trg_cctv_update BEFORE UPDATE ON city_assets.cctv_cameras
  FOR EACH ROW EXECUTE FUNCTION city_assets.update_updated_at_column();