import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kozarni_ecome/controller/home_controller.dart';
import 'package:kozarni_ecome/data/constant.dart';
import 'package:kozarni_ecome/routes/routes.dart';
import 'package:kozarni_ecome/screen/view/brand.dart';
import 'package:kozarni_ecome/screen/view/cart.dart';
import 'package:kozarni_ecome/screen/view/favourite.dart';
import 'package:kozarni_ecome/screen/view/hot.dart';
import 'package:kozarni_ecome/screen/view/home.dart';
import 'package:kozarni_ecome/screen/view/order_history.dart';
import 'package:kozarni_ecome/widgets/bottom_nav.dart';
import 'package:url_launcher/url_launcher.dart';

List<Widget> _template = [
  HomeView(),
  // BrandView(),
  HotView(),
  CartView(),
  FavouriteView(),
  OrderHistory(),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin? fltNotification;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notitficationPermission();
    initMessaging();
  }

  void notitficationPermission() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  void initMessaging() async {
    var androiInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    var iosInit = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);

    fltNotification = FlutterLocalNotificationsPlugin();

    fltNotification!.initialize(initSetting);

    if (messaging != null) {
      print('vvvvvvv');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
  }

  void showNotification(RemoteMessage message) async {
    var androidDetails = AndroidNotificationDetails(
      '1',
      message.notification!.title ?? '',
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF0f90f3),
    );
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await fltNotification!.show(0, message.notification!.title ?? '',
        message.notification!.body ?? '', generalNotificationDetails,
        payload: 'Notification');
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Form(
        child: Drawer(
          child: ListView(
            children: <Widget>[
              //            header
              Obx(() {
                return controller.currentUser.value.value == null
                    ? InkWell(
                        onTap: () {
                          Get.toNamed(loginRoute);
                        },
                        child: ListTile(
                          title: Text('Log in'),
                          leading: Icon(
                            Icons.add_to_home_screen,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : new UserAccountsDrawerHeader(
                        accountName: Text(
                          'Partner',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        accountEmail: Text(
                          '${controller.currentUser.value.value!.email}',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        currentAccountPicture: GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              "assets/shopping.jpeg",
                              height: 60,
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(color: Colors.white),
                      );
              }),
              //       body

              InkWell(
                onTap: () {
                  Get.back();
                  checkInPartner();
                },
                child: ListTile(
                  title: Text('Partnership'),
                  leading: Icon(
                    Icons.vpn_key,
                    color: Colors.indigo,
                  ),
                ),
              ),

              InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text('About Us'),
                  leading: Icon(
                    Icons.person_outline,
                    color: Colors.black,
                  ),
                ),
              ),

              InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text('Favourites'),
                  leading: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ),
              ),

              InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text('Facebook Page'),
                  leading: Icon(
                    Icons.facebook_outlined,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Divider(),

              SizedBox(
                height: 30,
              ),

              Obx(() {
                return controller.currentUser.value.value == null
                    ? const SizedBox(
                        height: 0,
                      )
                    : InkWell(
                        onTap: () {
                          controller.logOut();
                        },
                        child: ListTile(
                          title: Text('Log out'),
                          leading: Icon(
                            Icons.add_to_home_screen,
                            color: Colors.black,
                          ),
                        ),
                      );
              }),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: appBarColor,
        elevation: 0,
        title: Text(
          "HALO FASHION STAR",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            wordSpacing: 3,
            color: appBarTitleColor,
          ),
        ),
        actions: [
          // InkWell(
          //   onTap: () {
          //     ///TODO
          //   },
          //   child: Container(
          //     margin: EdgeInsets.only(right: 10, top: 10, bottom: 10),
          //     padding: EdgeInsets.only(left: 10, right: 10),
          //     alignment: Alignment.center,
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.circular(7),
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.grey[200]!,
          //             spreadRadius: 1,
          //             offset: Offset(0, 1),
          //           )
          //         ]),
          //     child: Icon(
          //       Icons.search,
          //       color: Colors.black,
          //     ),
          //   ),
          // )
          SizedBox(
            width: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                alignment: Alignment.center,
                backgroundColor: MaterialStateProperty.all(Colors.white),
                elevation: MaterialStateProperty.resolveWith<double>(
                  // As you said you dont need elevation. I'm returning 0 in both case
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return 0;
                    }
                    return 0; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () => Get.toNamed(searchScreen),
              child: FaIcon(
                FontAwesomeIcons.search,
                color: Colors.black,
                size: 22,
              ),
            ),
          ),

          ElevatedButton(
            style: ButtonStyle(
              alignment: Alignment.center,
              backgroundColor: MaterialStateProperty.all(Colors.white),
              elevation: MaterialStateProperty.resolveWith<double>(
                // As you said you dont need elevation. I'm returning 0 in both case
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return 0;
                  }
                  return 0; // Defer to the widget's default.
                },
              ),
            ),
            onPressed: () async {
              try {
                await launch('https://m.me/HALOFashionStar');
              } catch (e) {
                print(e);
              }
            },
            child: FaIcon(
              FontAwesomeIcons.facebookMessenger,
              color: Colors.blue,
              size: 23,
            ),
          ),
        ],
      ),
      body: Obx(
        () => controller.isPartnerPage.value
            ? BrandView()
            : _template[controller.navIndex.value],
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
