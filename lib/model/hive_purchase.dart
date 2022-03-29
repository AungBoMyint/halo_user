import 'package:hive/hive.dart';

part 'hive_purchase.g.dart';

@HiveType(typeId: 3)
class HivePurchase {
  @HiveField(0)
  List items;
  @HiveField(1)
  int totalPrice;
  @HiveField(2)
  List deliveryTownshipInfo;
  @HiveField(3)
  DateTime dateTime;
  @HiveField(4)
  String id;
  HivePurchase({
    required this.items,
    required this.totalPrice,
    required this.deliveryTownshipInfo,
    required this.dateTime,
    required this.id,
  });
}
