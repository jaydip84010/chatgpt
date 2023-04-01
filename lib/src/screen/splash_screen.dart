import 'dart:async';

import 'package:chatgpt/network/remote_config_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../network/adhelper.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int maxFailedLoadAttempts = 3;

  AdHelper adHelper = AdHelper();
  final BannerAd myBanner = BannerAd(
    adUnitId: AdHelper.bannerAdUnitId ?? '',
    size: AdSize.mediumRectangle,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );
  bool visible = true;
  bool? isvisible;

  RemoteConfigHelper configHelper = RemoteConfigHelper();
  bool? adshow ;
  connectcheck() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
        adHelper.nativshowad();
      Future.delayed(const Duration(seconds: 7), () {
        adHelper.showAdIfAvailable();
        Timer(Duration(seconds: 5), () {
          setState(() {
            visible = false;
          });
        });
      });
    } else {
      Fluttertoast.showToast(
          msg: "Please check internet connection",
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.black,
          backgroundColor: Colors.white,
          fontSize: 14,
          gravity: ToastGravity.BOTTOM);
    }
  }

  @override
  initState() {
    configHelper.setupRemoteConfig();
    adshow = configHelper.remoteConfig.getBool('isshowads');
    Future.delayed(const Duration(seconds: 7), () {
       if(adshow==true){
         adHelper.loadAd();
         adHelper.showAdIfAvailable();
       }
      Timer(Duration(seconds: 5), () {
        setState(() {
          visible = false;
        });
      });
    });
    connectcheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/images/background.png',
                      ),
                      fit: BoxFit.fill)),
            ),
            Positioned(
                bottom: 40,
                left: 0,
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/robot icon.png',
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      ),
                    ),
                    adshow==true?
                    Container(
                        height: MediaQuery.of(context).size.height / 2.7,
                        width: MediaQuery.of(context).size.width / 1.00,
                        color: Colors.white,
                        child: adHelper.native != null
                            ? AdWidget(
                          ad: adHelper.native!,
                        )
                            : customnative()
                    ):Container( height: MediaQuery.of(context).size.height / 2.7,
                      width: MediaQuery.of(context).size.width / 1.00,),

                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      height: 60,
                      child: visible
                          ? Center(
                              child: Container(
                                width: 350,
                                child: FAProgressBar(
                                  displayText: '%',
                                  displayTextStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  size: 20,
                                  currentValue: 100,
                                  maxValue: 100,
                                  progressColor: Colors.deepPurple,
                                  backgroundColor: Colors.white,
                                  changeProgressColor: Colors.red,
                                  animatedDuration: Duration(seconds: 4),
                                  formatValueFixed: 0,
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const HomePageScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: MediaQuery.of(context).size.height / 16,
                                width: 230,
                                child: Center(
                                  child: Text(
                                    'Continue',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.deepPurple,
                                  border: Border(
                                      bottom: BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                      left: BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                      )),
                                ),
                              ),
                            ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget customnative() {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width / 2,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
          ),
          Row(
            children: [
              Container(
                height: 15,
                width: 25,
                color: Colors.green,
                child: Center(child: Text('AD')),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: Image.asset(
                    'assets/images/adsenselogo.png',
                    fit: BoxFit.fill,
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Test AD : Google test Ad',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Google Test ads',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                  Container(
                      height: 90,
                      width: 120,
                      child: Image.asset(
                        'assets/images/6+stars.png',
                        fit: BoxFit.fill,
                      ))
                ],
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width / 1.6,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                'Learn more',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
