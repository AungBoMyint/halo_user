import 'package:json_annotation/json_annotation.dart';

part 'custom_claim_obj.g.dart';

@JsonSerializable()
class CustomClaimObj {
  final bool? isPartnerUser;
  CustomClaimObj(this.isPartnerUser);

  factory CustomClaimObj.fromJson(Map<String, dynamic> json) =>
      _$CustomClaimObjFromJson(json);
  Map<String, dynamic> toJson() => _$CustomClaimObjToJson(this);
}
