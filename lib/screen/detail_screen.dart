import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_full_image_screen/custom_full_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kozarni_ecome/controller/home_controller.dart';
import 'package:kozarni_ecome/data/constant.dart';
import 'package:get/get.dart';
import 'package:kozarni_ecome/expaned_widget.dart';
import 'package:kozarni_ecome/model/hive_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    return Scaffold(
      backgroundColor: detailTextBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          controller.selectedItem.value.name,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: ListView(
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Hero(
                tag: controller.selectedItem.value.photo,
                child: CarouselSlider(
                  items: [
                    CachedNetworkImage(
                      imageUrl: controller.selectedItem.value.photo,
                      // "$baseUrl$itemUrl${controller.selectedItem.value.photo}/get",
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    CachedNetworkImage(
                      imageUrl: controller.selectedItem.value.photo2,
                      // "$baseUrl$itemUrl${controller.selectedItem.value.photo}/get",
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    CachedNetworkImage(
                      imageUrl: controller.selectedItem.value.photo3,
                      // "$baseUrl$itemUrl${controller.selectedItem.value.photo}/get",
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ],
                  options: CarouselOptions(
                    height: 400,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
            ),
            margin: EdgeInsets.only(top: 10),
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: detailTextBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Star
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            size: 20,
                            color: index <= controller.selectedItem.value.star
                                ? homeIndicatorColor
                                : Colors.grey,
                          ),
                        ),
                      ),
                      //Favourite Icon
                      ValueListenableBuilder(
                        valueListenable:
                            Hive.box<HiveItem>(boxName).listenable(),
                        builder: (context, Box<HiveItem> box, widget) {
                          final currentObj =
                              box.get(controller.selectedItem.value.id);

                          if (!(currentObj == null)) {
                            return IconButton(
                                onPressed: () {
                                  box.delete(currentObj.id);
                                },
                                icon: Icon(
                                  FontAwesomeIcons.solidHeart,
                                  color: Colors.red,
                                  size: 25,
                                ));
                          }
                          return IconButton(
                              onPressed: () {
                                box.put(
                                    controller.selectedItem.value.id,
                                    controller.changeHiveItem(
                                        controller.selectedItem.value));
                              },
                              icon: Icon(
                                Icons.favorite_outline,
                                color: Colors.red,
                                size: 25,
                              ));
                        },
                      ),
                    ]),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "တစ်ထည်ဈေး (Retail) :",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      "${controller.selectedItem.value.price} Kyats",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.selectedItem.value.brand,
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      controller.selectedItem.value.deliverytime,
                      style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      "${controller.selectedItem.value.discountprice} Kyats",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ExpandedWidget(
                  text: controller.selectedItem.value.desc,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "⏰ Delivery Time",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Within 3 Days",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "💁 Availability ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "In Stock",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "📞 Contact Phone ",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 29,
                          child: TextButton(
                            onPressed: () => launch("tel://09777703338"),
                            child: Text(
                              "09 7777 0 333 8",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ImageCachedFullscreen(
                                imageUrl: controller.selectedItem.value.photo2,
                                imageBorderRadius: 7,
                                imageWidth: 150,
                                imageHeight: 200,
                                imageFit: BoxFit.cover,
                                imageDetailsHeight: double.infinity,
                                imageDetailsWidth: double.infinity,
                                imageDetailsFit: BoxFit.fitWidth,
                                withHeroAnimation: true,
                                placeholder: Container(),
                                placeholderDetails:
                                    Center(child: CircularProgressIndicator()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ImageCachedFullscreen(
                                imageUrl: controller.selectedItem.value.photo3,
                                imageBorderRadius: 7,
                                imageWidth: 150,
                                imageHeight: 200,
                                imageFit: BoxFit.cover,
                                imageDetailsHeight: double.infinity,
                                imageDetailsWidth: double.infinity,
                                imageDetailsFit: BoxFit.fitWidth,
                                withHeroAnimation: true,
                                placeholder: Container(),
                                placeholderDetails:
                                    Center(child: CircularProgressIndicator()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "🏠 Shop - 1  ( Thanlyin )",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () => launch("tel://09777702228"),
                          child: Text(
                            "📞     09 7777 0 222 8",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'အမှတ် 116 ၊ သတိပဌာန်လမ်း ၊ မြို့မတောင်ရပ်ကွက် ၊ သန်လျင်မြို့နယ် ၊ ရန်ကုန်မြို့။',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "🏠 Shop - 2  ( Dawbon )",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () => launch("tel://09777703338"),
                          child: Text(
                            "📞     09 7777 0 333 8",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'အမှတ် 192 ၊ ယမုံနာလမ်း ၊ ဇေယျာသီရိရပ်ကွက်, ဒေါပုံမြို့နယ် ။ (မာန်ပြေကားဂိတ်နားမရောက်ခင်...ဇေယျာသီရိ ၈ လမ်းထိပ်)',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '🌼 𝐂𝐇𝐎𝐎𝐒𝐄 𝐓𝐇𝐄 𝐁𝐄𝐒𝐓 𝐎𝐔𝐓𝐅𝐈𝐓𝐒, 𝐂𝐇𝐎𝐎𝐒𝐄 𝐔𝐒! 🌼',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 65,
        // decoration: BoxDecoration(
        //   color: detailBackgroundColor,
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(20),
        //     topRight: Radius.circular(20),
        //   ),
        // ),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: () {
            Get.defaultDialog(
              titlePadding: EdgeInsets.all(0),
              contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              radius: 0,
              title: '',
              content: AddToCart(
                priceList: [
                  controller.selectedItem.value.price,
                  controller.selectedItem.value.discountprice,
                ],
                priceString: [
                  "၁ ထည် လက်လီ ဈေးနှုန်း",
                  controller.selectedItem.value.brand,
                ],
              ),
            );
          },
          child: Text("၀ယ်ယူရန်"),
        ),
      ),
    );
  }
}

class AddToCart extends StatefulWidget {
  final List<int> priceList;
  final List<String> priceString;
  const AddToCart({
    Key? key,
    required this.priceList,
    required this.priceString,
  }) : super(key: key);

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  String? colorValue;
  String? sizeValue;
  String? priceType;
  final HomeController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return Column(
      children: [
        DropdownButtonFormField(
          value: colorValue,
          hint: Text(
            'Color',
            style: TextStyle(fontSize: 12),
          ),
          onChanged: (String? e) {
            colorValue = e;
          },
          items: controller.selectedItem.value.color
              .split(',')
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: TextStyle(fontSize: 12),
                    ),
                  ))
              .toList(),
        ),
        SizedBox(
          height: 10,
        ),
        DropdownButtonFormField(
          value: sizeValue,
          hint: Text(
            "Size",
            style: TextStyle(fontSize: 12),
          ),
          onChanged: (String? e) {
            sizeValue = e;
          },
          items: controller.selectedItem.value.size
              .split(',')
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: TextStyle(fontSize: 12),
                    ),
                  ))
              .toList(),
        ),
        //Price Wholesale (or) Retail
        SizedBox(
          height: 10,
        ),
        DropdownButtonFormField(
          value: priceType,
          hint: Text(
            "Price",
            style: TextStyle(fontSize: 12),
          ),
          onChanged: (String? e) {
            priceType = e;
          },
          items: List.generate(
            widget.priceString.length,
            (index) => DropdownMenuItem(
              value: widget.priceString[index],
              child: Text(
                widget.priceString[index],
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: ElevatedButton(
            style: buttonStyle,
            onPressed: () {
              if (colorValue != null &&
                  sizeValue != null &&
                  priceType != null) {
                int price = (priceType == widget.priceString[0])
                    ? widget.priceList[0]
                    : widget.priceList[1];
                controller.addToCart(
                    controller.selectedItem.value, colorValue!, sizeValue!);
                Get.to(HomeScreen());
              }
            },
            child: Text("၀ယ်ယူရန်"),
          ),
        ),
      ],
    );
  }
}
