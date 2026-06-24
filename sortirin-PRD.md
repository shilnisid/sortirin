# Sortirin — Product Requirements Document

**Versi**: 1.0.0 | **Status**: Draft | **Tanggal**: Mei 2026
**Author**: Muhammad | **Platform**: Android + iOS (Flutter)

---

## 1. Ringkasan Produk

**Sortirin** adalah aplikasi mobile gamifikasi pemilahan sampah berbasis reward nyata. Pengguna merekam video proses pembuangan sampah sesuai jenisnya langsung dari kamera in-app, AI memvalidasi kebenaran pemilahan, dan pengguna mendapatkan poin yang bisa ditukar dengan reward nyata (GoPay, kuota internet, token PLN, voucher minimarket).

> **Tagline**: *"Yuk, sortirin sampahmu — dapat poin, jaga bumi."*

---

## 2. Latar Belakang & Masalah

Indonesia menghasilkan ±68 juta ton sampah per tahun (KLHK 2025), dengan tingkat pemilahan di sumber di bawah 10%. Kampanye pemerintah semakin gencar pasca regulasi pemilahan sampah 2024, namun mayoritas masyarakat masih kurang memiliki insentif langsung untuk berubah perilaku.

**Gap utama yang Sortirin isi:**

| Masalah | Solusi Sortirin |
|---|---|
| Tidak ada insentif langsung | Reward nyata (GoPay, kuota, PLN) |
| Kurang tahu cara pilah yang benar | AI feedback + edukasi per jenis sampah |
| Tidak ada pembuktian aksi | Video sebagai bukti yang tervalidasi AI |
| Kampanye terasa top-down | Gamifikasi peer-to-peer & leaderboard komunitas |
| Tidak tahu dampak aksi sendiri | Dashboard dampak lingkungan per user |

---

## 3. Target Pengguna

### Primary — "Si Aktif Sadar Lingkungan"
- Usia 15–35 tahun, smartphone-native
- Tinggal di perkotaan/suburban (Jakarta, Surabaya, Bandung, Medan, Makassar)
- Aware isu lingkungan, tapi butuh motivasi ekstra untuk konsisten
- Termotivasi oleh reward nyata dan pengakuan sosial (leaderboard)

### Secondary — "Ibu Rumah Tangga Pragmatis"
- Usia 30–50 tahun
- Pengelola sampah rumah tangga
- Termotivasi oleh token PLN dan voucher belanja
- Rekrut via komunitas PKK, Dasawisma, grup WhatsApp RT

### Tertiary — "Komunitas & Institusi"
- Bank sampah, KSM, relawan lingkungan
- Program lingkungan kampus/sekolah
- Korporasi yang butuh laporan CSR terukur

---

## 4. Tujuan Produk

### Tujuan Bisnis
- Mencapai 10.000 MAU dalam 3 bulan pertama pasca-launch
- Mencapai break-even operasional via CSR sponsorship dalam 6 bulan
- Menjadi referensi data pemilahan sampah untuk pemda/NGO dalam 12 bulan

### Tujuan Pengguna
- Pengguna mendapat reward nyata dari perilaku yang sudah semestinya dilakukan
- Pengguna belajar cara pemilahan sampah yang benar secara organik
- Pengguna merasa berkontribusi nyata terhadap lingkungan dengan data dampak yang terukur

---

## 5. Fitur Core — MVP (v1.0)

### F01 — Autentikasi & Profil
- Google Sign-In via Supabase OAuth
- Profil: nama, foto, kota, kelurahan/kecamatan
- Nomor HP wajib diisi sebelum pertama kali redeem (untuk disbursement)
- Verifikasi nomor HP via OTP sebelum redemption pertama

**User stories:**
- Sebagai pengguna baru, saya ingin daftar dengan Google dalam satu tap
- Sebagai pengguna, saya ingin melengkapi profil saya sebelum mulai memilah
- Sebagai pengguna, saya ingin melihat ringkasan aktivitas saya di halaman profil

---

### F02 — Rekam & Submit Sampah *(Core feature)*
- Kamera in-app ONLY — akses gallery diblokir secara eksplisit
- Alur: Pilih jenis sampah → Rekam video (5–30 detik) → Review → Submit
- Embed di metadata: GPS coordinate, timestamp Unix, SHA-256 hash, device fingerprint
- Pilih hingga 5 jenis sampah berbeda dalam satu submission (multi-item)
- Input jumlah item per jenis (stepper: 1–99)
- Compression client-side sebelum upload (max 50 MB per video)
- Upload status: idle → compressing → uploading → pending_review
- Anti-cheat: tolak otomatis jika hash video sudah pernah ada di DB

**User stories:**
- Sebagai pengguna, saya ingin merekam video membuang sampah langsung dari kamera app
- Sebagai pengguna, saya ingin memilih beberapa jenis sampah sekaligus dalam satu video
- Sebagai pengguna, saya ingin mendapat feedback jika submission saya ditolak beserta alasannya
- Sebagai pengguna, saya ingin tahu status submission saya secara real-time

---

### F03 — AI Validation Pipeline
- Model: Nemotron-3-Nano-Omni-30B-A3B via NVIDIA NIM API
- Frame sampling: 1 FPS, maks 15 frame per video
- Threshold auto-approve: confidence ≥ 80%
- Threshold human review: confidence 65–79%
- Auto-reject: confidence < 65% ATAU deteksi konten tidak pantas
- Waktu validasi target: < 30 detik (async, notifikasi push)
- Video dihapus dari Storage setelah 12 jam via pg_cron, lepas dari status
- Simpan permanen: SHA-256 hash, metadata GPS, thumbnail frame ke-1

**Kriteria validasi AI:**
1. Apakah objek yang dibuang teridentifikasi?
2. Apakah jenis sampah sesuai dengan yang dipilih user?
3. Apakah tempat sampah/wadah terlihat sesuai kategori?
4. Apakah video tidak di-screen-record dari video lain?

---

### F04 — Sistem Poin & Streak
**Formula:**
```
Total Poin = (Σ Base_Poin × Q_Multiplier + Variety_Bonus + Discovery_Bonus)
             × Streak_Multiplier × AI_Confidence_Multiplier
```

**Base poin per jenis:**
| Jenis | Poin/item |
|---|---|
| Organik | 5 |
| Kertas/kardus | 8 |
| Plastik lunak | 10 |
| Plastik keras/PET | 12 |
| Kaca/beling | 12 |
| Logam/kaleng | 15 |
| Tekstil | 10 |
| B3 ringan (baterai) | 25 |
| B3 berat (elektronik, lampu TL) | 40 |
| Residu | 3 |

**Multiplier & bonus:**
- Quantity: 1–3 item (1.0×) / 4–7 (1.2×) / 8–15 (1.5×) / 16–30 (1.75×) / 31+ (2.0×)
- Variety: 1 jenis (+0) / 2 (+10) / 3 (+25) / 4 (+45) / 5+ (+70)
- Discovery: +20 per jenis sampah yang pertama kali dipilah
- Streak: 1–6 hari (1.0×) / 7–13 (1.25×) / 14–29 (1.5×) / 30–89 (1.75×) / 90+ (2.0×)
- AI Confidence: ≥95% (1.1×) / 80–94% (1.0×) / 65–79% (0.9×) / <65% (0.8×)
- Soft cap: maks 500 poin/hari per user (anti-farming)

**Streak rules:**
- Streak terhitung jika ada minimal 1 submission approved per hari (00:00–23:59 WIB)
- Streak grace period: 1 hari (jika missed, streak tidak langsung reset ke 0 tapi freeze 24 jam)
- Weekend bonus: +8 poin flat per submission di Sabtu/Minggu

---

### F05 — Badge & Achievement
**Kategori badge:**
- **Pemula**: Submission pertama, Lengkapi profil, Streak 7 hari
- **Explorer**: Pertama kali pilah setiap jenis sampah (10 badge individual)
- **Konsistensi**: Streak 30 hari, 60 hari, 90 hari, 180 hari, 365 hari
- **Volume**: Total 50, 200, 500, 1.000, 5.000 item terpilah
- **Impact**: Total poin 10K, 50K, 100K, 500K
- **Komunitas**: Top 10 leaderboard kota, Top 1 leaderboard kelurahan
- **B3 Hero**: Khusus pemilah B3 terbanyak (baterai, elektronik)

---

### F06 — Reward Catalog & Redemption
- Provider e-wallet: **Flip for Business** (GoPay, OVO, DANA, bank transfer)
- Provider pulsa/kuota/PLN: **Digiflazz**
- Provider voucher: **Tripay** (Indomaret, Alfamart)

**Tier reward:**
| Poin | Reward | Value |
|---|---|---|
| 5.000 | GoPay / OVO / DANA | Rp 5.000 |
| 10.000 | Kuota internet 1 GB | Rp 10.000 |
| 10.000 | Token listrik PLN | Rp 10.000 |
| 15.000 | Voucher Indomaret/Alfamart | Rp 15.000 |
| 25.000 | Diamond ML / Garena Shell | Rp 25.000 |
| 50.000 | Voucher Shopee/Tokopedia | Rp 50.000 |
| 100.000 | GoPay / e-wallet premium | Rp 100.000 |

**Flow redemption:**
1. User pilih reward → konfirmasi poin & nomor tujuan → OTP verifikasi
2. Edge Function panggil API provider
3. Status: pending → processing → completed/failed
4. Notifikasi push + in-app setelah selesai
5. Poin terpotong di ledger setelah completed (bukan saat request)

---

### F07 — Leaderboard
- Scope: Nasional / Kota / Kelurahan / Teman (follow system)
- Period: Bulanan (reset tiap tanggal 1) + All-time
- Real-time via Supabase Realtime
- Tampilkan: rank, avatar, nama, kota, total poin periode
- Hall of Fame: top 3 setiap bulan diabadikan
- Posisi user selalu terlihat meski di luar top 50

---

### F08 — Dashboard & Dampak Lingkungan
- Summary: total poin, streak aktif, rank nasional
- Grafik aktivitas 30 hari
- Impact metrics: total item terpilah, estimasi CO₂ dihemat (berdasarkan faktor emisi per kategori), setara berapa pohon
- Riwayat submission (status, poin, thumbnail)
- Notifikasi: approved/rejected, badge baru, reward cair, streak reminder (H-2 jam sebelum reset)

---

## 6. Fitur Post-MVP (v2.0+)

- **Community Challenges**: RT vs RT, kelas vs kelas, kompetisi antar kota
- **Rewarded Ads**: Opt-in, nonton 30 detik → 2× multiplier submission berikutnya
- **CSR Module**: Dashboard brand sponsor, branding pada reward tertentu
- **Barcode Scan**: Scan produk → saran kategori sampah saat habis pakai
- **Bank Sampah Integration**: Jadwal jemput sampah, koordinasi dengan armada bank sampah
- **Offline Queue**: Submit saat koneksi bagus, rekam dulu saat sinyal lemah
- **API Publik**: Data agregat pemilahan per wilayah untuk pemda/peneliti

---

## 7. Persyaratan Teknis

| Komponen | Teknologi |
|---|---|
| Mobile app | Flutter 3.x (Android + iOS) |
| State management | GetX |
| Backend auth | Supabase Auth (Google OAuth) |
| Database | Supabase PostgreSQL + RLS |
| File storage | Supabase Storage (bucket: videos, thumbnails) |
| Serverless | Supabase Edge Functions (Deno/TypeScript) |
| Scheduling | pg_cron (delete video setelah 12 jam) |
| Realtime | Supabase Realtime (leaderboard) |
| AI model | Nemotron-3-Nano-Omni-30B via NVIDIA NIM API |
| Reward e-wallet | Flip for Business API |
| Reward digital | Digiflazz API |
| Reward voucher | Tripay API |
| Push notif | Firebase Cloud Messaging (FCM) |
| Min Android | 8.0 (API 26) |
| Min iOS | 14.0 |

---

## 8. Struktur Folder — Feature-First (Clean Architecture)

Proyek Flutter Sortirin mengadopsi pendekatan **feature-first** yang dikombinasikan dengan **Clean Architecture** (data / domain / presentation layer) per fitur. Setiap fitur bersifat mandiri dan tidak bergantung langsung satu sama lain, melainkan berkomunikasi via shared services dan domain layer.

### Prinsip arsitektur
- **Feature-first**: setiap fitur memiliki folder sendiri dengan tiga layer lengkap
- **Clean Architecture**: `domain` tidak bergantung pada `data` maupun `presentation`
- **Dependency injection**: via GetX `Binding` per fitur, diinisialisasi lazy
- **Unidirectional data flow**: View → Controller → UseCase → Repository → DataSource

```
lib/
├── main.dart
├── app/
│   ├── app.dart                          # GetMaterialApp, theme, locale
│   ├── routes/
│   │   ├── app_pages.dart                # Daftar semua route + binding
│   │   └── app_routes.dart               # Konstanta nama route
│   └── bindings/
│       └── initial_binding.dart          # Binding global (StorageService, dll)
│
├── core/                                 # Tidak spesifik ke satu fitur
│   ├── constants/
│   │   ├── app_colors.dart               # #22c55e, #0a0f0d, #a3e635, dll
│   │   ├── app_fonts.dart                # Syne, Nunito
│   │   ├── app_strings.dart              # String statis & kunci i18n
│   │   └── app_sizes.dart                # Spacing, radius, breakpoint
│   ├── errors/
│   │   ├── exceptions.dart               # ServerException, CacheException, dll
│   │   └── failures.dart                 # Failure sealed class
│   ├── network/
│   │   ├── supabase_client.dart          # Singleton Supabase init
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart     # JWT auto-refresh (Dio)
│   │       └── logging_interceptor.dart
│   ├── services/
│   │   ├── local_storage_service.dart    # Hive wrapper (offline queue)
│   │   ├── notification_service.dart     # FCM init & handler
│   │   ├── camera_service.dart           # Kamera in-app, blokir gallery
│   │   └── video_compression_service.dart
│   ├── theme/
│   │   ├── app_theme.dart                # ThemeData dark eco
│   │   └── text_styles.dart
│   └── utils/
│       ├── hash_util.dart                # SHA-256 anti-cheat
│       ├── gps_util.dart                 # Metadata koordinat
│       ├── device_fingerprint_util.dart
│       └── point_calculator.dart         # Formula poin (pure function)
│
├── features/
│   │
│   ├── auth/                             # F01 — Autentikasi & Profil
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart   # Supabase Auth + Google OAuth
│   │   │   ├── models/
│   │   │   │   └── profile_model.dart             # fromJson / toJson
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── profile_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart           # Abstract
│   │   │   └── usecases/
│   │   │       ├── sign_in_google_usecase.dart
│   │   │       ├── sign_out_usecase.dart
│   │   │       └── update_profile_usecase.dart
│   │   └── presentation/
│   │       ├── bindings/
│   │       │   └── auth_binding.dart
│   │       ├── controllers/
│   │       │   └── auth_controller.dart
│   │       └── views/
│   │           ├── login_view.dart
│   │           ├── onboarding_view.dart
│   │           └── complete_profile_view.dart
│   │
│   ├── submission/                        # F02 — Rekam & Submit Sampah
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── submission_remote_datasource.dart   # Supabase Storage + DB
│   │   │   │   └── submission_local_datasource.dart    # Hive offline queue
│   │   │   ├── models/
│   │   │   │   ├── submission_model.dart
│   │   │   │   └── submission_item_model.dart
│   │   │   └── repositories/
│   │   │       └── submission_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── submission_entity.dart
│   │   │   │   └── submission_item_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── submission_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_submission_usecase.dart
│   │   │       ├── upload_video_usecase.dart           # Compress → hash → upload
│   │   │       └── get_submission_history_usecase.dart
│   │   └── presentation/
│   │       ├── bindings/
│   │       │   └── submission_binding.dart
│   │       ├── controllers/
│   │       │   ├── camera_controller.dart              # State kamera, timer
│   │       │   └── submission_controller.dart          # Upload state, status polling
│   │       ├── views/
│   │       │   ├── waste_selector_view.dart            # Chip selector jenis sampah
│   │       │   ├── camera_view.dart                    # Viewfinder + record button
│   │       │   └── submission_result_view.dart         # Breakdown poin + badge pop
│   │       └── widgets/
│   │           ├── viewfinder_overlay_widget.dart      # Grid + corner guides
│   │           ├── no_gallery_badge_widget.dart        # "🚫 No Gallery" indicator
│   │           ├── waste_chip_widget.dart
│   │           ├── quantity_stepper_widget.dart
│   │           └── estimated_points_widget.dart        # Preview poin real-time
│   │
│   ├── ai_validation/                     # F03 — AI Validation (status polling)
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── validation_remote_datasource.dart  # Polling status dari Supabase DB
│   │   │   └── repositories/
│   │   │       └── validation_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── validation_result_entity.dart      # status, confidence, reason
│   │   │   ├── repositories/
│   │   │   │   └── validation_repository.dart
│   │   │   └── usecases/
│   │   │       └── watch_validation_status_usecase.dart  # Stream realtime
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   └── validation_controller.dart
│   │       └── widgets/
│   │           ├── confidence_bar_widget.dart
│   │           └── validation_status_widget.dart
│   │
│   ├── points/                            # F04 — Sistem Poin & Streak
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── points_remote_datasource.dart      # Supabase points_ledger
│   │   │   ├── models/
│   │   │   │   ├── points_ledger_model.dart
│   │   │   │   └── streak_model.dart
│   │   │   └── repositories/
│   │   │       └── points_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── points_ledger_entity.dart
│   │   │   │   └── streak_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── points_repository.dart
│   │   │   └── usecases/
│   │   │       ├── calculate_points_usecase.dart      # Delegasi ke core/utils/point_calculator
│   │   │       ├── get_streak_usecase.dart
│   │   │       └── get_points_history_usecase.dart
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   └── points_controller.dart
│   │       └── widgets/
│   │           ├── points_breakdown_widget.dart       # Tampil di submission result
│   │           └── streak_flame_widget.dart           # Animasi api streak
│   │
│   ├── badges/                            # F05 — Badge & Achievement
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── badge_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── badge_model.dart
│   │   │   │   └── user_badge_model.dart
│   │   │   └── repositories/
│   │   │       └── badge_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── badge_entity.dart
│   │   │   │   └── user_badge_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── badge_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_user_badges_usecase.dart
│   │   │       └── check_new_badges_usecase.dart      # Trigger setelah submission approved
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   └── badge_controller.dart
│   │       └── widgets/
│   │           ├── badge_grid_widget.dart
│   │           └── badge_popup_widget.dart            # Animasi badge baru earned
│   │
│   ├── rewards/                           # F06 — Reward Catalog & Redemption
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── reward_remote_datasource.dart      # Supabase rewards table
│   │   │   │   └── redemption_remote_datasource.dart  # Flip / Digiflazz / Tripay via Edge Fn
│   │   │   ├── models/
│   │   │   │   ├── reward_model.dart
│   │   │   │   └── redemption_model.dart
│   │   │   └── repositories/
│   │   │       └── reward_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── reward_entity.dart
│   │   │   │   └── redemption_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── reward_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_rewards_usecase.dart
│   │   │       ├── redeem_reward_usecase.dart         # Potong poin + panggil Edge Fn
│   │   │       └── get_redemption_history_usecase.dart
│   │   └── presentation/
│   │       ├── bindings/
│   │       │   └── reward_binding.dart
│   │       ├── controllers/
│   │       │   └── reward_controller.dart
│   │       └── views/
│   │           ├── reward_catalog_view.dart
│   │           ├── redeem_confirm_view.dart           # OTP + konfirmasi
│   │           └── redemption_history_view.dart
│   │
│   ├── leaderboard/                       # F07 — Leaderboard
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── leaderboard_remote_datasource.dart # Supabase Realtime subscription
│   │   │   ├── models/
│   │   │   │   └── leaderboard_entry_model.dart
│   │   │   └── repositories/
│   │   │       └── leaderboard_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── leaderboard_entry_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── leaderboard_repository.dart
│   │   │   └── usecases/
│   │   │       └── watch_leaderboard_usecase.dart     # Stream realtime per scope
│   │   └── presentation/
│   │       ├── bindings/
│   │       │   └── leaderboard_binding.dart
│   │       ├── controllers/
│   │       │   └── leaderboard_controller.dart
│   │       └── views/
│   │           ├── leaderboard_view.dart
│   │           └── widgets/
│   │               ├── podium_widget.dart
│   │               ├── rank_row_widget.dart
│   │               └── scope_filter_widget.dart       # Nasional/Kota/Kelurahan
│   │
│   ├── dashboard/                         # F08 — Dashboard & Dampak Lingkungan
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── dashboard_remote_datasource.dart
│   │   │   └── repositories/
│   │   │       └── dashboard_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── impact_summary_entity.dart        # CO₂, item, streak, rank
│   │   │   ├── repositories/
│   │   │   │   └── dashboard_repository.dart
│   │   │   └── usecases/
│   │   │       └── get_impact_summary_usecase.dart
│   │   └── presentation/
│   │       ├── bindings/
│   │       │   └── dashboard_binding.dart
│   │       ├── controllers/
│   │       │   └── dashboard_controller.dart
│   │       └── views/
│   │           ├── dashboard_view.dart               # Home screen utama
│   │           └── widgets/
│   │               ├── points_hero_widget.dart       # Saldo + streak badge
│   │               ├── activity_chart_widget.dart    # Bar chart 7 hari
│   │               ├── impact_stats_widget.dart      # CO₂, item, rank
│   │               └── recent_submissions_widget.dart
│   │
│   └── waste_types/                       # Master data jenis sampah (read-only)
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── waste_type_remote_datasource.dart
│       │   │   └── waste_type_local_datasource.dart  # Cache Hive, jarang berubah
│       │   ├── models/
│       │   │   ├── waste_category_model.dart
│       │   │   └── waste_type_model.dart
│       │   └── repositories/
│       │       └── waste_type_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── waste_category_entity.dart
│       │   │   └── waste_type_entity.dart
│       │   ├── repositories/
│       │   │   └── waste_type_repository.dart
│       │   └── usecases/
│       │       └── get_waste_types_usecase.dart
│       └── presentation/
│           └── widgets/
│               ├── waste_category_card_widget.dart
│               └── waste_type_info_widget.dart       # Popup edukasi per jenis
│
└── shared/                               # Widget & utilitas lintas fitur
    ├── widgets/
    │   ├── app_button.dart               # Primary, outline, ghost variant
    │   ├── app_card.dart
    │   ├── app_bottom_nav.dart           # Bottom navigation bar
    │   ├── loading_overlay.dart
    │   ├── empty_state_widget.dart
    │   └── error_state_widget.dart
    ├── extensions/
    │   ├── string_extensions.dart        # capitalize, mask phone, dll
    │   ├── int_extensions.dart           # formatPoints(), toCurrency()
    │   └── context_extensions.dart       # screenWidth, theme shortcut
    └── mixins/
        └── form_validation_mixin.dart
```

### Dependency rules antar layer
```
Presentation  →  Domain  ←  Data
     ↓               ↓
  Controller      UseCase
     ↓               ↓
   GetX Rx      Repository (abstract)
                    ↓
              RepositoryImpl
                    ↓
               DataSource
```
- `domain/` **tidak boleh** import package Flutter atau Supabase
- `data/` boleh import Supabase, Dio, Hive
- `presentation/` hanya import `domain/` dan `shared/`
- `core/` boleh diimport dari mana saja, tidak boleh import `features/`

### Packages utama (`pubspec.yaml`)
```yaml
dependencies:
  # State & DI
  get: ^4.6.6

  # Supabase
  supabase_flutter: ^2.x

  # Kamera (in-app only, no gallery)
  camera: ^0.10.x

  # Kompresi video
  video_compress: ^3.x

  # Hive (offline queue & cache)
  hive_flutter: ^1.x

  # Notifikasi
  firebase_messaging: ^15.x
  flutter_local_notifications: ^17.x

  # Kriptografi (SHA-256)
  crypto: ^3.x

  # GPS
  geolocator: ^13.x

  # HTTP (jika perlu Dio untuk provider API)
  dio: ^5.x

  # Device fingerprint
  device_info_plus: ^10.x

dev_dependencies:
  hive_generator: ^2.x
  build_runner: ^2.x
  flutter_gen_runner: ^5.x    # assets & fonts gen
```

---

## 9. Persyaratan Non-Fungsional

| Kategori | Requirement |
|---|---|
| Performa | AI validation response < 30 detik |
| Performa | Upload video < 15 detik (koneksi 4G normal) |
| Ketersediaan | Uptime ≥ 99.5%/bulan |
| Keamanan | Video dihapus ≤ 12 jam setelah upload |
| Keamanan | TLS 1.3 untuk semua API calls |
| Keamanan | Poin ledger append-only, tidak bisa diedit |
| Privacy | PDPL compliance: tidak ada PII di video yang tersimpan |
| Privacy | GPS accuracy disimpan tapi tidak ditampilkan ke sesama user |
| Skalabilitas | Handle 10.000 submission/hari tanpa degradasi |
| Aksesibilitas | Support bahasa Indonesia + English |

---

## 10. Success Metrics

### Launch (Bulan 1)
- 1.000 registered users
- 500 submission pertama dalam minggu pertama
- Approval rate ≥ 70%
- Crash-free rate ≥ 99%

### Growth (Bulan 3)
- 10.000 MAU
- Submission/DAU ≥ 1.2
- D7 Retention ≥ 40%
- D30 Retention ≥ 20%

### Monetization (Bulan 6)
- ≥ 20% user aktif redeem reward per bulan
- ≥ 1 CSR partnership aktif
- Revenue dari rewarded ads + CSR ≥ biaya operasional

---

## 11. Roadmap Milestone

| Milestone | Deliverable | Estimasi |
|---|---|---|
| **M1** | Foundation: Auth, DB schema, Supabase setup, CI/CD | 2 minggu |
| **M2** | Camera in-app, upload pipeline, anti-cheat, AI validation | 3 minggu |
| **M3** | Sistem poin, streak, badge, points ledger | 2 minggu |
| **M4** | Reward catalog, redemption flow (Flip + Digiflazz + Tripay) | 3 minggu |
| **M5** | Leaderboard Realtime, profil, dashboard dampak | 2 minggu |
| **M6** | QA, security hardening, PDPL audit, soft launch beta | 2 minggu |

**Total estimasi MVP: ±14 minggu (3.5 bulan)**

---

## 12. Risiko & Mitigasi

| Risiko | Dampak | Mitigasi |
|---|---|---|
| AI akurasi rendah untuk sampah lokal | False reject → user frustasi | Fine-tune dengan dataset sampah Indonesia; fallback ke moderator manusia |
| User farming poin | Developer boncos | Soft cap 500 poin/hari, hash SHA-256 anti-replay, GPS proximity check |
| Biaya reward > revenue | Sustainability | Start dengan CSR grant + rewarded ads; cap redemption per user/bulan |
| Privasi: video rekam wajah orang lain | PDPL violation | Blur face opsional; panduan rekam di UI; hapus video ≤ 12 jam |
| Provider reward downtime | Redemption gagal | Fallback provider; queue retry otomatis; notifikasi user |
| Supabase Edge Function timeout | Pipeline gagal | Pola async: upload → return response → proses background |

---

*Dokumen ini hidup (living document) dan akan diperbarui setiap milestone.*
