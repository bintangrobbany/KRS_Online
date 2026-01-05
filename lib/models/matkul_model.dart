class MataKuliah {
  String? id;
  String kode;
  String nama;
  int sks;
  int? semester;
  String? prodi;
  String? description;

  MataKuliah({
    this.id,
    required this.kode,
    required this.nama,
    required this.sks,
    this.semester,
    this.prodi,
    this.description,
  });

  // From JSON
  factory MataKuliah.fromJson(Map<String, dynamic> json) {
    return MataKuliah(
      id: json['id'],
      kode: json['kodeMk'] ?? '',
      nama: json['namaMk'] ?? '',
      sks: json['sks'] ?? 0,
      semester: json['semester'],
      prodi: json['prodi'],
      description: json['description'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'kodeMk': kode,
      'namaMk': nama,
      'sks': sks,
      if (semester != null) 'semester': semester,
      if (prodi != null) 'prodi': prodi,
      if (description != null) 'description': description,
    };
  }
}
