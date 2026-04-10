# GeoSpatial Stack (GeoNode + GeoServer + PostGIS)

Stack ini menyediakan environment sederhana untuk menjalankan:

- GeoPortal menggunakan GeoNode
- GeoServer untuk layanan WMS/WFS
- PostGIS sebagai database spatial
- Nginx sebagai reverse proxy

Komponen yang digunakan:

- GeoNode
- GeoServer
- PostGIS
- Nginx
- Docker Compose

---

# Arsitektur

Internet
↓
Nginx
├── /geonode → GeoNode
└── /geoserver → GeoServer
↓
PostGIS

---

# Struktur Direktori

```
project-root
│
├── docker-compose.yml
├── .env
│
├── data
│   ├── postgis
│   └── geoserver
│
└── nginx
    └── nginx.conf
```

---

# Konfigurasi Environment

File `.env`

```
POSTGRES_DB=oikn
POSTGRES_USER=geoadmin
POSTGRES_PASSWORD=12345

GEOSERVER_PROXY_URL=/geoserver
GEONODE_BASE_URL=/geonode

TZ=Asia/Jakarta
```

Ubah sesuai kebutuhan sebelum menjalankan stack.

---

# Menjalankan Stack

Pastikan Docker dan Docker Compose sudah terinstall.

Menjalankan container:

```
docker compose --env-file .env up -d
```

Melihat status container:

```
docker compose ps
```

Melihat log container:

```
docker compose logs -f
```

---

# Akses Aplikasi

GeoNode

```
http://SERVER_IP/geonode
```

GeoServer

```
http://SERVER_IP/geoserver
```

WMS GetCapabilities

```
http://SERVER_IP/geoserver/wms?request=GetCapabilities
```

---

# Volume Data

Data disimpan pada folder berikut:

PostGIS

```
./data/postgis
```

GeoServer Data Directory

```
./data/geoserver
```

---

# Reverse Proxy

Nginx mengatur routing path:

| Path       | Service   |
| ---------- | --------- |
| /geonode   | GeoNode   |
| /geoserver | GeoServer |

Konfigurasi berada pada:

```
nginx/nginx.conf
```

---

# Menambahkan Domain

Jika nantinya domain sudah tersedia, disarankan:

1. Tambahkan HTTPS di Load Balancer / Reverse Proxy
2. Set PROXY_BASE_URL pada GeoServer
3. Tambahkan server_name pada konfigurasi Nginx

---

# Stop Stack

```
docker compose down
```

---

# Lisensi

Dokumentasi ini bebas digunakan untuk deployment internal maupun pengembangan GeoPortal.
