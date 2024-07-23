import 'package:flutter_store_v2/consts/consts.dart';

Widget appLogoWidget2() {
  return Container(
    width: 80, // Điều chỉnh kích thước nếu cần
    height: 80,
    decoration: BoxDecoration(
      image: const DecorationImage(
        image: AssetImage('assets/icons/app_logo_2.png'),
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(10), // Bo góc ảnh
    ),
  );
}
