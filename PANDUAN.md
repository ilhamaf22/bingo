# Undian 1–25 — panduan pasang (Supabase + Vercel/Netlify)

## Isi folder
- `index.html` — aplikasi (Tahap 1, Tahap 2, Admin, Riwayat)
- `supabase-setup.sql` — membuat tabel, aturan akses, dan realtime
- `vercel.json` / `_redirects` — supaya alamat `/riwayat` bisa dibuka (Vercel / Netlify)

## 1. Siapkan Supabase
1. Buat project (atau pakai yang sudah ada).
2. **SQL Editor → New query**, tempel isi `supabase-setup.sql`, lalu **Run**.
3. **Authentication → Users → Add user → Create new user**: buat akun admin (email + kata sandi), centang *Auto Confirm User*.
4. **Authentication → Sign In / Providers**: matikan **Allow new users to sign up**.
   Penting: kalau tidak dimatikan, siapa pun bisa mendaftar sendiri dan ikut mengubah riwayat.

## 2. Isi kunci di index.html
Di **Project Settings → API**, salin *Project URL* dan *anon public key*, lalu isi di bagian atas `<script>`:
```js
var SUPABASE_URL = 'https://xxxx.supabase.co';
var SUPABASE_ANON_KEY = 'eyJhbGciOi...';
```
Anon key memang aman ditaruh di halaman; yang menjaga data adalah aturan RLS dari file SQL.
Jangan pernah memakai `service_role` key di sini.

## 3. Deploy
- **Vercel**: upload folder ini sebagai project baru (Framework: Other). `vercel.json` sudah mengatur `/riwayat`.
- **Netlify**: drag-and-drop folder ini. `_redirects` sudah mengatur `/riwayat`.

## Alamat
- `https://domain-anda/` — panitia, wajib login
- `https://domain-anda/riwayat` — penonton, tanpa login, berubah otomatis

## Catatan
- Undian berjalan di browser panitia lalu dikirim ke server. Pakai satu perangkat operator saja.
- Soal upload Tahap 2 hanya tersimpan di browser operator (tidak dikirim ke server), jadi upload di perangkat yang dipakai untuk mengundi.
- Jawaban Tahap 2 tampil "?" di /riwayat sampai panitia menekan **Lihat Jawaban**.
