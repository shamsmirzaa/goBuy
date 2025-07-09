import 'package:e_comm/screens/user_panel/all_categories_screen.dart';
import 'package:e_comm/screens/user_panel/cart_screen.dart';
import 'package:e_comm/services/fcm_service.dart';

import 'package:e_comm/services/notification_service.dart';
import 'package:e_comm/utils/app_constant.dart';
import 'package:e_comm/widgets/all_products_widget.dart';
import 'package:e_comm/widgets/banner_widget.dart';
import 'package:e_comm/widgets/category_widget.dart';
import 'package:e_comm/widgets/custom_drawer_widget.dart';
import 'package:e_comm/widgets/flash_sale_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../widgets/heading_widget.dart';
import 'all_flash_sale_products.dart';
import 'all_products_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken();
    FcmService.firebaseInit();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          'hello',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => CartScreen()),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              SizedBox(height: Get.height / 90.0),
              BannerWidget(),
              HeadingWidget(
                headingTitle: "Categories",
                headingSubTitle: "Popular Categories",
                onTap: () => Get.to(() => AllCategoriesScreen()),
                buttonText: "See More",
              ),

              CategoriesWidget(),
              HeadingWidget(
                headingTitle: "Flash Sale",
                headingSubTitle: "Buy now",
                onTap: () => Get.to(() => AllFlashSaleProducts()),
                buttonText: "See More",
              ),
              FlashSaleWidget(),
              HeadingWidget(
                headingTitle: "All Products",
                headingSubTitle: "Buy now",
                onTap: () => Get.to(() => AllProductsScreen()),
                buttonText: "See More",
              ),
              AllProductsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
