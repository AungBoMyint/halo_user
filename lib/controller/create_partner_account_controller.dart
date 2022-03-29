import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kozarni_ecome/controller/home_controller.dart';

class CreatePartnerAccountController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  HomeController _controller = Get.find();

  String? validator(String? data) => data?.isEmpty == true ? 'empty' : null;
  var isUploading = false.obs;

  Future<void> createPartnerAccount() async {
    if (formKey.currentState?.validate() == true) {
      isUploading.value = true;
      try {
        //Phone login complete,we call our admin cloud function
        HttpsCallable callable =
            FirebaseFunctions.instanceFor(region: "asia-southeast2")
                .httpsCallable('createPartnerAccount');
        callable.call(<String, dynamic>{
          'email': emailController.text,
          'password': passwordController.text,
        }).then((value) {
          isUploading.value = false;
          Get.back();
        });
      } on FirebaseFunctionsException catch (e) {
        debugPrint(
            "*********************FirebaseFunctionError: ${e.code} \n************");
      }
    }
  }
}
