import 'package:flutter/material.dart';

const Color scaffoldBackground = Colors.white;
const Color appBarColor = Colors.white;
const Color appBarTitleColor = Color.fromRGBO(19, 19, 19, 1);
const Color homeIndicatorColor = Color.fromRGBO(247, 98, 16, 1);
const Color detailBackgroundColor = Colors.white;
const Color detailTextBackgroundColor = Colors.white;
ButtonStyle buttonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Colors.orange),
);

const String baseUrl = 'http://192.168.1.5:5000/api/v1/streaming/movie/';
const String profileUrl = 'profile/';
const String itemUrl = 'item/';

const String userCollection = 'users';
const String profileCollection = 'profiles';
const String itemCollection = 'items';
const String purchaseCollection = 'purchases';
const String brandCollection = 'brandProducts';
const List<String> priceList = [
  "၁ ထည်ဈေးနှုန်း",
  "၁၀ ထည်ဈေးနှုန်း",
];
const String boxName = "favouritesBOX";

enum ApplicationLoginState {
  emailAddress,
  password,
  signIn,
  authenticated,
  unauthenticate,
}

const String fcmKey =
    "AAAA0UBm5_g:APA91bG57qaiHiNy6itjy7tvzNy3zve87KNyM_T3HkQNfQN3mUID7ZnDOqjDBRxCpwnE9Y2cwdIGLW0o6PweVcLFnOkwxbvLuqwbdd-dyImKFvpI4z63hntNBBe6HO1JuJQsIbIE74Z1";

const orderHistoryCollection = "orderHistoryCollection";
const orderDocument = "orderHistoryDocument";
const String purchaseBox = "purchaseBox";
