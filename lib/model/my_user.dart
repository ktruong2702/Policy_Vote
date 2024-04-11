class MyUser {
  final String email;
  final String f_name;
  final String l_name;
  final String username;
  final String password;
  final String uid; // Add uid field

  MyUser({
    required this.email,
    required this.f_name,
    required this.l_name,
    required this.username,
    required this.password,
    required this.uid, // Initialize uid in the constructor
  });
}
