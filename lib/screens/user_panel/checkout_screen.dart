import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comm/controllers/cart_price_controller.dart';
import 'package:e_comm/controllers/get_customer_device_token_controller.dart';
import 'package:e_comm/models/cart_model.dart';
import 'package:e_comm/services/get_server_key.dart';
import 'package:e_comm/services/place_order_screen.dart';
import 'package:e_comm/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController = Get.put(
    ProductPriceController(),
  );

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Checkout', style: TextStyle(color: Colors.white)),
        backgroundColor: AppConstant.appSecondaryColor,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('cart')
                .doc(user!.uid)
                .collection('cartOrders')
                .snapshots(),
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
          if (snapshot.data != null) {
            // return Card(
            //   child: Container(
            //     height: 100,
            //     width: double.infinity,
            //     child: Text("jishad"),
            //   ),
            // );
            return Container(
              // decoration: BoxDecoration(
              //   gradient: LinearGradient(
              //     colors: [
              //       Colors.white,
              //       Colors.blueGrey.shade50, // Light background color
              //       // Colors.white,
              //     ],
              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomCenter,
              //   ),
              // ),
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];
                  CartModel cartModel = CartModel(
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
                    productQuantity: productData['productQuantity'],
                    productTotalPrice: productData['productTotalPrice'],
                  );

                  productPriceController.fetchProductPrice();

                  return SwipeActionCell(
                    key: ObjectKey(cartModel.productId),
                    backgroundColor: Colors.transparent, // Add this line
                    trailingActions: [
                      SwipeAction(
                        title: "Delete",
                        forceAlignmentToBoundary: true,
                        performsFirstActionWithFullSwipe: true,
                        onTap: (CompletionHandler handler) async {
                          await FirebaseFirestore.instance
                              .collection('cart')
                              .doc(user!.uid)
                              .collection('cartOrders')
                              .doc(cartModel.productId)
                              .delete();
                          print('Deleted');
                        },
                      ),
                    ],

                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: AppConstant.appSecondaryColor,
                          backgroundImage: NetworkImage(
                            cartModel.productImages[0],
                          ),
                        ),
                        title: Text(
                          cartModel.productName.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Align text to the left
                              children: [
                                Text(
                                  cartModel.productTotalPrice.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  cartModel.productQuantity.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Container();
        },
      ),

      //
      bottomNavigationBar: Container(
        height: Get.height / 10,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              spreadRadius: 3,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Price:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Obx(
                  () => Text(
                    "Rs: ${productPriceController.totalPrice.value.toStringAsFixed(1)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                // showCustomBottomSheet();
                GetServerKey getServerKey = GetServerKey();
                String accessToken = await getServerKey.getServerKeyToken();
                print(accessToken);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 6,
                // Floating effect
                shadowColor: Colors.blueAccent.withOpacity(0.4),
              ),
              child: Row(
                children: [
                  Icon(Icons.shopping_bag, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Confirm Order",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomBottomSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.95,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Indicator
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 15),

                // Title
                Text(
                  "Complete Your Order",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),

                // Input Fields
                _buildTextField(
                  label: "Name",
                  icon: Icons.person,
                  controller: nameController,
                ),
                SizedBox(height: 15),
                _buildTextField(
                  label: "Phone",
                  icon: Icons.phone,
                  isPhone: true,
                  controller: phoneController,
                ),
                SizedBox(height: 15),
                _buildTextField(
                  label: "Address",
                  icon: Icons.location_on,
                  controller: addressController,
                ),

                SizedBox(height: 25),

                // Place Order Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blueAccent,
                      elevation: 3,
                    ),
                    onPressed: () async {
                      if (nameController.text.trim().isEmpty ||
                          phoneController.text.trim().isEmpty ||
                          addressController.text.trim().isEmpty) {
                        // If any field is empty, show the snackbar
                        Get.snackbar(
                          "Incomplete Details",
                          "Please fill all the details before placing an order.",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                      } else {
                        // All fields are filled, proceed with placing the order
                        String name = nameController.text.trim();
                        String phone = phoneController.text.trim();
                        String address = addressController.text.trim();

                        String customerToken = await getCustomerDeviceToken();

                        placeOrder(
                          context: context,
                          customerName: name,
                          customerPhone: phone,
                          customerAddress: address,
                          customerDeviceToken: customerToken,
                        );
                      }
                    },

                    child: Text(
                      "Place Order",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      elevation: 6,
    );
  }

  // Reusable TextField Widget for Cleaner Code
  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isPhone = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
