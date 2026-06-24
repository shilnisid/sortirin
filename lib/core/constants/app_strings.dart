/// Static strings & i18n keys for Sortirin.
/// In v1.0 hardcoded Indonesian; post-MVP use Flutter i18n.
class AppStrings {
  AppStrings._();

  // ── App ──
  static const String appName = 'Sortirin';
  static const String tagline = 'Yuk, sortirin sampahmu — dapat poin, jaga bumi.';

  // ── Auth ──
  static const String loginTitle = 'Masuk';
  static const String loginSubtitle = 'Mulai pilah sampah dan dapatkan reward nyata.';
  static const String loginGoogleButton = 'Lanjutkan dengan Google';
  static const String onbTitle1 = 'Rekam & Pilah';
  static const String onbDesc1 = 'Rekam video sampahmu langsung dari kamera. Pilih jenis yang sesuai.';
  static const String onbTitle2 = 'Validasi AI';
  static const String onbDesc2 = 'AI kami periksa kebenaran pemilahanmu dalam hitungan detik.';
  static const String onbTitle3 = 'Dapatkan Reward';
  static const String onbDesc3 = 'Kumpulkan poin, tukar dengan GoPay, kuota, token PLN, dan voucher.';
  static const String completeProfileTitle = 'Lengkapi Profil';
  static const String completeProfileDesc = 'Isi data kota dan nomor HP untuk mulai memilah.';
  static const String phoneHint = 'Nomor HP (wajib untuk redeem)';
  static const String cityHint = 'Kota';
  static const String districtHint = 'Kelurahan / Kecamatan';
  static const String saveProfile = 'Simpan Profil';

  // ── Dashboard ──
  static const String dashboardTitle = 'Beranda';
  static const String totalPoints = 'Total Poin';
  static const String streakLabel = 'Streak';
  static const String rankLabel = 'Peringkat';
  static const String itemsSorted = 'Item Terpilah';
  static const String co2Saved = 'CO₂ Dihemat';
  static const String equivalentTrees = 'Setara Pohon';

  // ── Camera ──
  static const String selectWasteType = 'Pilih Jenis Sampah';
  static const String recordHint = 'Rekam proses membuang sampah ke tempat yang sesuai';
  static const String recordButton = 'Rekam';
  static const String stopButton = 'Selesai';
  static const String reviewTitle = 'Review Video';
  static const String submitButton = 'Kirim';
  static const String compressionLabel = 'Mengompresi video...';
  static const String uploadingLabel = 'Mengunggah...';
  static const String pendingReview = 'Menunggu validasi';

  // ── Points ──
  static const String pointsBreakdown = 'Rincian Poin';
  static const String basePoints = 'Poin Dasar';
  static const String varietyBonus = 'Bonus Variasi';
  static const String discoveryBonus = 'Bonus Penemuan';
  static const String streakMultiplier = 'Pengali Streak';
  static const String confidenceMultiplier = 'Pengali Akurasi AI';
  static const String weekendBonus = 'Bonus Akhir Pekan';
  static const String dailyCapWarning = 'Batas harian 500 poin';

  // ── Badges ──
  static const String badgesTitle = 'Lencana';
  static const String newBadge = 'Lencana Baru!';

  // ── Rewards ──
  static const String rewardCatalog = 'Katalog Reward';
  static const String redeemButton = 'Tukarkan';
  static const String confirmRedeem = 'Konfirmasi Penukaran';
  static const String otpVerification = 'Verifikasi OTP';
  static const String redemptionHistory = 'Riwayat Penukaran';
  static const String insufficientPoints = 'Poin tidak cukup';

  // ── Leaderboard ──
  static const String leaderboardTitle = 'Peringkat';
  static const String national = 'Nasional';
  static const String city = 'Kota';
  static const String district = 'Kelurahan';
  static const String friends = 'Teman';
  static const String monthly = 'Bulan Ini';
  static const String allTime = 'Sepanjang Masa';
  static const String hallOfFame = 'Hall of Fame';

  // ── Status ──
  static const String approved = 'Disetujui';
  static const String rejected = 'Ditolak';
  static const String pending = 'Menunggu';
  static const String processing = 'Diproses';
  static const String completed = 'Selesai';
  static const String failed = 'Gagal';

  // ── Errors ──
  static const String generalError = 'Terjadi kesalahan. Silakan coba lagi.';
  static const String networkError = 'Koneksi internet bermasalah.';
  static const String cameraError = 'Kamera tidak tersedia.';
  static const String locationError = 'Akses lokasi diperlukan.';
  static const String videoTooLarge = 'Video terlalu besar (maks 50 MB).';
}
