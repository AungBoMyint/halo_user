import 'package:firebase_auth/firebase_auth.dart';

class AdminUser {
  final User? user;
  final bool isAdmin;
  final String? profileImage;

  AdminUser({this.user, this.isAdmin = false, this.profileImage});

  AdminUser update({
    User? newUser,
    bool? newIsAdmin,
    String? newProfileImage,
  }) =>
      AdminUser(
        user: newUser ?? user,
        isAdmin: newIsAdmin ?? isAdmin,
        profileImage: newProfileImage ?? profileImage,
      );
}
