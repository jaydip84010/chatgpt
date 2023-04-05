import 'package:chatgpt/network/remote_config_helper.dart';
import 'package:chatgpt/src/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final remoteConfig = FirebaseRemoteConfig.instance;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final remoteconfighelper= RemoteConfigHelper(remoteConfig: remoteConfig);
  await remoteconfighelper.setupRemoteConfig();
  MobileAds.instance.initialize();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xff3a0f5a), // Change this to the color you want
  ));
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Chat UI',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
