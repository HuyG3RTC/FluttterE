import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_store_v2/consts/consts.dart';
import 'package:flutter_store_v2/views/auth_screen/login_screen.dart';
import 'package:flutter_store_v2/widgets_common/applogo_widget.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //tạo một phương pháp để thay đổi màn hình

  // changeScreen() {
  //   Future.delayed(const Duration(seconds: 3), () {
  //     //Get.to(() => const LoginScreen());

  //     auth.authStateChanges().listen((User? user) {
  //       if (user == null && mounted) {
  //         Get.to(() => const LoginScreen());
  //       } else {
  //         Get.to(() => const Home());
  //       }
  //     });
  //   });
  // }

  void changeScreen() {
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        Get.to(() => const LoginScreen());
      }
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pinkColor,
      body: Center(
          child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                icSplashBg,
                width: 300,
              )),
          20.heightBox,
          applogoWidget(),
          10.heightBox,
          appname.text.fontFamily(bold).size(22).white.make(),
          5.heightBox,
          appversion.text.white.make(),
          const Spacer(),
          credits.text.white.fontFamily(semibold).make(),
          30.heightBox,
        ],
      )),
    );
  }
}
