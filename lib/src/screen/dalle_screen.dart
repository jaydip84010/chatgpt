import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatgpt/main.dart';
import 'package:chatgpt/network/remote_config_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/images.dart';
import '../../network/adhelper.dart';
import '../../providers/get_images_provider.dart';
import 'full_screen.dart';

class DalleImgScreen extends StatefulWidget {
  const DalleImgScreen({
    super.key,
  });

  @override
  State<DalleImgScreen> createState() => _DalleImgScreenState();
}

class _DalleImgScreenState extends State<DalleImgScreen> {
  TextEditingController searchController = TextEditingController();
  int _maxsearch = 4;
  bool ImagesmodelAvailable = false;
  bool searching = false;
  final double _value = 10;
  List<Imagesmodel> ImagesmodelList = [];
  bool isvisible = false;
  AdHelper adhelper = AdHelper();
  final BannerAd myBanner = BannerAd(
    adUnitId: AdHelper.bannerAdUnitId ?? '',
    size: AdSize.fullBanner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );
  RemoteConfigHelper configHelper = RemoteConfigHelper(remoteConfig: remoteConfig);
  bool? adshow;

  @override
  void initState() {
    adshow = configHelper.remoteConfig.getBool('isshowads');
    super.initState();
    ImagesmodelAvailable = ImagesmodelList.isNotEmpty ? true : false;
    adhelper.nativshowad();
    myBanner.load();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xff2c0f3e),
          elevation: 2,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios,
              size: 22,
              color: Colors.white,
            ),
          ),
          title: const Text(
            'Ai Image Assitant',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background3.png'),
                    fit: BoxFit.fill)),
            child: Column(
              children: [
                _formChat(),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: ImagesmodelAvailable
                      ? Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Stack(
                            children: [
                              GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          mainAxisExtent: 180,
                                          maxCrossAxisExtent: 210,
                                          crossAxisSpacing: 15,
                                          mainAxisSpacing: 15),
                                  itemCount: ImagesmodelList.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          CustomPageRoute(
                                            builder: (context) => ImageView(
                                                imgPath:
                                                    ImagesmodelList[index].url),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                          tag: ImagesmodelList[index].url,
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                height:
                                                    index % 2 == 0 ? 180 : 250,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                child: ImageCard(
                                                  imageData:
                                                      ImagesmodelList[index]
                                                          .url,
                                                ),
                                              ),
                                              Positioned(
                                                  right: 5,
                                                  top: 90,
                                                  child: Column(
                                                    children: [
                                                      InkWell(
                                                        child: Image.asset(
                                                          'assets/Imagesmodel/download.png',
                                                          height: 40,
                                                          width: 40,
                                                        ),
                                                        onTap: () {},
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      InkWell(
                                                        child: Image.asset(
                                                          'assets/Imagesmodel/share.png',
                                                          height: 40,
                                                          width: 40,
                                                        ),
                                                        onTap: () {},
                                                      )
                                                    ],
                                                  )),
                                            ],
                                          )),
                                    );
                                  }),
                            ],
                          ),
                        )

                      //  Container(
                      //    margin: EdgeInsets.only(left: 10,right: 10),
                      //    child: MasonryGridView.count(
                      //               crossAxisCount: 2,
                      //               mainAxisSpacing: 10,
                      //               itemCount: ImagesmodelList.length,
                      //               crossAxisSpacing: 0,
                      //
                      //               itemBuilder: (context, index) {
                      //                 return InkWell(
                      //                   onTap: () {
                      //                     Navigator.of(context).push(
                      //                       CustomPageRoute(
                      //                         builder: (context) =>
                      //                             ImageView(imgPath: ImagesmodelList[index].url),
                      //                       ),
                      //                     );
                      //                   },
                      //                   child: Hero(
                      //                     tag: ImagesmodelList[index].url,
                      //                     child: Container(
                      //                       padding: EdgeInsets.only(left: 10,right: 10),
                      //                       decoration: BoxDecoration(
                      //                           borderRadius: BorderRadius.circular(6)),
                      //                       height: 200,
                      //                       width: 100,
                      //                       child: ImageCard(
                      //                         imageData: ImagesmodelList[index].url,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 );
                      //               },
                      //             ),
                      //  )
                      : Center(
                          child: searchingWidget(),
                        ),
                ),
                adshow == true
                    ? myBanner.load() != null
                        ? Container(
                            width: myBanner.size.width.toDouble(),
                            height: myBanner.size.height.toDouble(),
                            child: AdWidget(ad: myBanner),
                          )
                        : Container(
                            height: 40,
                            width: 200,
                            color: Colors.green,
                          )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchingWidget() {
    if (searching) {
      return CircularProgressIndicator(
        color: Colors.white,
      );
    } else {
      return const Text(
        "Search for any image",
        style: TextStyle(color: Colors.white),
      );
    }
  }

  Widget _formChat() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: TextField(
        cursorColor: Colors.white,
        controller: searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: ' Search...',
          hintStyle: const TextStyle(color: Colors.white, fontSize: 16),
          suffixIcon: InkWell(
            onTap: () async {
              setState(() {
                _maxsearch--;
              });
              print(_maxsearch);
              if (_maxsearch == 0) {
                 if(adshow==true){
                   adhelper.showreward();
                 }
                _maxsearch = 4;
              }

              if (searchController.text.isEmpty) {
                FocusScope.of(context).unfocus();
              } else {
                FocusScope.of(context).unfocus();
                setState(() {
                  searching = true;
                });
                ImagesmodelList = await submitGetImagesmodelForm(
                  context: context,
                  prompt: searchController.text.toString(),
                  n: _value.round(),
                );
                setState(() {
                  ImagesmodelAvailable =
                      ImagesmodelList.isNotEmpty ? true : false;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xff370c5c)),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(5),
              child: const Icon(
                Icons.search,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          filled: true,
          fillColor: Colors.transparent,
          labelStyle: const TextStyle(fontSize: 12),
          contentPadding: const EdgeInsets.all(20),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade100,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade100,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({super.key, required this.imageData});

  final String imageData;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: CachedNetworkImage(
        imageUrl: imageData,
        fit: BoxFit.fill,
        progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
            height: 150,
            width: 150,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade100,
              highlightColor: Colors.white,
              child: Container(
                height: 220,
                width: 130,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4)),
              ),
            )),
      ),
    );
  }
}

class CustomPageRoute extends MaterialPageRoute {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  CustomPageRoute({builder}) : super(builder: builder);
}
