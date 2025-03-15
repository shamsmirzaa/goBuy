import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comm/models/categories_model.dart';
import 'package:e_comm/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'single_category_product_screen.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("All Categories", style: TextStyle(color: Colors.white)),
        backgroundColor: AppConstant.appSecondaryColor,
      ),
      body: Column(
        children: [
          SizedBox(height: 10), // Adds space between AppBar and GridView
          Expanded(
            child: FutureBuilder(
              future: FirebaseFirestore.instance.collection('categories').get(),
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
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
                    child: Center(
                      child: CupertinoActivityIndicator(radius: 15),
                    ),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No category found!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                    childAspectRatio: 1.19,
                  ),
                  itemBuilder: (context, index) {
                    CategoriesModel categoriesModel = CategoriesModel(
                      categoryId: snapshot.data!.docs[index]['categoryId'],
                      categoryName: snapshot.data!.docs[index]['categoryName'],
                      categoryImg: snapshot.data!.docs[index]['categoryImg'],
                      createdAt: snapshot.data!.docs[index]['createdAt'],
                      updatedAt: snapshot.data!.docs[index]['updatedAt'],
                    );

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 3,
                      ),
                      child: GestureDetector(
                        onTap:
                            () => Get.to(
                              AllSingleCategoryProductScreen(
                                categoryId: categoriesModel.categoryId,
                              ),
                            ),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          // Smooth hover effect
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
                                  imageUrl: categoriesModel.categoryImg,
                                  height: Get.height / 8.5,
                                  width: Get.width / 2.5,
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
                                categoriesModel.categoryName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );

                // SizedBox(
                //   height: Get.height / 4.5, // Slightly larger for better spacing
                //   child: ListView.builder(
                //     itemCount: snapshot.data!.docs.length,
                //     shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //     physics: BouncingScrollPhysics(),
                //     // Smooth scrolling effect
                //
                //   ),
                // );
              },
            ),
          ),
        ],
      ),
    );
  }
}
