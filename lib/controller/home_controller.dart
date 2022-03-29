import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kozarni_ecome/data/constant.dart';
import 'package:kozarni_ecome/data/enum.dart';
import 'package:kozarni_ecome/model/custom_claim_obj.dart';
import 'package:kozarni_ecome/model/hive_item.dart';
import 'package:kozarni_ecome/model/item.dart';
import 'package:kozarni_ecome/model/purchase.dart';
import 'package:kozarni_ecome/service/api.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:kozarni_ecome/service/auth.dart';
import 'package:kozarni_ecome/service/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../model/auth_user.dart';
import '../model/hive_purchase.dart';

class HomeController extends GetxController {
  final Auth _auth = Auth();
  final Database _database = Database();
  final Api _api = Api();
  final ImagePicker _imagePicker = ImagePicker();

  final RxBool authorized = false.obs;
  var currentUser = Rxn<User?>().obs;

  final RxBool phoneState = false.obs;
  final codeSentOnWeb = false.obs; //codeSentOnWeb on Web
  final TextEditingController _phoneCodeController =
      TextEditingController(); //On Web
  late SharedPreferences
      sharedPref; //Share Preference to Store User's Order Data
  String? townshipName; //Township Name
  var paymentOptions = PaymentOptions.None.obs; //Payment Option Initial Value
  var checkOutStep = 0.obs; //Check Out Step
  var bankSlipImage = "".obs;
  Map<String, dynamic> townShipNameAndFee = {}; //Township Name and Fee

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController verificationController = TextEditingController();

  final RxString _codeSentId = ''.obs;
  final RxInt _codeSentToken = 0.obs;

  final RxList<PurchaseItem> myCart = <PurchaseItem>[].obs;
  var isPartnerPage = false.obs;

  bool isOwnBrand = false;
  int mouseIndex = -1; //Mouse Region

  var purchaseId = "".obs;
  Box<HivePurchase> purchaseHiveBox =
      Hive.box(purchaseBox); //Current User's Order History Database

  void setPurchaseId(String id) {
    if (purchaseId.value == id) {
      purchaseId.value = "";
    } else {
      purchaseId.value = id;
    }
  }

  void setIsPartnerPage(bool val) {
    isPartnerPage.value = val;
  }

  void changeMouseIndex(int i) {
    // Change Mouse Region
    mouseIndex = i;
    debugPrint("On Mouse Exist************");
    update();
  }

  //BlueToothPrint Instance
  //BluetoothPrint blueToothPrint = BluetoothPrint.instance;
  //BlueToothDevice
  //BluetoothDevice? blueToothDevice;

  //Set Device and Connect
  /* void setDeviceAndConnect(BluetoothDevice device) {
    blueToothDevice = device;
    if (!(blueToothDevice == null)) {
      //We connect
      blueToothPrint.connect(blueToothDevice!);
    }
    update();
  }*/

  //Chage OwnBand
  void changeOwnBrandOrNot(bool value, bool isUpdate) {
    isOwnBrand = value;
    if (isUpdate) {
      update();
    }
  }

  //Set Shipping Fee
  void setTownshipName(String? val) {
    townshipName = val!;
    update();
  }

  //Set Township Name
  void setTownShipNameAndShip({required String name, required String fee}) {
    townShipNameAndFee = {
      "townName": name,
      "fee": int.parse(fee),
    };
    update();
  }

  //Change Payment Option
  void changePaymentOptions(PaymentOptions option) {
    paymentOptions.value = option;
  }

  //Change Step Index
  void changeStepIndex(int value) {
    checkOutStep.value = value;
  }

  //Set Bank Slip Image
  void setBankSlipImage(String image) {
    bankSlipImage.value = image;
  }

  void addToCart(ItemModel itemModel, String color, String size) {
    final isHotSales =
        itemModel.category == "Hot Sales"; //This is Sensitive Variable,
    try {
      //We try this item have already include inside cart.
      final PurchaseItem _item = myCart.firstWhere((item) =>
          item.id == itemModel.id && item.color == color && item.size == size);
      myCart.value = myCart.map((element) {
        if (_item.id == element.id) {
          //If do so,we increase count + 1.change showcasePrice
          //upon current count only this is not holeSale product and brand product.
          return PurchaseItem(
            id: element.id,
            itemName: element.itemName,
            count: element.count + 1,
            size: element.size,
            color: element.color,
            priceType: element.priceType,
            isOwnBrand: element.isOwnBrand,
            isHotDeal: element.isHotDeal,
            retailPrice: element.retailPrice,
            wholesalePrice: element.wholesalePrice,
            showcaseMap: ((element.count + 1 >= 10) &&
                    !isHotSales &&
                    !element.isOwnBrand)
                ? {
                    "price": element.wholesalePrice,
                    "text": priceList[1],
                  }
                : {
                    "price": element.retailPrice,
                    "text": priceList[0],
                  },
          );
        }
        return element;
      }).toList();
    } catch (e) {
      //Try fail,so this is initial item
      myCart.add(PurchaseItem(
        id: itemModel.id!,
        itemName: itemModel.name,
        count: 1,
        size: size,
        color: color,
        priceType: "",
        isOwnBrand: itemModel.isOwnBrand,
        isHotDeal: isHotSales,
        retailPrice: itemModel.price,
        wholesalePrice: itemModel.discountprice,
        showcaseMap: {
          "price": itemModel.price,
          "text": priceList[0],
        }, //Because this is initial item
      ));
    }
  }

  final RxList<ItemModel> items = <ItemModel>[].obs;
  final RxList<ItemModel> brandItems = <ItemModel>[].obs; //Brand Item
  final RxList<ItemModel> exportAndBrandItems = <ItemModel>[].obs;
  final RxList<ItemModel> searchitems = <ItemModel>[].obs;

  //set export and brand items when edit page start
  void setExportAndBrandItems() {
    exportAndBrandItems
      ..addAll(items)
      ..addAll(brandItems);
  }

  final Rx<ItemModel> selectedItem = ItemModel(
    photo: '',
    photo2: '',
    photo3: '',
    deliverytime: '',
    brand: '',
    discountprice: 0,
    name: '',
    price: 0,
    color: '',
    desc: '',
    size: '',
    star: 0,
    category: '',
    isOwnBrand: false,
  ).obs;

  void setSelectedItem(ItemModel item) {
    selectedItem.value = item;
  }

  final Rx<ItemModel> editItem = ItemModel(
    photo: '',
    photo2: '',
    photo3: '',
    deliverytime: '',
    brand: '',
    discountprice: 0,
    name: '',
    price: 0,
    color: '',
    desc: '',
    size: '',
    star: 0,
    category: '',
    isOwnBrand: false,
  ).obs;

  void setEditItem(ItemModel itemModel) {
    editItem.value = itemModel;
  }

  ItemModel getItem(String id) {
    try {
      return items.firstWhere((e) => e.id == id);
    } catch (e) {
      return ItemModel(
        photo: '',
        photo2: '',
        photo3: '',
        deliverytime: '',
        brand: '',
        discountprice: 0,
        name: '',
        price: 0,
        color: '',
        desc: '',
        size: '',
        star: 0,
        category: '',
        isOwnBrand: false,
      );
    }
  }

  //Get Brand Item
  ItemModel getBrandItem(String id) {
    try {
      return brandItems.firstWhere((e) => e.id == id);
    } catch (e) {
      return ItemModel(
        photo: '',
        photo2: '',
        photo3: '',
        deliverytime: '',
        brand: '',
        discountprice: 0,
        name: '',
        price: 0,
        color: '',
        desc: '',
        size: '',
        star: 0,
        category: '',
        isOwnBrand: false,
      );
    }
  }

  List<ItemModel> getItems() => category.value == 'All'
      ? items
      : items.where((e) => e.category == category.value).toList();

  //GetBrandItems
  List<ItemModel> getBrandItems() => brandCategory.value == 'All'
      ? brandItems
      : brandItems.where((e) => e.category == brandCategory.value).toList();

  List<String> categoryList() {
    final List<String> _data = [
      'All',
    ];

    for (var i = 0; i < items.length; i++) {
      if (!_data.contains(items[i].category)) {
        _data.add(items[i].category);
      }
    }

    if (items.isEmpty) {
      _data.clear();
    }
    return _data;
  }

  //Brand Category List
  List<String> brandCategoryList() {
    final List<String> _data = [
      'All',
    ];

    for (var i = 0; i < brandItems.length; i++) {
      if (!_data.contains(brandItems[i].category)) {
        _data.add(brandItems[i].category);
      }
    }

    if (brandItems.isEmpty) {
      _data.clear();
    }
    return _data;
  }

  List<ItemModel> pickUp() =>
      items.where((e) => e.category == 'New Products').toList();

  List<ItemModel> hot() =>
      items.where((e) => e.category == 'Hot Sales').toList();

  void removeItem(String id) => items.removeWhere((item) => item.id == id);

  //int shipping() => myCart.isEmpty ? 0 : shippingFee;

  void addCount(PurchaseItem p) {
    myCart.value = myCart.map((element) {
      if (element.id == p.id &&
          element.color == p.color &&
          element.size == p.size &&
          element.isHotDeal == p.isHotDeal) {
        return p.copyWith(
          //we only need to change count and showCasePrice
          count: element.count + 1,
          showcaseMap:
              ((element.count + 1 >= 10) && !p.isHotDeal && !element.isOwnBrand)
                  ? {
                      "price": element.wholesalePrice,
                      "text": priceList[1],
                    }
                  : {
                      "price": element.retailPrice,
                      "text": priceList[0],
                    },
        );
      }
      return element;
    }).toList();
    update([myCart]);
    updateSubTotal(true);
  }

  void remove(PurchaseItem p) {
    bool needToRemove = false;
    myCart.value = myCart.map((element) {
      if (element.id == p.id &&
          element.color == p.color &&
          element.size == p.size) {
        if (element.count > 1) {
          return p.copyWith(
            count: element.count - 1,
            showcaseMap: ((element.count - 1 >= 10) &&
                    !p.isHotDeal &&
                    !element.isOwnBrand)
                ? {
                    "price": element.wholesalePrice,
                    "text": priceList[1],
                  }
                : {
                    "price": element.retailPrice,
                    "text": priceList[0],
                  },
          );
        }
        needToRemove = true;
        return element;
      }
      return element;
    }).toList();
    if (needToRemove) {
      myCart.removeWhere((element) =>
          element.id == p.id &&
          element.color == p.color &&
          element.size == p.size);
    }
    updateSubTotal(true);
  }

  var totalUsualPrice = 0.obs;
  var totalHotPrice = 0.obs;
  var totalUsualProductCount = 0.obs;
  var totalHotProductCount = 0.obs;

  int subTotal = 0;
  void updateSubTotal(bool isUpdate) {
    if (subTotal != 0) {
      subTotal = 0;
    }
    //int price = 0;
    int usualPrice = 0;
    int hotSalePrice = 0;
    int ownBrandPrice = 0;
    int hotSaleCount = 0;
    int usualSaleCount = 0;
    for (var i = 0; i < myCart.length; i++) {
      if (!myCart[i].isOwnBrand && myCart[i].isHotDeal) {
        hotSalePrice +=
            int.parse("${(myCart[i].showcaseMap["price"] * myCart[i].count)}");
        hotSaleCount += myCart[i].count;
      } else if (!myCart[i].isOwnBrand && !myCart[i].isHotDeal) {
        usualPrice +=
            int.parse("${myCart[i].showcaseMap["price"] * myCart[i].count}");
        usualSaleCount += myCart[i].count;
      } else {
        ownBrandPrice +=
            int.parse("${myCart[i].showcaseMap["price"] * myCart[i].count}");
      }
    } //When Loop is complete we calculate all criteria

    subTotal = usualPrice + hotSalePrice + ownBrandPrice;
    totalUsualPrice.value =
        usualPrice; //We also need to change this to update UI.
    totalHotPrice.value = hotSalePrice;
    totalUsualProductCount.value = usualSaleCount;
    totalHotProductCount.value = hotSaleCount;
    debugPrint("*************$subTotal");
    if (isUpdate) {
      update();
    }
  }

  //Get HiveItem
  HiveItem changeHiveItem(ItemModel model) {
    return HiveItem(
      id: model.id ?? "",
      photo: model.photo,
      photo2: model.photo2,
      photo3: model.photo3,
      name: model.name,
      brand: model.brand,
      deliverytime: model.deliverytime,
      price: model.price,
      discountprice: model.discountprice,
      desc: model.desc,
      color: model.color,
      size: model.size,
      star: model.star,
      category: model.category,
      isOwnBrand: model.isOwnBrand,
    );
  }

  //Get ItemModel
  ItemModel changeItemModel(HiveItem model) {
    return ItemModel(
      id: model.id,
      photo: model.photo,
      photo2: model.photo2,
      photo3: model.photo3,
      name: model.name,
      brand: model.brand,
      deliverytime: model.deliverytime,
      price: model.price,
      discountprice: model.discountprice,
      desc: model.desc,
      color: model.color,
      size: model.size,
      star: model.star,
      category: model.category,
      isOwnBrand: model.isOwnBrand,
    );
  }

  final RxList<PurchaseModel> _purchcases = <PurchaseModel>[].obs; ////

  List<PurchaseModel> purchcasesCashOn() {
    return _purchcases.where((item) => item.bankSlipImage == null).toList();
  }

  List<PurchaseModel> purchcasesPrePay() {
    return _purchcases.where((item) => item.bankSlipImage != null).toList();
  } //////////////////

  final RxBool isLoading = false.obs;

  Future<void> proceedToPay() async {
    if (isLoading.value) return;
    isLoading.value = true;
    Get.back();
    try {
      final list = getUserOrderData();
      final total = subTotal + townShipNameAndFee["fee"] as int;
      final _purchase = PurchaseModel(
        items: myCart
            .map((cart) =>
                "${cart.id},${cart.itemName},${cart.color},${cart.size},${cart.count},${cart.showcaseMap["price"]}")
            .toList(),
        name: list[0],
        email: list[1],
        phone: int.parse(list[2]),
        address: list[3],
        bankSlipImage: bankSlipImage.value.isEmpty ? null : bankSlipImage.value,
        deliveryTownshipInfo: [
          townShipNameAndFee["townName"],
          townShipNameAndFee["fee"]
        ],
        totalCost: total,
      );
      final hivePurchase = HivePurchase(
        id: Uuid().v1(),
        items: _purchase.items,
        totalPrice: total,
        deliveryTownshipInfo: _purchase.deliveryTownshipInfo,
        dateTime: DateTime.now(),
      );
      await _database.writePurchaseData(_purchase).then((value) {
        Get.snackbar("လူကြီးမင်း Order တင်ခြင်း", 'အောင်မြင်ပါသည်');
        purchaseHiveBox.put(hivePurchase.id, hivePurchase);
      }); //submit success
      myCart.clear();
      navIndex.value = 0;
      update([myCart, navIndex]);
    } catch (e) {
      Get.snackbar("လူကြီးမင်း Order တင်ခြင်း", 'မအောင်မြင်ပါ');
      print("proceed to pay error $e");
    }
    //Get.back();
    isLoading.value = false;
  }

  Future<void> logout() async {
    try {
      await _auth.logout();
    } catch (e) {
      print("logout error is $e");
    }
  }

  //Get User's Order Data
  List<String> getUserOrderData() {
    return sharedPref.getStringList("userOrder") ?? [];
  }

  //Set User's Order Data or Not
  Future<void> setUserOrderData({
    required String name,
    required String email,
    required String phone,
    required String address,
  }) async {
    //Making Purchase Model
    try {} catch (e) {}
    final list = getUserOrderData();
    //Check data already contain with the same data inside SharedPreference
    if (list.isEmpty) {
      await sharedPref
          .setStringList("userOrder", [name, email, phone, address]);
    } else if ( //Something is changed by User,then we restore
        (name != list[0]) ||
            (email != list[1]) ||
            (phone != list[2]) ||
            (address != list[3])) {
      await sharedPref
          .setStringList("userOrder", [name, email, phone, address]);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    sharedPref = await SharedPreferences.getInstance();
    if (getUserOrderData().isNotEmpty) {
      checkOutStep.value = 1;
    } // SharedPreference to Stroe
    _database.watch(itemCollection).listen((event) {
      items.value =
          event.docs.map((e) => ItemModel.fromJson(e.data(), e.id)).toList();
      exportAndBrandItems.addAll(items);
    });
    //For Branch Collection
    _database.watch(brandCollection).listen((event) {
      brandItems.value =
          event.docs.map((e) => ItemModel.fromJson(e.data(), e.id)).toList();
      exportAndBrandItems.addAll(brandItems);
    });

    ///
    _auth.onAuthChange().listen((user) async {
      if (!(user == null)) {
        authState.value = ApplicationLoginState.authenticated;
        _auth.gettokenResult().then((value) {
          if (value.claims?["isPartnerUser"] == true) {
            //When user is partner user,
            currentUser.value.value = user;
            debugPrint("********CustomClaims: ${value.claims}*********");
            debugPrint("********Email: ${value.claims?["email"]}*********");
          }
        });
      } else {
        currentUser.value.value = null;
        authState.value = ApplicationLoginState.unauthenticate;
        debugPrint("************User is NULL***********");
      }
    });

    //Listen BlueTooth State
    /*blueToothPrint.state.listen((event) {
      switch (event) {
        case BluetoothPrint.CONNECTED:
          Get.showSnackbar(GetBar(message: "Connected"));
          break;
        case BluetoothPrint.DISCONNECTED:
          Get.showSnackbar(GetBar(message: "Disconnected"));
          break;
        default:
          break;
      }
    });*/
  }

  final RxInt navIndex = 0.obs;

  void changeNav(int i) {
    if (isPartnerPage.value) {
      isPartnerPage.value = false;
    }
    ;
    navIndex.value = i;
  }

  final RxString category = 'All'.obs;
  final RxString brandCategory = 'All'.obs; //BrandCategory

  void changeCat(String name) {
    category.value = name;
  }

  //Change Brand Cat
  void changeBrandCat(String name) {
    brandCategory.value = name;
  }

  final RxBool isSearch = false.obs;

  void search() => isSearch.value = !isSearch.value;

  void onSearch(String name) {
    isSearch.value = true;
    searchitems.value = exportAndBrandItems
        .where((p0) => p0.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  void clear() => isSearch.value = false;

  void searchItem(String name) {
    isSearch.value = !isSearch.value;
  }

  //Check weather show dialog or not
  showDialogToEnterPhoneCode(void Function(String code) callBack) {
    final size = MediaQuery.of(Get.context!).size;
    Get.defaultDialog(
      title: "Phone Verification",
      content: SizedBox(
        height: size.height * 0.2,
        width: size.width * 0.2,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Text FIELD
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: TextFormField(
                  controller: _phoneCodeController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your code',
                  ),
                ),
              ),
              //Space
              const SizedBox(height: 10),
              //CONFIRM
              TextButton(
                onPressed: () {
                  //CALL BACK TO ORIGINAL SIGNINWITHPHONENUMBER
                  callBack(_phoneCodeController.text);
                  Get.back();
                },
                child: Text("Confirm"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var authState = ApplicationLoginState.unauthenticate.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var isPassword = false.obs;
  ///////////////////////
  String? validator(value) => value.isNotEmpty ? null : "required";
  void startLoginFlow() {
    authState.value = ApplicationLoginState.emailAddress;
  }

  void logOut() {
    _auth.signOutUser();
    //We need to setPartnerPage to false,if user is inside partnership page
    setIsPartnerPage(
        false); //Because partner page is ViewPage not a Scaffold Screen Page,
    //If Partner page is RoutePage we don't to user this.
  }

  void sendEmail(email) {
    if (email.isNotEmpty) {
      _auth.verifyEmail(email, (state) {
        authState.value = state;
      });
    }
  }

  void cancelEmail() {
    authState.value = ApplicationLoginState.unauthenticate;
  }

  bool isFormValidated() =>
      (emailController.text.isNotEmpty) && (passwordController.text.isNotEmpty);
  void signInUser() {
    if (isFormValidated()) {
      _auth.signIn(
          email: emailController.text, password: passwordController.text);
    }
  }
}
