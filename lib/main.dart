import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'package:flutter_store_v2/consts/consts.dart';
import 'package:flutter_store_v2/providers/provider.dart';
import 'package:flutter_store_v2/views/splash_screen/splash_screen.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final onboarding = prefs.getBool("onboarding") ?? false;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(onboarding: onboarding));
}

class MyApp extends StatefulWidget {
  final bool onboarding;
  const MyApp({super.key, this.onboarding = false});
  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => UiProvider()..init(),
      child: Consumer<UiProvider>(
        builder: (context, UiProvider notifier, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: appname,
            themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,

            darkTheme:
                notifier.isDark ? notifier.darkTheme : notifier.lightTheme,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.transparent,
              appBarTheme: const AppBarTheme(
                  iconTheme: IconThemeData(
                    color: darkFontGrey,
                  ),
                  backgroundColor: Colors.transparent),
              fontFamily: regular,
            ),
            
            home:const SplashScreen(), //onboarding? HomePage(): const OnboardingView(),//WelcomeScreen(),
          );
        },
      ),
    );
  }
}