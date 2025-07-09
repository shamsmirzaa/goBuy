// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CalculateProductRatingController extends GetxController {
  final String productId;
  RxDouble averageRating = 0.0.obs;

  CalculateProductRatingController(this.productId);

  @override
  void onInit() {
    super.onInit();
    calculateAverageRating();
  }

  void calculateAverageRating() {
    FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .get()
        .then((snapshot) {
          print("🔥 Debug: Received ${snapshot.docs.length} reviews.");

          snapshot.docs.forEach((doc) {
            print(
              "Raw Rating: ${doc.data()} | Type: ${doc['rating'].runtimeType}",
            );
          });
        });

    FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .snapshots()
        .listen((snapshot) {
          print("🔥 Snapshot received. Total reviews: ${snapshot.docs.length}");

          if (snapshot.docs.isNotEmpty) {
            double totalRating = 0;
            int numberOfReviews = 0;

            snapshot.docs.forEach((doc) {
              final rawRating =
                  doc.data()['rating']; // ✅ Ensure correct field name
              double? rating;

              // ✅ Handle different data types
              if (rawRating is String) {
                rating = double.tryParse(rawRating);
              } else if (rawRating is num) {
                rating = rawRating.toDouble();
              }

              if (rating != null) {
                totalRating += rating;
                numberOfReviews++;
              }

              print(
                "✅ Processed rating: $rating | Total: $totalRating | Count: $numberOfReviews",
              );
            });

            if (numberOfReviews > 0) {
              averageRating.value = totalRating / numberOfReviews;
              print("🎯 Calculated Average Rating: ${averageRating.value}");
            } else {
              averageRating.value = 0.0;
            }
          } else {
            print("⚠️ No reviews found.");
            averageRating.value = 0.0;
          }
        });
  }
}
