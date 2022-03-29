import 'package:get/get.dart';
import 'package:kozarni_ecome/binding/manage_binding.dart';
import 'package:kozarni_ecome/binding/upload_binding.dart';
import 'package:kozarni_ecome/controller/home_controller.dart';
import 'package:kozarni_ecome/screen/blue_tooth_screen.dart';
import 'package:kozarni_ecome/screen/check_out_screen.dart';
import 'package:kozarni_ecome/screen/detail_screen.dart';
import 'package:kozarni_ecome/screen/home_screen.dart';
import 'package:kozarni_ecome/screen/item_upload_screen.dart';
import 'package:kozarni_ecome/screen/manage_item.dart';
import 'package:kozarni_ecome/screen/purchase_screen.dart';
import 'package:kozarni_ecome/screen/search_screen.dart';

import '../intro_screen.dart';
import '../screen/login_screen.dart';

const String introScreen = '/intro-screen';
const String homeScreen = '/home';
const String checkOutScreen = '/checkout';
const String detailScreen = '/detail';
const String uploadItemScreen = '/uploadItemScreen';
const String mangeItemScreen = '/manage-item';
const String purchaseScreen = '/purchase-screen';
const String blueToothScreen = '/bluetooth-screen';
const String searchScreen = '/searchScreen';
const String managePartnerUserScreen = '/managePartnerUserScreen';
const String loginRoute = '/login-route';

List<GetPage> routes = [
  GetPage(
    name: introScreen,
    page: () => OnBoardingPage(),
  ),
  GetPage(
    name: homeScreen,
    page: () => HomeScreen(),
  ),
  GetPage(
    name: checkOutScreen,
    page: () => CheckOutScreen(),
  ),
  GetPage(
    name: detailScreen,
    page: () => DetailScreen(),
  ),
  GetPage(
    name: uploadItemScreen,
    page: () => UploadItem(),
    binding: UploadBinding(),
  ),
  GetPage(
    name: mangeItemScreen,
    page: () => ManageItem(),
    binding: ManageBinding(),
  ),
  GetPage(
    name: purchaseScreen,
    page: () => PurchaseScreen(),
  ),
  GetPage(
    name: blueToothScreen,
    page: () => BlueToothPrintScreen(),
  ),
  GetPage(
    name: searchScreen,
    page: () => SearchScreen(),
  ),
  GetPage(
    name: loginRoute,
    page: () => LoginScreen(),
  ),
];

HomeController _controller = Get.find();
void checkInPartner() {
  if (!(_controller.currentUser.value.value == null)) {
    _controller.setIsPartnerPage(true);
  } else {
    Get.toNamed(loginRoute);
  }
}
