import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comm/models/product_model.dart';
import 'package:e_comm/screens/user_panel/product_details_screen.dart';
import 'package:e_comm/screens/user_panel/single_category_product_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_comm/models/categories_model.dart';

class FlashSaleWidget extends StatelessWidget {
  const FlashSaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          FirebaseFirestore.instance
              .collection('products')
              .where("isSale", isEqualTo: true)
              .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: Get.height / 5,
            child: Center(child: CupertinoActivityIndicator(radius: 15)),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "No product found!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }
        return SizedBox(
          height: Get.height / 4.3325, // Keeping original height
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Allow horizontal scrolling
            physics: BouncingScrollPhysics(),
            child: Row(
              children: List.generate(snapshot.data!.docs.length, (index) {
                final productData = snapshot.data!.docs[index];
                ProductModel productModel = ProductModel(
                  productId: productData['productId'],
                  categoryId: productData['categoryId'],
                  productName: productData['productName'],
                  categoryName: productData['categoryName'],
                  salePrice: productData['salePrice'],
                  fullPrice: productData['fullPrice'],
                  productImages: productData['productImages'],
                  deliveryTime: productData['deliveryTime'],
                  isSale: productData['isSale'],
                  productDescription: productData['productDescription'],
                  createdAt: productData['createdAt'],
                  updatedAt: productData['updatedAt'],
                );

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 10,
                  ),
                  child: GestureDetector(
                    onTap:
                        () => Get.to(
                          () =>
                              ProductDetailsScreen(productModel: productModel),
                        ),

                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: Get.width / 2.5,
                      height: Get.height / 4.5,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.lightBlue.withOpacity(0.2),
                            Colors.lightBlue,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey.withOpacity(0.3),
                            blurRadius: 2,
                            spreadRadius: 1,
                            offset: Offset(3, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: productModel.productImages[0],
                              height: Get.height / 8.5,
                              width: Get.width / 3,
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) =>
                                      Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            productModel.productName,
                            overflow: TextOverflow.ellipsis, // Avoid overflow
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Rs ${productModel.fullPrice} ",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.red.shade900,
                                  decoration: TextDecoration.lineThrough,
                                  // Adds the strikethrough effect
                                  decorationColor: Colors.red.shade900,
                                  // Change strikethrough color (optional)
                                  decorationThickness:
                                      2, // Adjust thickness of the line (optional)// Highlight price
                                ),
                              ),
                              Text(
                                "|",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),

                              Text(
                                " Rs ${productModel.salePrice}",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Colors.green.shade900, // Highlight price
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
