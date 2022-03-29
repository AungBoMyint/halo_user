import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kozarni_ecome/controller/home_controller.dart';
import 'package:kozarni_ecome/data/constant.dart';
import 'package:kozarni_ecome/model/hive_item.dart';
import 'package:kozarni_ecome/routes/routes.dart';

class FavouriteView extends StatefulWidget {
  const FavouriteView({Key? key}) : super(key: key);

  @override
  _FavouriteViewState createState() => _FavouriteViewState();
}

class _FavouriteViewState extends State<FavouriteView> {
  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find();
    return ValueListenableBuilder(
      valueListenable: Hive.box<HiveItem>(boxName).listenable(),
      builder: (context, Box<HiveItem> box, widget) {
        return box.isNotEmpty
            ? ListView(
                children: box.values
                    .map(
                      (hiveItem) {
                        return Dismissible(
                          key: Key(hiveItem.name),
                          background: Container(
                            color: Colors.black12,
                          ),
                          onDismissed: (direction) {
                            box.delete(hiveItem.id);
                          },
                          direction: DismissDirection.startToEnd,
                          child: Card(
                            child: ListTile(
                              onTap: () {
                                //TODO: GO TO DETAIL AND CHANGE OBJECT
                                controller.setSelectedItem(
                                    controller.changeItemModel(hiveItem));
                                Get.toNamed(detailScreen);
                              },
                              title: Text(
                                hiveItem.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text("${hiveItem.price} kyats"),
                              trailing: AspectRatio(
                                aspectRatio: 1,
                                child: Hero(
                                  tag: hiveItem.photo,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: CachedNetworkImage(
                                      imageUrl: hiveItem.photo,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                    .toList()
                    .reversed
                    .toList(),
              )
            : Center(child: Text("No Favourite List"));
      },
    );
  }
}
