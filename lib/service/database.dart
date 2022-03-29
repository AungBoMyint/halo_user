import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:kozarni_ecome/data/constant.dart';
import 'package:kozarni_ecome/model/purchase.dart';
import 'package:kozarni_ecome/service/api.dart';
import 'package:uuid/uuid.dart';

class Database {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFunctions functions = FirebaseFunctions.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> watch(String collectionPath) =>
      _firebaseFirestore.collection(collectionPath).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> watchOrder(
          String collectionPath) =>
      _firebaseFirestore
          .collection(collectionPath)
          .orderBy('dateTime', descending: true)
          .snapshots();

  Future<DocumentSnapshot<Map<String, dynamic>>> read(
    String collectionPath, {
    String? path,
  }) =>
      _firebaseFirestore.collection(collectionPath).doc(path).get();

  Future<void> write(
    String collectionPath, {
    String? path,
    required Map<String, dynamic> data,
  }) =>
      _firebaseFirestore.collection(collectionPath).doc(path).set(data);

  //Write PurchaseData
  Future<void> writePurchaseData(PurchaseModel model) async {
    if (!(model.bankSlipImage == null)) {
      final file = File(model.bankSlipImage!);
      debugPrint("**************${model.bankSlipImage!}");
      try {
        await _firebaseStorage
            .ref()
            .child("bankSlip/${Uuid().v1()}")
            .putFile(file)
            .then((snapshot) async {
          await snapshot.ref.getDownloadURL().then((value) async {
            final purchaseModel = model.copyWith(bankSlipImage: value).toJson();
            //Then we set this user into Firestore
            await _firebaseFirestore
                .collection(purchaseCollection)
                .doc()
                .set(purchaseModel)
                .then((value) async {
              //We send push after order is uploaded
              try {
                Api.sendPush(
                        "အော်ဒါတင်ခြင်း",
                        "🧑အမည်:${model.name}\n"
                            "🏠လိပ်စာ: ${model.address}\n"
                            "✍အီးမေးလ်: ${model.email}")
                    .then((value) =>
                        debugPrint("*****Success push notification*****"));
              } catch (e) {
                debugPrint("********Push Failed: $e**");
              }
              //We update total order and total revenue
              await updateTotalOrderAndRevenue(model.totalCost);
            });
          });
        });
      } on FirebaseException catch (e) {
        debugPrint("*******Image Upload Error $e******");
      }
    }
    ////////////////////////
    /* if (!(model.bankSlipImage == null)) {
      //if image is not empty or null,we need to store Image FILE
      final file = File(model.bankSlipImage!);
      try {
        await _firebaseStorage
            .ref()
            .child("bankSlipImage/${Uuid().v4}")
            .putFile(file)
            .then((snapshot) async {
          await snapshot.ref.getDownloadURL().then((image) {
            debugPrint("***********get download image url**************");
            model = model.copyWith(bankSlipImage: image);
            _firebaseFirestore
                .collection(purchaseCollection)
                .doc()
                .set(model.toJson());
          });
        });
      } catch (e) {
        debugPrint(
            "**************PurchaseSubmitError and BankSlip $e************");
      }
    }*/
    else {
      try {
        _firebaseFirestore
            .collection(purchaseCollection)
            .doc()
            .set(model.toJson())
            .then((value) async {
          //We send push after order is uploaded
          try {
            Api.sendPush(
                    "အော်ဒါတင်ခြင်း",
                    "🧑အမည်:${model.name}\n"
                        "🏠လိပ်စာ: ${model.address}\n"
                        "✍အီးမေးလ်: ${model.email}")
                .then((value) =>
                    debugPrint("*****Success push notification*****"));
          } catch (e) {
            debugPrint("********Push Failed: $e**");
          }
          //We update total order and total revenue
          await updateTotalOrderAndRevenue(model.totalCost);
        });
      } catch (e) {
        debugPrint("****************PurchseSubmitError $e*************");
      }
    }
  }

  Future<void> update(
    String collectionPath, {
    required String path,
    required Map<String, dynamic> data,
  }) =>
      _firebaseFirestore.collection(collectionPath).doc(path).update(data);

  Future<void> delete(
    String collectionPath, {
    required String path,
  }) =>
      _firebaseFirestore.collection(collectionPath).doc(path).delete();

  //Update TotalOrder and Order Total Revenue
  Future<void> updateTotalOrderAndRevenue(int purchasePrice) async {
    _firebaseFirestore.runTransaction((transaction) async {
      //secure snapshot
      final secureSnapshot = await transaction.get(_firebaseFirestore
          .collection(orderHistoryCollection)
          .doc(orderDocument));

      final int currentTotalOrder = secureSnapshot.get("totalOrder") as int;
      final int currentTotalRevenue = secureSnapshot.get("totalRevenue") as int;

      transaction.update(secureSnapshot.reference, {
        "totalOrder": currentTotalOrder + 1,
        "totalRevenue": currentTotalRevenue + purchasePrice,
      });
    });
  }
}
