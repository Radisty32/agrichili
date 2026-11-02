# Product Requirements Document (PRD)
## Aplikasi Monitoring Kelembaban Tanah & Kontrol Irigasi Berbasis IoT pada Budidaya Cabai Merah

| | |
|---|---|
| **Nama Produk** | AgriChili Monitor |
| **Platform** | Flutter (Android & iOS) |
| **Versi Dokumen** | 2.0 (Updated) |
| **Tanggal** | 2 November 2026 |
| **Status** | Active / Updated |

---

## 1. Latar Belakang

Budidaya cabai merah (*Capsicum annuum L.*) sangat sensitif terhadap kadar air zona perakaran. Kekurangan air menyebabkan kerontokan bunga dan buah, sementara kelebihan air memicu pembusukan akar (*Phytophthora capsici*). Pemantauan kelembaban tanah yang dilakukan secara manual atau perkiraan visual sering kali tidak akurat dan tidak efisien. 

Dengan memanfaatkan sensor kelembaban tanah kapasitif (*Capacitive Soil Moisture Sensor*) yang terhubung ke mikrokontroler ESP32 dan katup solenoid irigasi, kondisi air tanah (*Volumetric Water Content / VWC*) dapat dipantau secara real-time dan dikontrol secara otomatis/manual melalui aplikasi mobile berbasis Flutter.

---

## 2. Tujuan Produk

1. **Pemantauan Presisi Real-Time**: Memberikan kemudahan bagi petani untuk memantau kelembaban tanah zona perakaran secara real-time (interval 10 detik).
2. **Peringatan Ambang Batas (Early Warning)**: Mengirimkan push notifikasi saat kadar air tanah berada di luar zona aman (misal < 60% kering atau > 80% jenuh).
3. **Analisis Historis**: Menyediakan riwayat fluktuasi kelembaban tanah, log telemetri per jam, dan ekspor data audit (CSV/Excel).
4. **Otomatisasi Irigasi Tetes**: Mendukung kontrol pompa irigasi otomatis berbasis batas kelembaban serta kontrol siram cepat manual.

---

## 3. Target Pengguna

- Petani cabai merah (greenhouse dan lahan terbuka)
- Pengelola greenhouse & instalasi irigasi tetes (*drip irrigation*)
- Praktisi pertanian presisi (*precision agriculture*)
- Penyuluh & peneliti agronomi

---

## 4. Ruang Lingkup (Scope)

### Termasuk (In-Scope)
- Aplikasi mobile Flutter (Android & iOS).
- Integrasi perangkat IoT (Node mikrokontroler ESP32 + Capacitive Soil Moisture Sensor).
- Kontrol relay pompa irigasi (otomatis berbasis sensor dan pemicu manual 2, 3, 5, 10 menit).
- Dashboard monitoring kelembaban tanah real-time & gauge status.
- Grafik fluktuasi kelembaban tanah 7 hari dengan batas zona aman (60% - 80%).
- Pengaturan ambang batas kelembaban tanah sesuai fase umur cabai.
- Log telemetri per jam dan ekspor laporan (CSV / Excel .xlsx).
- Notifikasi darurat via Firebase Cloud Messaging (FCM).

### Tidak Termasuk (Out of Scope)
- Monitoring sensor suhu udara mikroklimat dan kelembaban udara ambient (fokus murni zona perakaran).
- Widget cuaca eksternal API.
- Rekomendasi agronomis AI generatif text.
- Banner panduan statis Balitbangtan.
- Grafik multi-garis komparasi cuaca 6 jam.

---

## 5. Daftar Fitur

### 5.1 Fitur Utama (Must Have)

| No | Fitur | Deskripsi |
|----|-------|-----------|
| 1 | **Dashboard Monitoring Kelembaban Tanah** | Menampilkan metrik real-time kelembaban tanah (VWC %), status optimal/kering/jenuh, dan progress bar target zona aman. |
| 2 | **Status Perangkat ESP32** | Menampilkan status koneksi online/offline node ESP32, kualitas sinyal RSSI (-64 dBm), tegangan baterai (solar assisted), dan waktu sinkronisasi. |
| 3 | **Pemantauan Multi-Blok Lahan** | Ringkasan kondisi kelembaban tanah pada seluruh blok aktif (Blok A Greenhouse, Blok B Lahan Terbuka, Blok C Pembibitan). |
| 4 | **Detail Sensor & Speedometer Gauge** | Tampilan visual semi-sirkular arc gauge (*speedometer*) dengan 3 zona warna (<60% Kering, 60-80% Ideal, >80% Jenuh) dan jarum penunjuk akurat. |
| 5 | **Kontrol Relay Pompa Irigasi** | Kontrol aktuator pompa irigasi tetes: tombol *Siram Cepat 3 Menit* di Beranda, saklar otomatis berbasis ambang batas, opsi durasi (2, 5, 10 menit), dan tombol *Nyalakan Manual Irigasi*. |
| 6 | **Grafik Fluktuasi Kelembaban 7 Hari** | Grafik kurva halus fluktuasi kelembaban tanah dengan visualisasi shading zona aman (60-80%), penanda event irigasi, dan deteksi kritis. |
| 7 | **Statistik Periode 7 Hari** | Ringkasan statistik 4 metrik: Rata-rata (%), Nilai Tertinggi, Nilai Terendah, dan Durasi di Luar Batas (jam/menit). |
| 8 | **Log Telemetri Per Jam** | Tabel riwayat sensor terverifikasi MQTT gateway per jam beserta label status (*Normal*, *Irigasi*, *Peringatan*). |
| 9 | **Pengaturan Ambang Batas (Threshold)** | Kalibrasi batas bawah dan batas atas toleransi kelembaban tanah menggunakan interactive `RangeSlider` lengkap dengan fitur *Reset Default*. |
| 10 | **Preset Fase Budidaya Cabai** | Pilihan tahapan fase tanaman cabai yang otomatis menyesuaikan nilai target kelembaban tanah:<br>• **Fase Vegetatif (1 - 30 HST)**: Target 60% - 75%<br>• **Fase Generatif / Berbunga (> 31 HST)**: Target 65% - 80%<br>• **Pematangan Buah & Panen (> 80 HST)**: Target 55% - 70% |
| 11 | **Logika Otomatisasi & Fail-Safe** | Konfigurasi durasi siram per siklus (stepper menit), jeda cooldown peresapan tanah (stepper menit), dan fitur proteksi fail-safe cut-off. |
| 12 | **Notifikasi Peringatan Darurat** | Saklar notifikasi Firebase dan opsi frekuensi peringatan jika kelembaban tanah keluar dari batas aman. |
| 13 | **Ekspor Laporan Telemetri** | Unduh laporan data mentah dan riwayat penyiraman dalam format **CSV** dan **Excel (.xlsx)**. |

---

## 6. Arsitektur Sistem (Gambaran Umum)

```
[Capacitive Soil Moisture Sensor]
                 │
                 ▼ (ADC / Analog Read)
          [Node ESP32] ── WiFi / MQTT ──▶ [Cloud / MQTT Broker (HiveMQ/Firebase)]
                 │                                        │
           (Relay Output)                                 ▼
     [Solenoid / Pompa Irigasi]                 [Aplikasi Flutter]
```

- **Perangkat IoT**: Mikrokontroler ESP32 Dual-Core (Firmware v2.4.x), baterai 3.9V dengan pengisian solar cell panel.
- **Sensor**: Capacitive Soil Moisture Sensor (tahan korosi) yang ditanam pada kedalaman zona perakaran cabai (10-15 cm).
- **Aktuator**: Modul relay 5V/12V pengendali katup solenoid pipa irigasi tetes.
- **Komunikasi Data**: Protokol MQTT publish/subscribe ke broker dengan frekuensi telemetri 10 detik.
- **Aplikasi Frontend**: Flutter dengan Material 3 theme agrikultur, CustomPainter untuk arc gauge & smooth line chart, serta 4-tab bottom navigation.

---

## 7. Struktur Layar Aplikasi (Navigation Map)

Aplikasi menggunakan **Bottom Navigation Bar** 4 tab:

1. **Tab 1: Beranda**
   - Header aplikasi & notifikasi
   - Banner status ESP32 (Online, RSSI, Baterai, Waktu Sinkronisasi)
   - Selector zona monitoring aktif
   - Kartu telemetri real-time: **Kelembaban Tanah (68%)** dengan progress bar target aman
   - Quick action: **Pompa Irigasi Tetes (Tombol Siram Cepat 3 Menit)**
   - Pemantauan seluruh blok lahan aktif (Blok A, B, C)

2. **Tab 2: Sensor (Detail Lahan & Sensor)**
   - Status node mikrokontroler (`ESP32-NODE-01`)
   - Speedometer Arc Gauge Kelembaban Tanah Riil (VWC %) dengan 3 zona warna & jarum penunjuk
   - Panel kontrol relay pompa irigasi: saklar otomatis, pilihan durasi (2, 5, 10 menit), tombol manual irigasi, serta indikator *Dry-Run Protection* dan tekanan air

3. **Tab 3: Riwayat (Riwayat & Analitik Telemetri)**
   - Filter rentang waktu (*Hari Ini*, *7 Hari*, *30 Hari*, *Kustom*)
   - Grafik fluktuasi kelembaban tanah 7 hari dengan safe-zone band & alert deteksi kritis
   - Kartu statistik 4 metrik periode 7 hari (rata-rata, tertinggi, terendah, durasi di luar batas)
   - Log telemetri per jam terverifikasi MQTT
   - Tombol unduh laporan (*CSV* dan *Excel .xlsx*)

4. **Tab 4: Sistem (Pengaturan Ambang Batas)**
   - Selector preset fase budidaya cabai (*Vegetatif*, *Generatif*, *Panen*)
   - RangeSlider kalibrasi batas toleransi kelembaban tanah & tombol *Reset Default*
   - Konfigurasi logika otomatisasi pompa, durasi siram, dan jeda cooldown
   - Pengaturan notifikasi darurat via Firebase Cloud
   - Tombol simpan pengaturan ambang batas (sinkronisasi via MQTT)

---

## 8. Kebutuhan Non-Fungsional

| Aspek | Kebutuhan |
|-------|-----------|
| **Responsivitas UI** | Tampilan fleksibel dan bebas overflow (`RenderFlex error-free`) pada berbagai dimensi layar HP (termasuk layar resolusi sempit <= 320px). |
| **Kecepatan Data** | Latensi penerimaan data telemetri real-time < 10 detik. |
| **Keandalan Aktuator** | Fitur fail-safe cut-off otomatis jika perangkat IoT offline lebih dari 10 menit saat pompa menyala. |
| **Kemudahan Penggunaan** | Desain antarmuka bersih (*clean agricultural emerald theme*) dengan hierarki informasi yang jelas bagi petani. |

---

## 9. Komponen Perangkat Keras yang Dibutuhkan

| Komponen | Spesifikasi / Tipe |
|----------|-------------------|
| Mikrokontroler | ESP32 NodeMCU / WROOM-32 Dual Core |
| Sensor Tanah | Capacitive Soil Moisture Sensor v1.2 / RS485 Industrial Probe |
| Modul Relay | 1-Channel Relay Optocoupler 5V / 12V |
| Aktuator Irigasi | Katup Solenoid 12V DC / Pompa Air DC 12V |
| Daya | Baterai Li-ion 18650 3.7V - 4.2V + Solar Panel & TP4056 / Solar Charger Controller |
| Sensor Suhu/Udara | *(Dihapus dari kebutuhan proyek)* |

