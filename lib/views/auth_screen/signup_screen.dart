import 'package:flutter/material.dart';
import 'package:flutter_store_v2/consts/consts.dart';
import 'package:flutter_store_v2/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../widgets_common/applogo_widget.dart';
import '../../widgets_common/bg_widget.dart';
import '../../widgets_common/custom_textfield.dart';
import '../../widgets_common/our_button.dart';
import '../home_screen/home.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

  //text controllers
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: GestureDetector(
        onTap: () {
          // Khi người dùng chạm vào vùng ngoài, bàn phím sẽ hạ xuống
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Column(
              children: [
                50.heightBox,
                applogoWidget(),
                10.heightBox,
                "Tham gia vào $appname"
                    .text
                    .fontFamily(bold)
                    .black
                    .size(25)
                    .make(),
                15.heightBox,
                Obx(
                  () => Column(
                    children: [
                      customTextField(
                          hint: nameHint,
                          title: name,
                          controller: nameController,
                          isPass: false),
                      customTextField(
                          hint: emailHint,
                          title: email,
                          controller: emailController,
                          isPass: false),
                      customTextField(
                          hint: passwordHint,
                          title: password,
                          controller: passwordController,
                          isPass: true),
                      customTextField(
                          hint: passwordHint,
                          title: retypePassword,
                          controller: passwordRetypeController,
                          isPass: true),
                      Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {}, child: forgetPass.text.make())),
                      Row(
                        children: [
                          Checkbox(
                            activeColor: pinkColor,
                            checkColor: whiteColor,
                            value: isCheck,
                            onChanged: (newValue) {
                              setState(() {
                                isCheck = newValue;
                              });
                            },
                          ),
                          10.widthBox,
                          Expanded(
                            child: RichText(
                                text: const TextSpan(
                              children: [
                                TextSpan(
                                    text: "Tôi đồng ý với ",
                                    style: TextStyle(
                                        fontFamily: regular, color: fontGrey)),
                                TextSpan(
                                    text: termAndCond,
                                    style: TextStyle(
                                        fontFamily: regular, color: pinkColor)),
                                TextSpan(
                                    text: " & ",
                                    style: TextStyle(
                                        fontFamily: regular, color: fontGrey)),
                                TextSpan(
                                    text: privacyPolicy,
                                    style: TextStyle(
                                        fontFamily: regular, color: pinkColor)),
                              ],
                            )),
                          ),
                        ],
                      ),
                      5.heightBox,
                      controller.isloading.value
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(pinkColor),
                            )
                          : ourButton(
                              color: isCheck == true ? pinkColor : lightGrey,
                              title: signup,
                              textColor: whiteColor,
                              onPress: () async {
                                if (isCheck != false) {
                                  controller.isloading(true);
                                  try {
                                    await controller
                                        .signupMethod(
                                            context: context,
                                            email: emailController.text,
                                            password: passwordController.text)
                                        .then((value) {
                                      return controller.storeUserData(
                                          email: emailController.text,
                                          password: passwordController.text,
                                          name: nameController.text);
                                    }).then((value) {
                                      VxToast.show(context,
                                          msg: "Đăng ký tài khoản thành công");
                                      Get.offAll(() => const Home());
                                    });
                                  } catch (e) {
                                    auth.signOut();
                                    // ignore: use_build_context_synchronously
                                    VxToast.show(context, msg: e.toString());
                                    controller.isloading(false);
                                  }
                                }
                              }).box.width(context.screenWidth - 50).make(),
                      10.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          alreadyHaveAccount.text.color(fontGrey).make(),
                          login.text.color(pinkColor).make().onTap(() {
                            Get.back();
                          }),
                        ],
                      ),
                    ],
                  )
                      .box
                      .white
                      .rounded
                      .padding(const EdgeInsets.all(16))
                      .width(context.screenWidth - 70)
                      .shadowSm
                      .make(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
