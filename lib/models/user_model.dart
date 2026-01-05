class User {
  String? id;
  String nim;
  String? password;
  String nama;
  String email;
  String? noHp;
  String? prodi;
  int? semester;
  double? ipk;
  int? maxSks;
  String? photoUrl;
  bool? isActive;
  String? role; // Add role field

  User({
    this.id,
    required this.nim,
    this.password,
    required this.nama,
    required this.email,
    this.noHp,
    this.prodi,
    this.semester,
    this.ipk,
    this.maxSks,
    this.photoUrl,
    this.isActive,
    this.role,
  });

  // Copy with method untuk edit
  // Getters for backward compatibility
  String get studentName => nama;
  String get programStudi => prodi ?? '';
  String? get phoneNumber => noHp;
  String? get profileImageUrl => photoUrl;
  String? get socialMedia => null; // Not in backend yet
  bool get isProfileComplete =>
      email.isNotEmpty && noHp != null && noHp!.isNotEmpty;
  bool get isAdmin => role == 'admin';

  User copyWith({
    String? id,
    String? nim,
    String? password,
    String? nama,
    String? email,
    String? noHp,
    String? prodi,
    int? semester,
    double? ipk,
    int? maxSks,
    String? photoUrl,
    bool? isActive,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      nim: nim ?? this.nim,
      password: password ?? this.password,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      noHp: noHp ?? this.noHp,
      prodi: prodi ?? this.prodi,
      semester: semester ?? this.semester,
      ipk: ipk ?? this.ipk,
      maxSks: maxSks ?? this.maxSks,
      photoUrl: photoUrl ?? this.photoUrl,
      isActive: isActive ?? this.isActive,
      role: role ?? this.role,
    );
  }

  // From JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nim: json['nim'] ?? '',
      nama: json['name'] ?? '',
      email: json['email'] ?? '',
      noHp: json['phoneNumber'],
      prodi: json['prodi'],
      semester: json['semester'],
      ipk: json['ipk']?.toDouble(),
      maxSks: json['maxSks'],
      photoUrl: json['photoUrl'],
      isActive: json['isActive'],
      role: json['role'] ?? 'mahasiswa',
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nim': nim,
      if (password != null) 'password': password,
      'name': nama,
      'email': email,
      if (noHp != null) 'phoneNumber': noHp,
      if (prodi != null) 'prodi': prodi,
      if (semester != null) 'semester': semester,
      if (ipk != null) 'ipk': ipk,
      if (maxSks != null) 'maxSks': maxSks,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (isActive != null) 'isActive': isActive,
      if (role != null) 'role': role,
    };
  }
}
