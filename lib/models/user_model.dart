class UserModel {
  final int id;
  final String name, email;

  new({required this.id, required this.name, required this.email});

  factory UserModel.from(Map<String, dynamic> j) {
    return UserModel(id: j['id'], name: j['name'], email: j['email']);
  }
}
