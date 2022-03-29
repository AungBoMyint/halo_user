import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kozarni_ecome/controller/home_controller.dart';
import 'package:kozarni_ecome/data/constant.dart';

class BrandCategory extends StatelessWidget {
  const BrandCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return Container(
      width: double.infinity,
      height: 40,

      // color: Colors.green,
      child: Obx(
        () => controller.brandCategoryList().isEmpty
            ? Container()
            : ListView.builder(
                padding: EdgeInsets.only(left: 20),
                scrollDirection: Axis.horizontal,
                itemCount: controller.brandCategoryList().length,
                itemBuilder: (_, i) => Container(
                  margin: EdgeInsets.only(
                    top: 3,
                    bottom: 3,
                    right: 20,
                  ),
                  child: Obx(
                    () => ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: controller.brandCategory.value ==
                                controller.brandCategoryList()[i]
                            ? MaterialStateProperty.all(homeIndicatorColor)
                            : MaterialStateProperty.all(Colors.white),
                        foregroundColor: controller.brandCategory.value ==
                                controller.brandCategoryList()[i]
                            ? MaterialStateProperty.all(Colors.white)
                            : MaterialStateProperty.all(Colors.black),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      onPressed: () {
                        controller.changeBrandCat(controller.brandCategoryList()[i]);
                      },
                      child: Text(
                        controller.brandCategoryList()[i],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}


// Container(
//           margin: EdgeInsets.only(
//             right: 10,
//             top: 7,
//             bottom: 7,
//           ),
//           padding: EdgeInsets.only(left: 20, right: 20),
//           height: 50,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: homeIndicatorColor,
//             borderRadius: BorderRadius.circular(30),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black26,
//                 spreadRadius: 1,
//                 blurRadius: 1,
//                 offset: Offset(0, 1),
//               )
//             ],
//           ),
//           child: Text(
//             category[i],
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//             ),
//           ),
//         )
