import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kozarni_ecome/controller/home_controller.dart';
import 'package:kozarni_ecome/widgets/brand_widgets/brand_category.dart';
import 'package:kozarni_ecome/widgets/brand_widgets/brand_items.dart';

class BrandView extends StatelessWidget {
  const BrandView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return WillPopScope(
      onWillPop: () {
        controller.setIsPartnerPage(false);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          final isPartner = controller.currentUser.value.value;
          debugPrint("**********$isPartner");
          if (!(isPartner == null)) {
            return ListView(
              children: [
                // HomePickUp(),
                BrandCategory(),
                BrandItems(),
              ],
            );
          } else {
            return Center(
              child: SizedBox(
                height: 100,
                child: Text("You don't have permission to see this page!"),
              ),
            );
          }
        }),
      ),
    );
  }
}
