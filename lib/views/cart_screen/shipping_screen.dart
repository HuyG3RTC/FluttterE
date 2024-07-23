import 'package:flutter/material.dart';
import 'package:flutter_store_v2/consts/consts.dart';
import 'package:flutter_store_v2/controllers/cart_controller.dart';
import 'package:flutter_store_v2/views/cart_screen/payment_method.dart';
import 'package:flutter_store_v2/widgets_common/custom_textfield.dart';
import 'package:flutter_store_v2/widgets_common/our_button.dart';
import 'package:get/get.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return GestureDetector(
      onTap: () {
        // Ẩn bàn phím khi tap ra ngoài
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: "Thông tin vận chuyển"
              .text
              .fontFamily(semibold)
              .color(darkFontGrey)
              .make(),
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: ourButton(
            onPress: () {
              if (controller.addressController.text.length > 10) {
                Get.to(() => const PaymentMethods());
              } else {
                VxToast.show(context, msg: "Vui lòng điền đầy đủ thông tin");
              }
            },
            color: pinkColor,
            textColor: whiteColor,
            title: "Tiếp tục",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              customTextField(
                  hint: "Địa chỉ nơi bạn đang ở",
                  isPass: false,
                  title: "Địa chỉ",
                  controller: controller.addressController),
              customTextField(
                  hint: "Thành phố",
                  isPass: false,
                  title: "Thành Phố",
                  controller: controller.cityController),
              customTextField(
                  hint: "Tỉnh",
                  isPass: false,
                  title: "Tỉnh",
                  controller: controller.stateController),
              customTextField(
                  hint: "Mã bưu điện của Tình & Thành phố bạn đáng ở ",
                  isPass: false,
                  title: "Mã bưu điện",
                  controller: controller.postalcodeController),
              customTextField(
                  hint: "Số điện thoại",
                  isPass: false,
                  title: "Số điện thoại",
                  controller: controller.phoneController),
            ],
          ),
        ),
      ),
    );
  }
}
