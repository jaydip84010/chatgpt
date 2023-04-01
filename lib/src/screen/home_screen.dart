import 'dart:developer';

import 'package:chatgpt/network/adhelper.dart';
import 'package:chatgpt/network/remote_config_helper.dart';
import 'package:chatgpt/src/screen/chat_screen.dart';
import 'package:chatgpt/src/screen/dalle_screen.dart';
import 'package:chatgpt/src/screen/premium_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  static AdRequest request = const AdRequest(nonPersonalizedAds: true);
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  AdHelper adHelper = AdHelper();
  NativeAd? nad;
  final BannerAd myBanner = BannerAd(
    adUnitId: AdHelper.bannerAdUnitId ?? '',
    size: AdSize.fullBanner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );
  RemoteConfigHelper configHelper = RemoteConfigHelper();
  bool? adshow;

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId ?? '',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            log('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            log('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      log('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          log('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        log('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        log('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  void initState() {
    adshow = configHelper.remoteConfig.getBool('isshowads');
    adHelper.nativshowad();
    _createInterstitialAd();
    super.initState();
    myBanner.load();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.loose,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background2.png'),
                      fit: BoxFit.fill)),
            ),
            Positioned(
              bottom: 0,
              left: 1,
              child: Column(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PremiumPage()));
                      },
                      child: Row(
                        children: [
                          Container(width: 350, child: Spacer()),
                          Container(
                              height: 65,
                              width: 65,
                              child: Image.asset(
                                'assets/images/premium.png',
                                fit: BoxFit.fill,
                              )),
                        ],
                      )),
                  SizedBox(
                    height: 110,
                  ),
                  InkWell(
                    onTap: () async {
                      if (adshow == true) {
                        _showInterstitialAd();
                      }
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChatScreen()));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 8,
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: Image.asset(
                        'assets/images/Open Ai Bot.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      if (adshow == true) {
                        _showInterstitialAd();
                      }
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DalleImgScreen()));
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height / 8.5,
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Image.asset(
                          'assets/images/Open Ai image.png',
                          fit: BoxFit.fill,
                        )),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: adshow == true
            ? Container(
            height: MediaQuery.of(context).size.height / 2.7,
            width: MediaQuery.of(context).size.width / 1.00,
            color: Colors.white,
            child: adHelper.native != null
                ? AdWidget(
              ad: adHelper.native!,
            )
                : customnative())
            : Container(
          height: MediaQuery.of(context).size.height / 2.7,
          width: MediaQuery.of(context).size.width / 1.00,
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) throw 'Could not launch $url';
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
