import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comm/controllers/cart_price_controller.dart';
import 'package:e_comm/models/order_model.dart';
import 'package:e_comm/screens/user_panel/add_reviews_screen.dart';
import 'package:e_comm/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController = Get.put(
    ProductPriceController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Orders',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppConstant.appSecondaryColor,
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [Colors.white, Colors.blueGrey.shade50],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //   ),
        // ),
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance
                  .collection('orders')
                  .doc(user!.uid)
                  .collection('confirmOrders')
                  .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "Error",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(radius: 15),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No orders found!",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (context, index) {
                final orderData = snapshot.data!.docs[index];
                OrderModel orderModel = OrderModel(
                  productId: orderData['productId'],
                  categoryId: orderData['categoryId'],
                  productName: orderData['productName'],
                  categoryName: orderData['categoryName'],
                  salePrice: orderData['salePrice'],
                  fullPrice: orderData['fullPrice'],
                  productImages: orderData['productImages'],
                  deliveryTime: orderData['deliveryTime'],
                  isSale: orderData['isSale'],
                  productDescription: orderData['productDescription'],
                  createdAt: orderData['createdAt'],
                  updatedAt: orderData['updatedAt'],
                  productQuantity: orderData['productQuantity'],
                  productTotalPrice: double.parse(
                    orderData['productTotalPrice'].toString(),
                  ),
                  customerId: orderData['customerId'],
                  status: orderData['status'],
                  customerName: orderData['customerName'],
                  customerPhone: orderData['customerPhone'],
                  customerAddress: orderData['customerAddress'],
                  customerDeviceToken: orderData['customerDeviceToken'],
                );

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Product Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: orderModel.productImages[0],
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) =>
                                    const CupertinoActivityIndicator(),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Order Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                orderModel.productName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Price
                                  Text(
                                    "\Rs: ${orderModel.productTotalPrice.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue,
                                    ),
                                  ),

                                  // Quantity
                                ],
                              ),
                              const SizedBox(height: 4),
                              // Order Status
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Chip(
                                  label: Text(
                                    orderModel.status ? "Delivered" : "Pending",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor:
                                      orderModel.status
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Review Button
                        orderModel.status
                            ? ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                backgroundColor: Colors.blue,
                              ),
                              onPressed:
                                  () => Get.to(
                                    () => AddReviewsScreen(
                                      orderModel: orderModel,
                                    ),
                                  ),
                              icon: const Icon(
                                Icons.rate_review,
                                size: 16,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Review",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
