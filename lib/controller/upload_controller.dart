import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kozarni_ecome/controller/home_controller.dart';
import 'package:kozarni_ecome/data/constant.dart';
import 'package:kozarni_ecome/model/item.dart';
import 'package:kozarni_ecome/service/api.dart';
import 'package:kozarni_ecome/service/database.dart';

class UploadController extends GetxController {
  final RxBool isUploading = false.obs;

  final HomeController _homeController = Get.find();

  @override
  void onInit() {
    super.onInit();

    if (_homeController.editItem.value.id != null) {
      photoController.text = _homeController.editItem.value.photo;
      photo2Controller.text = _homeController.editItem.value.photo2;
      photo3Controller.text = _homeController.editItem.value.photo3;
      nameController.text = _homeController.editItem.value.name;
      deliverytimeController.text = _homeController.editItem.value.deliverytime;
      brandController.text = _homeController.editItem.value.brand;
      priceController.text = _homeController.editItem.value.price.toString();
      discountpriceController.text = _homeController.editItem.value.discountprice.toString();
      colorController.text = _homeController.editItem.value.color;
      sizeController.text = _homeController.editItem.value.size;
      starController.text = _homeController.editItem.value.star.toString();
      categoryController.text = _homeController.editItem.value.category;
      desc.text = _homeController.editItem.value.desc;
    }
  }

  final Api _api = Api();
  final Database _database = Database();
  final ImagePicker _imagePicker = ImagePicker();

  final RxString filePath = ''.obs;

  final GlobalKey<FormState> form = GlobalKey();

  final TextEditingController photoController = TextEditingController();
  final TextEditingController photo2Controller = TextEditingController();
  final TextEditingController photo3Controller = TextEditingController();
  final TextEditingController deliverytimeController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController desc = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountpriceController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController starController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  Future<void> pickImage() async {
    try {
      final XFile? _file =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (_file != null) filePath.value = _file.path;
    } catch (e) {
      print("pickImage error $e");
    }
  }

  String? validator(String? data) => data?.isEmpty == true ? 'empty' : null;

  Future<void> upload() async {
    if (isUploading.value) return;
    try {
      isUploading.value = true;
      if (form.currentState?.validate() == true
          //  &&

          // filePath.value.isNotEmpty
          ) {
        final DateTime dateTime = DateTime.now();

        // await _api.uploadFile(
        //   filePath.value,
        //   folder: itemUrl,
        //   fileName:
        //       "${dateTime.year}${dateTime.month}${dateTime.day}${dateTime.hour}${dateTime.minute}${dateTime.second}",
        // );

        if (_homeController.editItem.value.id != null) {
          await _database.update(
             _homeController.isOwnBrand ? brandCollection : itemCollection,
            path: _homeController.editItem.value.id!,
            data: _homeController.editItem.value
                .copyWith(
                  newPhoto: photoController.text,
                  newPhoto2: photo2Controller.text,
                  newPhoto3: photo3Controller.text,
                  newDeliveryTime: deliverytimeController.text,
                  newBrand: brandController.text,
                  newName: nameController.text,
                  newColor: colorController.text,
                  newPrice: int.parse(priceController.text),
                  newDiscountPrice: int.parse(discountpriceController.text),
                  newSize: sizeController.text,
                  newStar: int.parse(starController.text),
                  des: desc.text,
                  newCategory: categoryController.text,
                  newIsOwnBrand: _homeController.isOwnBrand,
                )
                .toJson(),
          );
        } else {
          await _database.write(
           _homeController.isOwnBrand ? brandCollection : itemCollection,
            data: ItemModel(
              photo: photoController.text,
              photo2: photo2Controller.text,
              photo3: photo3Controller.text,
              // "${dateTime.year}${dateTime.month}${dateTime.day}${dateTime.hour}${dateTime.minute}${dateTime.second}",
              name: nameController.text,
              brand: brandController.text,
              deliverytime: deliverytimeController.text,
              desc: desc.text,
              price: int.parse(priceController.text),
              discountprice: int.parse(discountpriceController.text),
              color: colorController.text,
              size: sizeController.text,
              star: int.parse(starController.text),
              category: categoryController.text,
              isOwnBrand: _homeController.isOwnBrand,
            ).toJson(),
          );
        }
        isUploading.value = false;
        Get.snackbar('Success', 'Uploaded successfully!');
        filePath.value = '';
        photoController.clear();
        photo2Controller.clear();
        photo3Controller.clear();
        brandController.clear();
        deliverytimeController.clear();
        discountpriceController.clear();
        nameController.clear();
        desc.clear();
        priceController.clear();
        colorController.clear();
        sizeController.clear();
        starController.clear();
        categoryController.clear();
        return;
      }
      isUploading.value = false;
      Get.snackbar('Required', 'Image is required');
    } catch (e) {
      isUploading.value = false;
      print("upload error $e");
    }
  }
}
