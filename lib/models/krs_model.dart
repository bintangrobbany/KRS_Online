class KelasMataKuliah {
  String id;
  String kodeMataKuliah;
  String namaMataKuliah;
  int sks;
  String dosen;
  String ruangan;
  String jadwal; // format: "Senin, 08:00-10:00"
  String? hari;
  String? jamMulai;
  String? jamSelesai;
  String? kodeKelas;
  int kapasitas;
  int pendaftarSaat;
  bool? isActive;
  String? prodi;
  int? semester;

  KelasMataKuliah({
    String? id,
    required this.kodeMataKuliah,
    required this.namaMataKuliah,
    required this.sks,
    required this.dosen,
    required this.ruangan,
    required this.jadwal,
    this.hari,
    this.jamMulai,
    this.jamSelesai,
    this.kodeKelas,
    required this.kapasitas,
    this.pendaftarSaat = 0,
    this.isActive,
    this.prodi,
    this.semester,
  }) : id = id ?? '';

  bool get isFull => pendaftarSaat >= kapasitas;

  int get slotsAvailable => kapasitas - pendaftarSaat;

  KelasMataKuliah copyWith({
    String? id,
    String? kodeMataKuliah,
    String? namaMataKuliah,
    int? sks,
    String? dosen,
    String? ruangan,
    String? jadwal,
    String? hari,
    String? jamMulai,
    String? jamSelesai,
    String? kodeKelas,
    int? kapasitas,
    int? pendaftarSaat,
    bool? isActive,
    String? prodi,
    int? semester,
  }) {
    return KelasMataKuliah(
      id: id ?? this.id,
      kodeMataKuliah: kodeMataKuliah ?? this.kodeMataKuliah,
      namaMataKuliah: namaMataKuliah ?? this.namaMataKuliah,
      sks: sks ?? this.sks,
      dosen: dosen ?? this.dosen,
      ruangan: ruangan ?? this.ruangan,
      jadwal: jadwal ?? this.jadwal,
      hari: hari ?? this.hari,
      jamMulai: jamMulai ?? this.jamMulai,
      jamSelesai: jamSelesai ?? this.jamSelesai,
      kodeKelas: kodeKelas ?? this.kodeKelas,
      kapasitas: kapasitas ?? this.kapasitas,
      pendaftarSaat: pendaftarSaat ?? this.pendaftarSaat,
      isActive: isActive ?? this.isActive,
      prodi: prodi ?? this.prodi,
      semester: semester ?? this.semester,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'kodeMataKuliah': kodeMataKuliah,
    'namaMataKuliah': namaMataKuliah,
    'sks': sks,
    'dosen': dosen,
    'ruangan': ruangan,
    'jadwal': jadwal,
    if (hari != null) 'hari': hari,
    if (jamMulai != null) 'jamMulai': jamMulai,
    if (jamSelesai != null) 'jamSelesai': jamSelesai,
    if (kodeKelas != null) 'kodeKelas': kodeKelas,
    'kapasitas': kapasitas,
    'pendaftarSaat': pendaftarSaat,
    if (isActive != null) 'isActive': isActive,
    if (prodi != null) 'prodi': prodi,
    if (semester != null) 'semester': semester,
  };

  // From JSON - sesuai dengan backend response format=kelas
  factory KelasMataKuliah.fromJson(Map<String, dynamic> json) {
    return KelasMataKuliah(
      id: json['id'] ?? '',
      kodeMataKuliah: json['kodeMataKuliah'] ?? '',
      namaMataKuliah: json['namaMataKuliah'] ?? '',
      sks: json['sks'] ?? 0,
      dosen: json['dosen'] ?? '',
      ruangan: json['ruangan'] ?? '',
      jadwal: json['jadwal'] ?? '',
      hari: json['hari'],
      jamMulai: json['jamMulai'],
      jamSelesai: json['jamSelesai'],
      kodeKelas: json['kodeKelas'],
      kapasitas: json['kapasitas'] ?? 0,
      pendaftarSaat: json['pendaftarSaat'] ?? 0,
      isActive: json['isActive'],
      prodi: json['prodi'],
      semester: json['semester'],
    );
  }
}

class DaftarKelasMahasiswa {
  String id;
  String userId;
  String jadwalId;
  String? semester;
  String? tahunAjaran;
  String status; // 'pending', 'approved', 'rejected'
  DateTime? createdAt;
  KelasMataKuliah? kelasDetail; // Nested jadwal data

  DaftarKelasMahasiswa({
    String? id,
    required this.userId,
    required this.jadwalId,
    this.semester,
    this.tahunAjaran,
    required this.status,
    this.createdAt,
    this.kelasDetail,
  }) : id = id ?? '';

  // Getter untuk backward compatibility dengan UI lama
  String? get kelasId => jadwalId;
  String? get namaMataKuliah => kelasDetail?.namaMataKuliah;
  String? get jadwal => kelasDetail?.jadwal;
  int? get sks => kelasDetail?.sks;
  DateTime? get tglDaftar => createdAt;

  DaftarKelasMahasiswa copyWith({
    String? id,
    String? userId,
    String? jadwalId,
    String? semester,
    String? tahunAjaran,
    String? status,
    DateTime? createdAt,
    KelasMataKuliah? kelasDetail,
  }) {
    return DaftarKelasMahasiswa(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      jadwalId: jadwalId ?? this.jadwalId,
      semester: semester ?? this.semester,
      tahunAjaran: tahunAjaran ?? this.tahunAjaran,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      kelasDetail: kelasDetail ?? this.kelasDetail,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'jadwalId': jadwalId,
    if (semester != null) 'semester': semester,
    if (tahunAjaran != null) 'tahunAjaran': tahunAjaran,
    'status': status,
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    if (kelasDetail != null) 'jadwal': kelasDetail!.toJson(),
  };

  // From JSON - sesuai dengan backend KRS response
  factory DaftarKelasMahasiswa.fromJson(Map<String, dynamic> json) {
    return DaftarKelasMahasiswa(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      jadwalId: json['jadwalId'] ?? '',
      semester: json['semester'],
      tahunAjaran: json['tahunAjaran'],
      status: json['status'] ?? 'pending',
      createdAt: _parseDateTime(json['createdAt']),
      kelasDetail: json['jadwal'] != null
          ? _parseKelasFromJadwal(json['jadwal'])
          : null,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;

    // Backend kadang kirim ISO string
    if (value is String) {
      return DateTime.tryParse(value);
    }

    // Backend bisa kirim millisecond epoch
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }

    // Firestore Timestamp dari Admin SDK sering terserialize jadi map
    // contoh: { _seconds: 123, _nanoseconds: 0 } atau { seconds: 123, nanoseconds: 0 }
    if (value is Map) {
      final dynamic seconds = value['_seconds'] ?? value['seconds'];
      if (seconds is int) {
        return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
      }
      if (seconds is double) {
        return DateTime.fromMillisecondsSinceEpoch((seconds * 1000).round());
      }
    }

    return null;
  }

  // Helper method to parse jadwal response from backend
  static KelasMataKuliah _parseKelasFromJadwal(Map<String, dynamic> jadwal) {
    final mataKuliah = jadwal['mataKuliah'];
    return KelasMataKuliah(
      id: jadwal['id'] ?? '',
      kodeMataKuliah: mataKuliah?['kodeMk'] ?? '',
      namaMataKuliah: mataKuliah?['namaMk'] ?? '',
      sks: mataKuliah?['sks'] ?? 0,
      dosen: jadwal['dosen'] ?? '',
      ruangan: jadwal['ruangan'] ?? '',
      jadwal:
          '${jadwal['hari']}, ${jadwal['jamMulai']}-${jadwal['jamSelesai']}',
      hari: jadwal['hari'],
      jamMulai: jadwal['jamMulai'],
      jamSelesai: jadwal['jamSelesai'],
      kodeKelas: jadwal['kodeKelas'],
      kapasitas: jadwal['kuota'] ?? 0,
      pendaftarSaat: jadwal['terisi'] ?? 0,
      isActive: jadwal['isActive'],
      prodi: mataKuliah?['prodi'],
      semester: mataKuliah?['semester'],
    );
  }
}
