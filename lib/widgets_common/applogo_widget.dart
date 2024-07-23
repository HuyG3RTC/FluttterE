import 'package:flutter_store_v2/consts/consts.dart';

Widget applogoWidget() {
  return Image.asset(icAppLogo)
      .box
      .color(const Color(0xFF053262)) // Đặt nền thành màu #053262
      .size(250, 120) // Tăng kích thước lên 120x120
      .padding(const EdgeInsets.all(8))
      .rounded
      .make();
}
