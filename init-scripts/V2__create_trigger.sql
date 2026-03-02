-- Trigger untuk auto-update timestamp
CREATE OR REPLACE FUNCTION infrasrtucture.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Terapkan trigger ke semua tabel
CREATE TRIGGER update_ap_updated_at BEFORE UPDATE ON infrasrtucture.access_points FOR EACH ROW EXECUTE FUNCTION infrasrtucture.update_updated_at_column();
CREATE TRIGGER update_sp_updated_at BEFORE UPDATE ON infrasrtucture.smart_poles FOR EACH ROW EXECUTE FUNCTION infrasrtucture.update_updated_at_column();
CREATE TRIGGER update_mh_updated_at BEFORE UPDATE ON infrasrtucture.manholes FOR EACH ROW EXECUTE FUNCTION infrasrtucture.update_updated_at_column();
CREATE TRIGGER update_tae_updated_at BEFORE UPDATE ON infrasrtucture.telco_active_equipment FOR EACH ROW EXECUTE FUNCTION infrasrtucture.update_updated_at_column();
CREATE TRIGGER update_tower_updated_at BEFORE UPDATE ON infrasrtucture.towers FOR EACH ROW EXECUTE FUNCTION infrasrtucture.update_updated_at_column();
CREATE TRIGGER update_cr_updated_at BEFORE UPDATE ON infrasrtucture.cable_routes FOR EACH ROW EXECUTE FUNCTION infrasrtucture.update_updated_at_column();
CREATE TRIGGER update_cctv_updated_at BEFORE UPDATE ON infrasrtucture.cctv_cameras FOR EACH ROW EXECUTE FUNCTION infrasrtucture.update_updated_at_column();
CREATE TRIGGER update_ek_updated_at BEFORE UPDATE ON infrasrtucture.ekiosks FOR EACH ROW EXECUTE FUNCTION infrasrtucture.update_updated_at_column();