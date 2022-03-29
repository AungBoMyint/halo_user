class ItemModel {
  final String? id;
  final String photo;
  final String photo2;
  final String photo3;
  final String desc;
  final String name;
  final String brand;
  final String deliverytime;
  final int price;
  final int discountprice;
  final String color;
  final String size;
  final int star;
  final String category;
  final bool isOwnBrand;
  // final DateTime? created;

  ItemModel({
    this.id,
    required this.photo,
    required this.photo2,
    required this.photo3,
    required this.name,
    required this.brand,
    required this.deliverytime,
    required this.price,
    required this.discountprice,
    required this.desc,
    required this.color,
    required this.size,
    required this.star,
    required this.category,
    required this.isOwnBrand,
    // this.created,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json, id) => ItemModel(
        id: id,
        photo: json['photo'] as String,
        photo2: json['photo2'] as String,
        photo3: json['photo3'] as String,
        name: json['name'] as String,
        brand: json['brand'] as String,
        deliverytime: json['deliverytime'] as String,
        desc: json['desc'] as String,
        price: json['price'] as int,
        discountprice: json['discountprice'] as int,
        color: json['color'] as String,
        size: json['size'] as String,
        star: json['star'] as int,
        category: json['category'] as String,
        isOwnBrand: json['isOwnBrand'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'photo': photo,
        'photo2': photo2,
        'photo3': photo3,
        'name': name,
        'brand': brand,
        'deliverytime': deliverytime,
        'price': price,
        'discountprice': discountprice,
        'color': color,
        'size': size,
        'star': star,
        'category': category,
        'desc': desc,
        'isOwnBrand': isOwnBrand,
      };

  ItemModel copyWith({
    String? newPhoto,
    String? newPhoto2,
    String? newPhoto3,
    String? newBrand,
    String? newDeliveryTime,
    String? newName,
    String? des,
    int? newPrice,
    int? newDiscountPrice,
    String? newColor,
    String? newSize,
    int? newStar,
    String? newCategory,
    bool? newIsOwnBrand,
  }) =>
      ItemModel(
        id: id,
        photo: newPhoto ?? photo,
        photo2: newPhoto2 ?? photo2,
        photo3: newPhoto3 ?? photo3,
        brand: newBrand ?? brand,
        deliverytime: newDeliveryTime ?? deliverytime,
        name: newName ?? name,
        price: newPrice ?? price,
        discountprice: newDiscountPrice ?? discountprice,
        desc: des ?? desc,
        color: newColor ?? color,
        size: newSize ?? size,
        star: newStar ?? star,
        category: newCategory ?? category,
        isOwnBrand: newIsOwnBrand ?? isOwnBrand,
      );
}

class PurchaseItem {
  final String id;
  final String itemName;
  final int count;
  final String size;
  final String color;
  final bool isOwnBrand;
  final String priceType;
  final bool isHotDeal;
  final int retailPrice;
  final int wholesalePrice;
  final Map<String, dynamic> showcaseMap;

  PurchaseItem(
      {required this.id,
      required this.itemName,
      required this.count,
      required this.size,
      required this.color,
      required this.priceType,
      required this.isOwnBrand,
      required this.isHotDeal,
      required this.retailPrice,
      required this.wholesalePrice,
      required this.showcaseMap});
  PurchaseItem copyWith({
    String? id,
    String? itemName,
    int? count,
    String? size,
    String? color,
    String? priceType,
    bool? isOwnBrand,
    bool? isHotDeal,
    int? retailPrice,
    int? wholesalePrice,
    Map<String, dynamic>? showcaseMap,
  }) =>
      PurchaseItem(
        id: id ?? this.id,
        itemName: itemName ?? this.itemName,
        count: count ?? this.count,
        size: size ?? this.size,
        color: color ?? this.color,
        priceType: priceType ?? this.priceType,
        isOwnBrand: isOwnBrand ?? this.isOwnBrand,
        isHotDeal: isHotDeal ?? this.isHotDeal,
        retailPrice: retailPrice ?? this.retailPrice,
        wholesalePrice: wholesalePrice ?? this.wholesalePrice,
        showcaseMap: showcaseMap ?? this.showcaseMap,
      );
}
