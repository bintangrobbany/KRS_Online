class User {
  String nim;
  String password;
  String nama;
  String email;
  String noHp;

  User({
    required this.nim,
    required this.password,
    required this.nama,
    required this.email,
    required this.noHp,
  });

  // Copy with method untuk edit
  User copyWith({
    String? nim,
    String? password,
    String? nama,
    String? email,
    String? noHp,
  }) {
    return User(
      nim: nim ?? this.nim,
      password: password ?? this.password,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      noHp: noHp ?? this.noHp,
    );
  }
}
