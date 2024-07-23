import 'package:flutter_store_v2/consts/consts.dart';
import 'package:flutter_store_v2/views/category_screen/category_details.dart';
import 'package:get/get.dart';

Widget featuredButton({String? title, icon}) {
  return Row(
    children: [
      Image.asset(
        icon,
        width: 60,
        fit: BoxFit.fill,
      ),
      10.widthBox,
      title!.text.fontFamily(semibold).color(darkFontGrey).make(),
    ],
  )
      .box
      .width(200)
      .margin(const EdgeInsets.symmetric(horizontal: 4))
      .white
      .padding(const EdgeInsets.all(8))
      .roundedSM
      .outerShadow
      .make()
      .onTap(() {
    Get.to(() => CategoryDetails(title: title));
  });
}
