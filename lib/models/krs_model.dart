import 'package:uuid/uuid.dart';

class KelasMataKuliah {
  String id;
  String kodeMataKuliah;
  String namaMataKuliah;
  int sks;
  String dosen;
  String ruangan;
  String jadwal; // format: "Senin, 08:00-10:00"
  int kapasitas;
  int pendaftarSaat;
  List<String> pesertaUid; // List UID mahasiswa yang sudah terdaftar

  KelasMataKuliah({
    String? id,
    required this.kodeMataKuliah,
    required this.namaMataKuliah,
    required this.sks,
    required this.dosen,
    required this.ruangan,
    required this.jadwal,
    required this.kapasitas,
    this.pendaftarSaat = 0,
    this.pesertaUid = const [],
  }) : id = id ?? const Uuid().v4();

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
    int? kapasitas,
    int? pendaftarSaat,
    List<String>? pesertaUid,
  }) {
    return KelasMataKuliah(
      id: id ?? this.id,
      kodeMataKuliah: kodeMataKuliah ?? this.kodeMataKuliah,
      namaMataKuliah: namaMataKuliah ?? this.namaMataKuliah,
      sks: sks ?? this.sks,
      dosen: dosen ?? this.dosen,
      ruangan: ruangan ?? this.ruangan,
      jadwal: jadwal ?? this.jadwal,
      kapasitas: kapasitas ?? this.kapasitas,
      pendaftarSaat: pendaftarSaat ?? this.pendaftarSaat,
      pesertaUid: pesertaUid ?? this.pesertaUid,
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
    'kapasitas': kapasitas,
    'pendaftarSaat': pendaftarSaat,
    'pesertaUid': pesertaUid,
  };

  factory KelasMataKuliah.fromJson(Map<String, dynamic> json) {
    return KelasMataKuliah(
      id: json['id'],
      kodeMataKuliah: json['kodeMataKuliah'],
      namaMataKuliah: json['namaMataKuliah'],
      sks: json['sks'],
      dosen: json['dosen'],
      ruangan: json['ruangan'],
      jadwal: json['jadwal'],
      kapasitas: json['kapasitas'],
      pendaftarSaat: json['pendaftarSaat'] ?? 0,
      pesertaUid: List<String>.from(json['pesertaUid'] ?? []),
    );
  }
}

class DaftarKelasMahasiswa {
  String id;
  String mahasiswaUid;
  String kelasId;
  String namaMataKuliah;
  int sks;
  String jadwal;
  String ruangan;
  DateTime tglDaftar;
  String status; // 'terdaftar', 'antrian'

  DaftarKelasMahasiswa({
    String? id,
    required this.mahasiswaUid,
    required this.kelasId,
    required this.namaMataKuliah,
    required this.sks,
    required this.jadwal,
    required this.ruangan,
    required this.tglDaftar,
    required this.status,
  }) : id = id ?? const Uuid().v4();

  DaftarKelasMahasiswa copyWith({
    String? id,
    String? mahasiswaUid,
    String? kelasId,
    String? namaMataKuliah,
    int? sks,
    String? jadwal,
    String? ruangan,
    DateTime? tglDaftar,
    String? status,
  }) {
    return DaftarKelasMahasiswa(
      id: id ?? this.id,
      mahasiswaUid: mahasiswaUid ?? this.mahasiswaUid,
      kelasId: kelasId ?? this.kelasId,
      namaMataKuliah: namaMataKuliah ?? this.namaMataKuliah,
      sks: sks ?? this.sks,
      jadwal: jadwal ?? this.jadwal,
      ruangan: ruangan ?? this.ruangan,
      tglDaftar: tglDaftar ?? this.tglDaftar,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'mahasiswaUid': mahasiswaUid,
    'kelasId': kelasId,
    'namaMataKuliah': namaMataKuliah,
    'sks': sks,
    'jadwal': jadwal,
    'ruangan': ruangan,
    'tglDaftar': tglDaftar.toIso8601String(),
    'status': status,
  };

  factory DaftarKelasMahasiswa.fromJson(Map<String, dynamic> json) {
    return DaftarKelasMahasiswa(
      id: json['id'],
      mahasiswaUid: json['mahasiswaUid'],
      kelasId: json['kelasId'],
      namaMataKuliah: json['namaMataKuliah'],
      sks: json['sks'],
      jadwal: json['jadwal'],
      ruangan: json['ruangan'],
      tglDaftar: DateTime.parse(json['tglDaftar']),
      status: json['status'],
    );
  }
}
