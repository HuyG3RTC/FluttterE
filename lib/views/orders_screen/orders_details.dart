import 'package:flutter_store_v2/consts/consts.dart';
import 'package:flutter_store_v2/views/orders_screen/components/order_place_details.dart';
import 'package:flutter_store_v2/views/orders_screen/components/order_status.dart';
import 'package:intl/intl.dart' as intl;

class OrdersDetails extends StatelessWidget {
  final dynamic data;
  const OrdersDetails({Key? key, this.data}) : super(key: key);

  // Hàm định dạng giá tiền
  String formatPrice(int price) {
    final formatter = intl.NumberFormat('#,##0', 'vi_VN');
    return formatter.format(price) + ' đ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Chi tiết đơn hàng"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              orderStatus(
                  color: pinkColor,
                  icon: Icons.done,
                  title: "Đã đặt hàng",
                  showDone: data['order_placed']),
              orderStatus(
                  color: const Color.fromARGB(255, 128, 207, 197),
                  icon: Icons.thumb_up_alt_outlined,
                  title: "Đã xác nhận",
                  showDone: data['order_confirmed']),
              orderStatus(
                  color: const Color.fromARGB(255, 183, 58, 129),
                  icon: Icons.car_crash_outlined,
                  title: "Đang giao hàng",
                  showDone: data['order_on_delivery']),
              orderStatus(
                  color: Colors.green,
                  icon: Icons.done_outline_sharp,
                  title: "Đã giao hàng",
                  showDone: data['order_delivered']),
              const Divider(),
              10.heightBox,
              // Thong tin don hang
              Column(
                children: [
                  orderPlaceDetails(
                      d1: data['order_code'],
                      d2: data['shipping_method'],
                      title1: "Mã đơn hàng",
                      title2: "Phương thức vận chuyển"),
                  orderPlaceDetails(
                      d1: intl.DateFormat()
                          .add_yMd()
                          .format((data['order_date'].toDate())),
                      d2: data['payment_method'],
                      title1: "Ngày đặt hàng",
                      title2: "Phương thức thanh toán"),
                  orderPlaceDetails(
                      d1: "Chưa thanh toán",
                      d2: "Đã đặt hàng",
                      title1: "Trạng thái thanh toán",
                      title2: "Trạng thái giao hàng"),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Địa chỉ giao hàng"
                                .text
                                .fontFamily(semibold)
                                .make(),
                            "${data['order_by_name']}".text.make(),
                            "${data['order_by_email']}".text.make(),
                            "${data['order_by_addres']}".text.make(),
                            "${data['order_by_city']}".text.make(),
                            "${data['order_by_state']}".text.make(),
                            "${data['order_by_postalcode']}".text.make(),
                            "${data['order_by_phone']}".text.make(),
                          ],
                        ),
                        SizedBox(
                          width: 175,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Thành tiền".text.fontFamily(semibold).make(),
                              formatPrice(data['total_amount'])
                                  .text
                                  .color(pinkColor)
                                  .fontFamily(bold)
                                  .make()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).box.outerShadowMd.white.make(),
              const Divider(),
              10.heightBox,
              "Sản phẩm đã đặt hàng"
                  .text
                  .size(16)
                  .color(darkFontGrey)
                  .fontFamily(semibold)
                  .makeCentered(),
              10.heightBox,
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(data['orders'].length, (index) {
                  var order = data['orders'][index];
                  var formattedPrice = formatPrice(order['tprice']);
                  return SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: orderPlaceDetails(
                              title1: order['title'],
                              title2: formattedPrice,
                              d1: "Sl: ${order['qty']}",
                              d2: "Có thể hoàn tiền"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            width: 30,
                            height: 10,
                            color: Color(order['color']),
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                }).toList(),
              )
                  .box
                  .outerShadowMd
                  .white
                  .margin(const EdgeInsets.only(bottom: 4))
                  .make(),
              20.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
