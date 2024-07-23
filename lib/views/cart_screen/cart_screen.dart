import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store_v2/consts/consts.dart';
import 'package:flutter_store_v2/controllers/cart_controller.dart';
import 'package:flutter_store_v2/services/firestore_services.dart';
import 'package:flutter_store_v2/views/cart_screen/shipping_screen.dart';
import 'package:flutter_store_v2/widgets_common/loading_indicator.dart';
import 'package:flutter_store_v2/widgets_common/our_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  Future<String> getImageUrl(String imagePath) async {
    final ref = FirebaseStorage.instance.refFromURL(imagePath);
    String url = await ref.getDownloadURL();
    return url;
  }

  String formatPrice(int price) {
    final formatter = NumberFormat('#,##0', 'vi_VN');
    return formatter.format(price) + ' đ';
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());

    return Scaffold(
      backgroundColor: lightGrey,
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          color: pinkColor,
          onPress: () {
            Get.to(() => const ShippingDetails());
          },
          textColor: whiteColor,
          title: "Tiến hành vận chuyển",
        ),
      ),
      appBar: AppBar(
        title: "Giỏ hàng".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getCart(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: "Không có sản phẩm nào trong giỏ hàng"
                  .text
                  .color(darkFontGrey)
                  .make(),
            );
          } else {
            var data = snapshot.data!.docs;
            controller.calculate(data);
            controller.productSnapshot = data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FutureBuilder(
                          future: getImageUrl(data[index]['img']),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: loadingIndicator());
                            } else {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Image.network(
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title:
                                      "${data[index]['title']} (Sl: ${data[index]['qty']})"
                                          .text
                                          .fontFamily(semibold)
                                          .size(16)
                                          .make(),
                                  subtitle: formatPrice(data[index]['tprice'])
                                      .text
                                      .color(pinkColor)
                                      .fontFamily(semibold)
                                      .make(),
                                  trailing:
                                      const Icon(Icons.delete, color: pinkColor)
                                          .onTap(() {
                                    FirestoreServices.deleteDocument(
                                        data[index].id);
                                  }),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Tổng thanh toán"
                          .text
                          .fontFamily(bold)
                          .color(darkFontGrey)
                          .make(),
                      Obx(
                        () => formatPrice(controller.totalP.value)
                            .text
                            .fontFamily(bold)
                            .color(pinkColor)
                            .make(),
                      )
                      // Thay đổi ở đây
                    ],
                  )
                      .box
                      .padding(const EdgeInsets.all(12))
                      .color(lightgolden)
                      .roundedSM
                      .make(),
                  10.heightBox,
                  // SizedBox(
                  //   width: context.screenWidth - 60,
                  //   child: ourButton(
                  //     color: pinkColor,
                  //     onPress: () {},
                  //     textColor: whiteColor,
                  //     title: "Tiến hành vận chuyển",
                  //   ),
                  // ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
