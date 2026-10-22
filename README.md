# Sela — Cerita Perjalanan

Sela adalah panduan perjalanan lokal yang mengajak pengguna mengenal tempat
dan cerita di baliknya. Desainnya memakai pendekatan editorial yang hangat:
warna bumi, judul bergaya majalah, foto destinasi, dan catatan praktis untuk
menghormati lingkungan serta warga setempat.

## Halaman

- **Beranda** — pilihan redaksi, kategori suasana, pencarian tempat/daerah,
  dan inspirasi perjalanan.
- **Jelajah** — daftar destinasi yang dapat difilter berdasarkan kategori.
- **Disimpan** — tempat yang ditandai untuk rencana perjalanan berikutnya.
- **Detail tempat** — deskripsi, wilayah, waktu kunjungan, dan catatan sebelum
  berangkat.

Navigasi halaman utama menggunakan `NavigationBar`, sedangkan detail tempat
dibuka melalui `Navigator.push`.

## Data dari API

Cuaca terkini yang ditampilkan di beranda dan detail destinasi diambil saat
aplikasi berjalan dari Open-Meteo Forecast API:

```text
https://api.open-meteo.com/v1/forecast
```

Permintaan memakai koordinat destinasi serta parameter `current` untuk suhu,
suhu terasa, kelembapan, kode cuaca WMO, waktu siang/malam, dan kecepatan angin.
API ini dapat digunakan tanpa API key. Antarmuka menampilkan status memuat,
pesan saat permintaan gagal, tombol coba lagi, waktu pengamatan, dan atribusi
sumber data berupa tautan pada kartu. Data cuaca memerlukan koneksi internet.
Penggunaan gratis Open-Meteo ditujukan untuk keperluan nonkomersial, termasuk
kegiatan pendidikan, dan mengikuti [ketentuan penggunaan](https://open-meteo.com/en/terms)
serta [lisensi CC BY 4.0](https://open-meteo.com/en/licence).

## Data destinasi

Pilihan destinasi saat ini merupakan konten kurasi lokal dalam model
`Destination` di `lib/models/destination.dart`, termasuk koordinat yang
digunakan untuk mengambil cuaca. Model cuaca dipisahkan di
`lib/models/weather_forecast.dart`, dan permintaan HTTP ditangani
`lib/services/weather_service.dart` agar sumber data dapat diganti atau
diintegrasikan dengan API destinasi pada pengembangan berikutnya.

Foto contoh dimuat dari Unsplash sehingga memerlukan koneksi internet. Jika
foto tidak dapat dimuat, kartu menampilkan ilustrasi fallback.

## Menjalankan aplikasi

Pastikan Flutter SDK sudah terpasang, lalu jalankan dari direktori proyek:

```sh
flutter pub get
flutter run
```

Jalankan pengujian widget dengan:

```sh
flutter test
```
