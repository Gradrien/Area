
/// A class representing a user.
class User {
  /// The unique identifier of the user.
  final int id;
  /// The name of the user.
  final String name;
  /// The email of the user.
  final String email;
  /// The date the user was created.
  final String created;

  /// Constructor for a `User` class.
  /// 
  /// - `id`: The unique identifier of the user.
  /// - `name`: The name of the user.
  /// - `email`: The email of the user.
  /// - `created`: The date the user was created.
  User({required this.id, required this.name, required this.email, required this.created});

  /// Factory constructor for a [User] object from a JSON map.
  /// 
  /// - [json]: A JSON map representing a [User] object.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      created: json['created_at'],
    );
  }

  get getName => name;
  get getEmail => email;
}