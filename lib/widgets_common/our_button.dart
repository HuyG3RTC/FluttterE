import 'package:flutter_store_v2/consts/consts.dart';

Widget ourButton({
  onPress,
  color,
  textColor,
  String? title,
}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            // Định nghĩa hình dạng của nút
            borderRadius:
                BorderRadius.circular(8), // Đặt bo góc là 0 để không có bo góc
          ),
          backgroundColor: color,
          padding: const EdgeInsets.all(12)),
      onPressed: onPress,
      child: title!.text.color(textColor).fontFamily(bold).size(16).make());
}
