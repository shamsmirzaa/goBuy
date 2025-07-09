import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comm/models/order_model.dart';
import 'package:e_comm/models/review_model.dart';
import 'package:e_comm/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddReviewsScreen extends StatefulWidget {
  final OrderModel orderModel;

  const AddReviewsScreen({super.key, required this.orderModel});

  @override
  State<AddReviewsScreen> createState() => _AddReviewsScreenState();
}

class _AddReviewsScreenState extends State<AddReviewsScreen> {
  final TextEditingController feedbackController = TextEditingController();
  double productRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: AppConstant.appSecondaryColor,
        title: const Text(
          "Add Review",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Product Image
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.orderModel.productImages[0],
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.orderModel.productName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Rs: ${widget.orderModel.productTotalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Rating Section
            const Text(
              "Rate this product",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder:
                  (context, _) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                setState(() {
                  productRating = rating;
                });
              },
            ),
            const SizedBox(height: 20),

            // Feedback Input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: TextField(
                controller: feedbackController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Write your feedback...",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: AppConstant.appSecondaryColor,
                  elevation: 4,
                ),
                onPressed: () async {
                  if (productRating == 0) {
                    EasyLoading.showError('Please provide a rating');
                    return;
                  }
                  EasyLoading.show(status: 'Submitting review...');

                  String feedback = feedbackController.text.trim();
                  User? user = FirebaseAuth.instance.currentUser;

                  ReviewModel reviewModel = ReviewModel(
                    customerName: widget.orderModel.customerName,
                    customerPhone: widget.orderModel.customerPhone,
                    customerDeviceToken: widget.orderModel.customerDeviceToken,
                    customerId: widget.orderModel.customerId,
                    feedback: feedback,
                    rating: productRating.toString(),
                    createdAt: DateTime.now(),
                  );

                  await FirebaseFirestore.instance
                      .collection('products')
                      .doc(widget.orderModel.productId)
                      .collection('reviews')
                      .doc(user!.uid)
                      .set(reviewModel.toMap());

                  EasyLoading.dismiss();
                  Navigator.pop(context);
                  EasyLoading.showSuccess('Review submitted!');
                },
                child: const Text(
                  "Submit Review",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
