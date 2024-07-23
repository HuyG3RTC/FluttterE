import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_store_v2/consts/colors.dart';
import 'package:flutter_store_v2/consts/images.dart';
import 'package:flutter_store_v2/consts/strings.dart';
import 'package:flutter_store_v2/controllers/profile_controller.dart';
import 'package:flutter_store_v2/widgets_common/bg_widget.dart';
import 'package:flutter_store_v2/widgets_common/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;

  const EditProfileScreen({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    return bgWidget(
        child: Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //if data image url and controller path is empty
              data['imageUrl'] == '' && controller.profileImgPath.isEmpty
                  ? Image.asset(
                      imgProfile2,
                      width: 100,
                      fit: BoxFit.cover,
                    ).box.roundedFull.clip(Clip.antiAlias).make()
                  //if data is not empty but controller  path is empty
                  : data['imageUrl'] != '' && controller.profileImgPath.isEmpty
                      ? Image.network(
                          data['imageUrl'],
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make()
                      //if both are empty
                      : Image.file(
                          File(controller.profileImgPath.value),
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make(),
              10.heightBox,
              MaterialButton(
                onPressed: () {
                  controller.changeImage(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      5.5), // Điều chỉnh độ cong để làm cho khung vuông
                ),
                color: pinkColor,
                textColor: whiteColor,
                child: const Text('Thay đổi'),
              ),
              const Divider(),
              10.heightBox,
              customTextField(
                controller: controller.nameController,
                hint: nameHint,
                title: name,
                isPass: false,
              ),
              10.heightBox,
              customTextField(
                controller: controller.oldpassController,
                hint: passwordHint,
                title: oldpass,
                isPass: true,
              ),
              10.heightBox,
              customTextField(
                controller: controller.newpassController,
                hint: passwordHint,
                title: newpass,
                isPass: true,
              ),
              15.heightBox,
              controller.isloading.value
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(pinkColor),
                    )
                  : SizedBox(
                      width: context.screenWidth - 60,
                      child: MaterialButton(
                        onPressed: () async {
                          controller.isloading(true);

                          //if image is not selected
                          if (controller.profileImgPath.value.isNotEmpty) {
                            await controller.uploadProfileImage();
                          } else {
                            controller.profileImageLink = data['imageUrl'];
                          }

                          //if old password matches data base

                          if (data['password'] ==
                              controller.oldpassController.text) {
                            await controller.changeAuthPassword(
                                email: data['email'],
                                password: controller.oldpassController.text,
                                newpassword: controller.newpassController.text);

                            await controller.updateProfile(
                                imgUrl: controller.profileImageLink,
                                name: controller.nameController.text,
                                password: controller.newpassController.text);
                            VxToast.show(context,
                                msg: "Thông tin đã được cập nhật");
                          } else {
                            VxToast.show(context,
                                msg: "Sai mật khẩu hiện tại. Hãy thử lại.");
                            controller.isloading(false);
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              5.5), // Điều chỉnh độ cong để làm cho khung vuông
                        ),
                        color: pinkColor,
                        textColor: whiteColor,
                        child: const Text('Lưu'),
                      ),
                    ),
            ],
          )
              .box
              .white
              .shadowSm
              .padding(const EdgeInsets.all(16))
              .margin(const EdgeInsets.only(top: 50, left: 12, right: 12))
              .rounded
              .make(),
        ),
      ),
    ));
  }
}
