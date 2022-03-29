// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => AuthUser(
      uid: json['uid'] as String?,
      email: json['email'] as String?,
      customClaims: json['customClaims'] == null
          ? null
          : CustomClaimObj.fromJson(
              json['customClaims'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthUserToJson(AuthUser instance) => <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'customClaims': instance.customClaims?.toJson(),
    };
