import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store_v2/consts/consts.dart';
import 'package:flutter_store_v2/consts/lists.dart';
import 'package:flutter_store_v2/controllers/auth_controller.dart';
import 'package:flutter_store_v2/controllers/profile_controller.dart';
import 'package:flutter_store_v2/services/firestore_services.dart';
import 'package:flutter_store_v2/views/auth_screen/login_screen.dart';
import 'package:flutter_store_v2/views/chat_screen/messaging_screen.dart';
import 'package:flutter_store_v2/views/orders_screen/orders_screen.dart';
import 'package:flutter_store_v2/views/profile_screen/components/details_cart.dart';
import 'package:flutter_store_v2/views/profile_screen/edit_profile_screen.dart';
import 'package:flutter_store_v2/views/wishlist_screen.dart/wishlist_screen.dart';
import 'package:flutter_store_v2/widgets_common/applogo_widget2.dart';
import 'package:flutter_store_v2/widgets_common/bg_widget.dart';
import 'package:flutter_store_v2/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return bgWidget(
      child: Scaffold(
        backgroundColor: lightGrey,
        body: StreamBuilder(
          stream: FirestoreServices.getUser(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(pinkColor),
                ),
              );
            } else {
              var data = snapshot.data!.docs[0];

              return SafeArea(
                child: Column(
                  children: [
                    // Users details section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: data['imageUrl'] == ''
                                    ? const AssetImage(imgProfile2)
                                    : NetworkImage(data['imageUrl'])
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          15.widthBox,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "${data['name']}"
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .size(18)
                                    .make(),
                                "${data['email']}"
                                    .text
                                    .color(darkFontGrey)
                                    .size(14)
                                    .make(),
                              ],
                            ),
                          ),
                          appLogoWidget2(),
                        ],
                      ),
                    ),

                    10.heightBox,

                    FutureBuilder(
                        future: FirestoreServices.getCounts(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: loadingIndicator());
                          } else {
                            var countData = snapshot.data;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                detailsCard(
                                  count: countData[0].toString(),
                                  title: "Giỏ hàng của bạn",
                                  width:
                                      MediaQuery.of(context).size.width / 3.2,
                                ),
                                detailsCard(
                                  count: countData[1].toString(),
                                  title: "Sản phẩm đã thích",
                                  width:
                                      MediaQuery.of(context).size.width / 3.2,
                                ),
                                detailsCard(
                                  count: countData[2].toString(),
                                  title: "Đơn đặt hàng",
                                  width:
                                      MediaQuery.of(context).size.width / 3.2,
                                ),
                              ],
                            );
                          }
                        }),

                    5.heightBox,
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return const Divider(color: lightGrey);
                        },
                        itemCount: profileButtonsList.length + 4,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < profileButtonsList.length) {
                            return ListTile(
                              onTap: () {
                                switch (index) {
                                  case 0:
                                    Get.to(() => const OrdersScreen());
                                    break;
                                  case 1:
                                    Get.to(() => const WishlistScreen());
                                    break;
                                  case 2:
                                    Get.to(() => const MessagesScreen());
                                    break;
                                  default:
                                }
                              },
                              leading: Image.asset(
                                profileButtonsIcon[index],
                                width: 22,
                              ),
                              title: profileButtonsList[index]
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                            );
                          } else if (index == profileButtonsList.length) {
                            // Chỉnh sửa hồ sơ
                            return ListTile(
                              onTap: () {
                                controller.nameController.text = data['name'];
                                Get.to(() => EditProfileScreen(data: data));
                              },
                              leading:
                                  const Icon(Icons.edit, color: darkFontGrey),
                              title: const Text('Chỉnh sửa hồ sơ')
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                            );
                          } else if (index == profileButtonsList.length + 1) {
                            return ListTile(
                              onTap: () {
                                // Thêm chức năng đổi ngôn ngữ ở đây
                                // Ví dụ: showDialog để chọn ngôn ngữ mới
                              },
                              leading: const Icon(Icons.language,
                                  color: darkFontGrey),
                              title: const Text('Đổi ngôn ngữ')
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                            );
                          } else if (index == profileButtonsList.length + 2) {
                            return ListTile(
                              onTap: () {
                                // Thêm chức năng chuyển chế độ sáng/tối ở đây
                                // Ví dụ: sử dụng Get.changeThemeMode để chuyển đổi chế độ
                                if (Get.isDarkMode) {
                                  Get.changeThemeMode(ThemeMode.light);
                                } else {
                                  Get.changeThemeMode(ThemeMode.dark);
                                }
                              },
                              leading: const Icon(Icons.brightness_6,
                                  color: darkFontGrey),
                              title: const Text('Chế độ sáng/tối')
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                            );
                          } else if (index == profileButtonsList.length + 3) {
                            return ListTile(
                              onTap: () async {
                                await Get.put(AuthController())
                                    .signoutMethod(context);
                                Get.offAll(() => const LoginScreen());
                              },
                              leading: const Icon(Icons.exit_to_app,
                                  color: darkFontGrey),
                              title: const Text('Đăng xuất')
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      )
                          .box
                          .white
                          .rounded
                          .margin(const EdgeInsets.all(12))
                          .padding(const EdgeInsets.symmetric(horizontal: 16))
                          .shadowSm
                          .make(),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
