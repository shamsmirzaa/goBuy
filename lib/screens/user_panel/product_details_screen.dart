import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:e_comm/controllers/rating_controller.dart';
import 'package:e_comm/models/cart_model.dart';
import 'package:e_comm/models/product_model.dart';
import 'package:e_comm/models/review_model.dart';
import 'package:e_comm/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductModel productModel;

  ProductDetailsScreen({super.key, required this.productModel});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _isExpanded = false;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    CalculateProductRatingController calculateProductRatingController = Get.put(
      CalculateProductRatingController(widget.productModel.productId),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appSecondaryColor,
        title: Text("Product Details", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => CartScreen()),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: Get.height / 60),
            CarouselSlider(
              items:
                  widget.productModel.productImages
                      .map(
                        (imageUrls) => ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            imageUrl: imageUrls,
                            fit: BoxFit.cover,
                            width: Get.width - 10,
                            placeholder:
                                (context, url) => ColoredBox(
                                  color: Colors.white,
                                  child: Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),

                            errorWidget:
                                (context, url, error) =>
                                    Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      )
                      .toList(),
              options: CarouselOptions(
                scrollDirection: Axis.horizontal,
                autoPlay: true,
                aspectRatio: 2.5,
                viewportFraction: 1,
              ),
            ),
            SizedBox(height: 10),
            DotsIndicator(
              dotsCount: widget.productModel.productImages.length,
              position: 0,
              decorator: DotsDecorator(
                activeColor: Colors.black,
                size: const Size.square(8.0),
                activeSize: const Size(18.0, 8.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                color: Colors.white,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.productModel.productName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Icon(Icons.favorite_outline),
                          ],
                        ),
                      ),
                    ),
                    //reviews
                    Obx(
                      () => Row(
                        children: [
                          RatingBar.builder(
                            glow: false,
                            ignoreGestures: true,
                            initialRating:
                                calculateProductRatingController
                                    .averageRating
                                    .value,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 25,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder:
                                (context, _) =>
                                    Icon(Icons.star, color: Colors.amber),
                            onRatingUpdate: (value) {},
                          ),
                          SizedBox(width: 5),
                          Text(
                            calculateProductRatingController.averageRating.value
                                .toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            widget.productModel.isSale == true &&
                                    widget.productModel.isSale != ""
                                ? Text(
                                  "Rs: " + widget.productModel.salePrice,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                : Text(
                                  "Rs: " + widget.productModel.fullPrice,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Category: " + widget.productModel.categoryName,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.productModel.productDescription,
                            maxLines: _isExpanded ? null : 1,
                            // Show 1 line initially
                            overflow:
                                _isExpanded
                                    ? TextOverflow.visible
                                    : TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isExpanded = !_isExpanded; // Toggle expansion
                              });
                            },
                            child: Text(
                              _isExpanded ? "Read Less" : "Read More",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                height: Get.height / 18,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.lightBlue.shade300.withOpacity(1),
                                      Colors.blueAccent.withOpacity(1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    20.0,
                                  ), // Rounded Corners
                                ),

                                child: TextButton(
                                  child: Text(
                                    "WhatsApp",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  onPressed: () {
                                    sendMessageOnWhatsApp(
                                      productModel: widget.productModel,
                                    );
                                    print("whatsapp sent");
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 4), // ✅ Adds spacing between buttons
                          Expanded(
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                height: Get.height / 18,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.lightBlue.shade300.withOpacity(1),
                                      Colors.blueAccent.withOpacity(1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    20.0,
                                  ), // Rounded Corners
                                ),

                                child: TextButton(
                                  child: Text(
                                    "Add to cart",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  onPressed: () async {
                                    // Get.to(() => SignInScreen());

                                    await checkProductExistence(uId: user!.uid);
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //reviews
            FutureBuilder(
              future:
                  FirebaseFirestore.instance
                      .collection('products')
                      .doc(widget.productModel.productId)
                      .collection('reviews')
                      .get(),
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: Get.height / 5,
                    child: Center(child: CupertinoActivityIndicator()),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No reviews found!"));
                }

                if (snapshot.data != null) {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      ReviewModel reviewModel = ReviewModel(
                        customerName: data['customerName'],
                        customerPhone: data['customerPhone'],
                        customerDeviceToken: data['customerDeviceToken'],
                        customerId: data['customerId'],
                        feedback: data['feedback'],
                        rating: data['rating'],
                        createdAt: data['createdAt'],
                      );
                      return Card(
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Customer Avatar
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.blueAccent.withOpacity(
                                  0.2,
                                ),
                                child: Text(
                                  reviewModel.customerName[0].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),

                              // Review Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Customer Name
                                    Text(
                                      reviewModel.customerName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 4),

                                    // Rating Display
                                    Row(
                                      children: [
                                        Row(
                                          children: List.generate(5, (index) {
                                            double ratingValue = double.parse(
                                              reviewModel.rating,
                                            );

                                            if (index < ratingValue.floor()) {
                                              // Full Star
                                              return Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 18,
                                              );
                                            } else if (index < ratingValue) {
                                              // Half-Star with Gray Background
                                              return Stack(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    // Gray full star in the background
                                                    color: Colors.grey.shade400,

                                                    size: 18,
                                                  ),
                                                  Icon(
                                                    Icons.star_half,
                                                    // Half amber star overlay
                                                    color: Colors.amber,
                                                    size: 18,
                                                  ),
                                                ],
                                              );
                                            } else {
                                              // Empty Star
                                              return Icon(
                                                Icons.star,
                                                color: Colors.grey.shade400,
                                                size: 18,
                                              );
                                            }
                                          }),
                                        ),

                                        SizedBox(width: 6),
                                        Text(
                                          reviewModel.rating.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),

                                    // Feedback Text
                                    Text(
                                      reviewModel.feedback,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> sendMessageOnWhatsApp({
    required ProductModel productModel,
  }) async {
    final number = "+919353847695";
    final message =
        "Hello goBuy \n I want to know about this product\n ${productModel.productName}\n${productModel.productId}";

    final Uri uri = Uri.parse(
      'https://wa.me/$number?text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $uri');
      Get.snackbar(
        "Error",
        "Could not open WhatsApp. Please check if it's installed.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  //check product exist or not
  Future<void> checkProductExistence({
    required String uId,
    int quantityIncrement = 1,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.productModel.productId.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    double selectedPrice =
        widget.productModel.isSale
            ? double.parse(widget.productModel.salePrice)
            : double.parse(widget.productModel.fullPrice);

    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];
      int updatedQuantity = currentQuantity + quantityIncrement;
      double totalPrice = selectedPrice * updatedQuantity;
      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice,
      });
      print('product exist');
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(uId).set({
        'uId': uId,
        'CreatedAt': DateTime.now(),
      });
      CartModel cartModel = CartModel(
        productId: widget.productModel.productId,
        categoryId: widget.productModel.categoryId,
        productName: widget.productModel.productName,
        categoryName: widget.productModel.categoryName,
        salePrice: widget.productModel.salePrice,
        fullPrice: widget.productModel.fullPrice,
        productImages: widget.productModel.productImages,
        deliveryTime: widget.productModel.deliveryTime,
        isSale: widget.productModel.isSale,
        productDescription: widget.productModel.productDescription,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        productQuantity: 1,
        productTotalPrice: selectedPrice,
      );

      await documentReference.set(cartModel.toMap());

      print('product added');
    }
  }
}
