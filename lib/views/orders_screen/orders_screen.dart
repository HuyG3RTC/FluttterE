import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store_v2/consts/consts.dart';
import 'package:flutter_store_v2/services/firestore_services.dart';
import 'package:flutter_store_v2/views/orders_screen/orders_details.dart';
import 'package:flutter_store_v2/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  // Hàm định dạng giá tiền
  String formatPrice(int price) {
    final formatter = NumberFormat('#,##0', 'vi_VN');
    return formatter.format(price) + ' đ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Đơn hàng của tôi".text.make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllOrders(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "Hổng có đơn hàng!!".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                // Lấy giá trị tổng số tiền và định dạng nó
                var totalAmount = data[index]['total_amount'];
                var formattedAmount = formatPrice(totalAmount);

                return InkWell(
                  onTap: () {
                    // Chuyển trang khi bấm vào khung
                    Get.to(() => OrdersDetails(data: data[index]));
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 2), // Đổ bóng xuống dưới
                        ),
                      ],
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    ),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      leading: SizedBox(
                        width: 48, // Kích thước cố định cho số thứ tự
                        child: Center(
                          child: "${index + 1}"
                              .text
                              .fontFamily(bold)
                              .color(darkFontGrey)
                              .xl
                              .make(),
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: data[index]['order_code']
                                    .toString()
                                    .text
                                    .color(pinkColor)
                                    .fontFamily(semibold)
                                    .make(),
                              ),
                            ],
                          ),
                          const SizedBox(
                              height:
                                  4), // Khoảng cách giữa mã đơn hàng và số tiền
                          Row(
                            children: [
                              Expanded(
                                child: formattedAmount.text
                                    .fontFamily(bold)
                                    .make(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 48, // Kích thước cố định cho mũi tên
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              // Chuyển trang khi bấm vào mũi tên
                              Get.to(() => OrdersDetails(data: data[index]));
                            },
                            icon: const Icon(Icons.arrow_forward_ios_rounded,
                                color: darkFontGrey),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
