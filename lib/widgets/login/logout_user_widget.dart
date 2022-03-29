import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kozarni_ecome/widgets/login/login_flow.dart';

import '../../controller/home_controller.dart';

class LogOutUser extends StatelessWidget {
  const LogOutUser({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController _controller = Get.find();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            padding: EdgeInsets.only(left: 20, right: 20),
            margin: EdgeInsets.only(top: 20),
            child: Image.asset(
              "assets/shopping.jpeg",
              width: 100,
              height: 100,
            ),
          ),
          //This argument is not necessarily but to change widget flow
          Obx(() => LoginFlowWidget(authState: _controller.authState.value,))
        ],
      ),
    );
  }
}