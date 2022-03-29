import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kozarni_ecome/controller/home_controller.dart';
import 'package:kozarni_ecome/data/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(7),
          topRight: Radius.circular(7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, -0.05),
          )
        ],
      ),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      controller.changeNav(0);
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.home,
                      color: ((controller.navIndex.value == 0) &&
                              !controller.isPartnerPage.value)
                          ? homeIndicatorColor
                          : null,
                    ),
                  ),
                  Text("Home"),
                ],
              ),
            ),

            Expanded(
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      controller.changeNav(1);
                    },
                    icon: Image.asset(
                      "assets/hotsale.png",
                      color: ((controller.navIndex.value == 1) &&
                              !controller.isPartnerPage.value)
                          ? null
                          : Colors.black,
                    ),
                  ),
                  Text("Hot Sales"),
                ],
              ),
            ),
            // Expanded(
            //   child: Column(
            //     children: [
            //       IconButton(
            //         onPressed: () {
            //           controller.changeNav(1);
            //         },
            //         icon: FaIcon(
            //           FontAwesomeIcons.shirtsinbulk,
            //           color: controller.navIndex.value == 1
            //               ? homeIndicatorColor
            //               : null,
            //         ),
            //       ),
            //       Text("Brand"),
            //     ],
            //   ),
            // ),

            Expanded(
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      controller.changeNav(2);
                    },
                    icon: Stack(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.shoppingCart,
                          color: ((controller.navIndex.value == 2) &&
                                  !controller.isPartnerPage.value)
                              ? homeIndicatorColor
                              : null,
                        ),
                        CircleAvatar(
                            backgroundColor: Colors.orange,
                            minRadius: 0,
                            maxRadius: 10,
                            child: Text(
                              controller.myCart.length.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            )),
                      ],
                    ),
                  ),
                  Text("Cart"),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      controller.changeNav(3);
                    },
                    icon: Icon(
                      FontAwesomeIcons.solidHeart,
                      color: ((controller.navIndex.value == 3) &&
                              !controller.isPartnerPage.value)
                          ? homeIndicatorColor
                          : null,
                    ),
                  ),
                  Text("Favourite"),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      controller.changeNav(4);
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.stickyNote,
                      color: ((controller.navIndex.value == 4) &&
                              !controller.isPartnerPage.value)
                          ? homeIndicatorColor
                          : null,
                    ),
                  ),
                  Text(
                    "My Order",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
