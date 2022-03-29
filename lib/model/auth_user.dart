import 'package:json_annotation/json_annotation.dart';
import 'package:kozarni_ecome/model/custom_claim_obj.dart';

part 'auth_user.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthUser {
  final String? uid;
  final String? email;
  final CustomClaimObj? customClaims;
  AuthUser({this.uid, this.email, this.customClaims});

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserToJson(this);

  AuthUser copyWith({
    String? uid,
    String? email,
    CustomClaimObj? customClaims,
  }) =>
      AuthUser(
        uid: this.uid ?? uid,
        email: this.email ?? email,
        customClaims: this.customClaims ?? customClaims,
      );
}
