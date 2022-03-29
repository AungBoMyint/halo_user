import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kozarni_ecome/controller/home_controller.dart';
import 'package:kozarni_ecome/controller/upload_controller.dart';
import 'package:kozarni_ecome/data/constant.dart';
import 'package:kozarni_ecome/model/item.dart';

class UploadItem extends StatefulWidget {
  const UploadItem({Key? key}) : super(key: key);

  @override
  State<UploadItem> createState() => _UploadItemState();
}

class _UploadItemState extends State<UploadItem> {
  final UploadController controller = Get.find();
  final HomeController homecontroller = Get.find();

  @override
  void dispose() {
    homecontroller.setEditItem(
      ItemModel(
        photo: '',
        photo2: '',
        photo3: '',
        brand: '',
        deliverytime: '',
        discountprice: 0,
        name: '',
        price: 0,
        desc: '',
        color: '',
        size: '',
        star: 0,
        category: '',
        isOwnBrand: false,
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackground,
      appBar: AppBar(
        title: Text(
          "𝐂𝐢𝐧𝐝𝐲 Export & Fashion Clothing Brand",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: appBarTitleColor,
              wordSpacing: 1
          ),
        ),
        elevation: 0,
        backgroundColor: detailBackgroundColor,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back,
            color: appBarTitleColor,
          ),
        ),
      ),
      body: Form(
        key: controller.form,
        child: ListView(
          children: [
            //Option OwnBrand Or Not
            SizedBox(
              height: 50,
              child: GetBuilder<HomeController>(builder: (con) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Export Brand
                    ChoiceChip(
                      selectedColor: Colors.black,
                      label: Text(
                        "Export Brand",
                        style: TextStyle(color: Colors.white),
                      ),
                      selected: con.isOwnBrand == false,
                      onSelected: (selected) =>
                          con.changeOwnBrandOrNot(false, true),
                    ),
                    //Space
                    const SizedBox(width: 10),
                    //Own Brand
                    ChoiceChip(
                      selectedColor: Colors.black,
                      label: Text(
                        "Own Brand",
                        style: TextStyle(color: Colors.white),
                      ),
                      selected: con.isOwnBrand == true,
                      onSelected: (selected) =>
                          con.changeOwnBrandOrNot(true, true),
                    ),
                  ],
                );
              }),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.photoController,
                validator: controller.validator,
                decoration: InputDecoration(
                  hintText: 'Photo Link',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.photo2Controller,
                validator: controller.validator,
                decoration: InputDecoration(
                  hintText: 'Photo Link 2',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.photo3Controller,
                validator: controller.validator,
                decoration: InputDecoration(
                  hintText: 'Photo Link 3',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.nameController,
                validator: controller.validator,
                decoration: InputDecoration(
                  hintText: 'Product အမည်',
                  border: OutlineInputBorder(),
                ),
              ),
            ),



            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                // textInputAction: TextInputAction.done,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 1,
                maxLines: null,

                controller: controller.desc,
                validator: controller.validator,
                decoration: InputDecoration(
                  hintText: 'အသေးစိတ်ဖော်ပြချက်',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.priceController,
                validator: controller.validator,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'လက်လီ ( ၁ ) ထည်ဈေးနှုန်း',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.brandController,
                validator: controller.validator,
                decoration: InputDecoration(
                  hintText: '......ထည် ဈေးနှုန်း (Wholesale) ရေးပေးပါ',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.deliverytimeController,
                validator: controller.validator,
                decoration: InputDecoration(
                  hintText: 'လက်ကား ပုံမှန် ဈေးနှုန်း',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.discountpriceController,
                validator: controller.validator,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'လက်ကားအတွက် လျှော့ထားသော ဈေးနှုန်း',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.colorController,
                validator: controller.validator,
                decoration: InputDecoration(
                  hintText: 'အရောင်',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.sizeController,
                validator: controller.validator,
                decoration: InputDecoration(
                  hintText: 'အရွယ်အစား',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.starController,
                validator: controller.validator,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Star',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.categoryController,
                validator: controller.validator,
                decoration: InputDecoration(
                  hintText: 'အမျိုးအစား',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
              child: ElevatedButton(
                style: buttonStyle,
                onPressed: controller.upload,
                child: Obx(
                  () => controller.isUploading.value
                      ? CircularProgressIndicator(
                          color: scaffoldBackground,
                        )
                      : Text(homecontroller.editItem.value.id != null
                          ? "Edit"
                          : "upload"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
