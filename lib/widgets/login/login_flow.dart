import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kozarni_ecome/controller/home_controller.dart';
import 'package:kozarni_ecome/data/constant.dart';

class LoginFlowWidget extends StatelessWidget {
  final ApplicationLoginState authState;
  const LoginFlowWidget({Key? key, required this.authState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find();
    switch (controller.authState.value) {
      case ApplicationLoginState.unauthenticate:
        return emailTextFieldWidget(controller);
      case ApplicationLoginState.password:
        return passwordWidget(
          controller,
          buttonText: "Login",
          callBack: controller.signInUser,
        );
      default:
        return Center(child: Text("Something Wrong!"));
    }
  }

  //Email TextField Widget
  Widget emailTextFieldWidget(HomeController controller) {
    return AnimatedContainer(
        duration: Duration(seconds: 1),
        width: double.infinity,
        height: 150,
        margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          TextFormField(
            autofocus: true,
            validator: controller.validator,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter your emailaddress.",
            ),
            controller: controller.emailController,
          ),
          //Space
          const SizedBox(
            height: 15,
          ),
          //Cancel and Next
          SizedBox(
            height: 50,
            child:
                //Next Button
                ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(homeIndicatorColor),
              ),
              onPressed: () =>
                  controller.sendEmail(controller.emailController.text),
              child: Text("Verify"),
            ),
          )
        ]));
  }

  Widget passwordWidget(HomeController controller,
      {required String buttonText, required void Function() callBack}) {
    return AnimatedContainer(
        duration: Duration(seconds: 1),
        width: double.infinity,
        height: 150,
        margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter your password.",
            ),
            controller: controller.passwordController,
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(homeIndicatorColor),
            ),
            onPressed: callBack,
            child: Text(buttonText),
          ),
        ]));
  }
}
