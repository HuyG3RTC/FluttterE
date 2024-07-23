import 'package:flutter_store_v2/consts/consts.dart';
import 'package:flutter_store_v2/consts/lists.dart';
import 'package:flutter_store_v2/controllers/auth_controller.dart';
import 'package:flutter_store_v2/views/auth_screen/signup_screen.dart';
import 'package:flutter_store_v2/views/home_screen/home.dart';
import 'package:flutter_store_v2/widgets_common/applogo_widget.dart';
import 'package:flutter_store_v2/widgets_common/bg_widget.dart';
import 'package:flutter_store_v2/widgets_common/custom_textfield.dart';
import 'package:flutter_store_v2/widgets_common/our_button.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    return bgWidget(
      child: GestureDetector(
        onTap: () {
          // Khi người dùng chạm vào vùng ngoài, bàn phím sẽ hạ xuống
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 214, 239, 216),
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Column(
              children: [
                50.heightBox,
                applogoWidget(),
                10.heightBox,
                "Đăng nhập vào $appname"
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
                          hint: emailHint,
                          title: email,
                          isPass: false,
                          controller: controller.emailController),
                      customTextField(
                          hint: passwordHint,
                          title: password,
                          isPass: true,
                          controller: controller.passwordController),
                      Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {}, child: forgetPass.text.make())),
                      5.heightBox,
                      controller.isloading.value
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(pinkColor),
                            )
                          : ourButton(
                              color: pinkColor,
                              title: login,
                              textColor: whiteColor,
                              onPress: () async {
                                controller.isloading(true);
                                await controller
                                    .loginMethod(context: context)
                                    .then((value) {
                                  if (value != null) {
                                    VxToast.show(context, msg: loggedin);
                                    Get.offAll(() => const Home());
                                  } else {
                                    controller.isloading(false);
                                    VxToast.show(context,
                                        msg:
                                            "Sai thông tin email hoặc mật khẩu");
                                  }
                                });
                              }).box.width(context.screenWidth - 50).make(),
                      8.heightBox,
                      createNewAccount.text.color(fontGrey).make(),
                      5.heightBox,
                      ourButton(
                        color: lightgolden,
                        title: signup,
                        textColor: pinkColor,
                        onPress: () {
                          Get.to(() => const SignupScreen());
                        },
                      ).box.width(context.screenWidth - 50).make(),
                      10.heightBox,
                      loginWith.text.color(fontGrey).make(),
                      8.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            3,
                            (index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundColor: lightGrey,
                                    radius: 25,
                                    child: Image.asset(
                                      socialIconList[index],
                                      width: 30,
                                    ),
                                  ),
                                )),
                      )
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
