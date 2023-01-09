import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatgpt/models/images.dart';
import 'package:chatgpt/providers/get_images_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';

import 'full_screen.dart';

class DallePage extends StatefulWidget {
  const DallePage({
    super.key,
  });

  @override
  State<DallePage> createState() => _DallePageState();
}

class _DallePageState extends State<DallePage> {
  TextEditingController searchController = TextEditingController();
  bool imagesAvailable = false;
  bool searching = false;
  final double _value = 10;
  List<Images> imagesList = [];
  @override
  void initState() {
    super.initState();
    imagesAvailable = imagesList.isNotEmpty ? true : false;
  }
  // getImages(){
  //   /
  // }

  List<MaterialColor> colors = [
    Colors.red,
    Colors.green,
    Colors.grey,
    Colors.yellow,
    Colors.pink,
    Colors.red,
    Colors.green,
    Colors.grey,
    Colors.yellow,
    Colors.pink,
    Colors.amber,
    Colors.blue,
    Colors.amber,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.grey,
    Colors.yellow,
    Colors.red,
    Colors.green,
    Colors.grey,
    Colors.yellow,
    Colors.pink,
    Colors.amber,
    Colors.blue,
    Colors.pink,
    Colors.amber,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.grey,
    Colors.yellow,
    Colors.pink,
    Colors.red,
    Colors.green,
    Colors.grey,
    Colors.yellow,
    Colors.pink,
    Colors.amber,
    Colors.blue,
    Colors.amber,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.grey,
    Colors.yellow,
    Colors.red,
    Colors.green,
    Colors.grey,
    Colors.yellow,
    Colors.pink,
    Colors.amber,
    Colors.blue,
    Colors.pink,
    Colors.amber,
    Colors.blue,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Generate Any Image with Ai',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Column(
          children: [
            _formChat(),
            // Slider(
            //   min: 1,
            //   max: 10,
            //   activeColor: Colors.indigo,
            //   inactiveColor: Colors.indigo.shade200,
            //   value: _value,
            //   onChanged: (value) {
            //     setState(() {
            //       _value = value;
            //     });
            //   },
            // ),
            Expanded(
              child: imagesAvailable
                  ? MasonryGridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      itemCount: imagesList.length,
                      crossAxisSpacing: 10,
                      semanticChildCount: 6,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              CustomPageRoute(
                                builder: (context) => ImageView(
                                    imgPath: imagesList[index].url
                                    //     imgPath:
                                    //      'https://unsplash.com/photos/TKPC9CvglVg/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjY0NzcyMzgw&force=true',
                                    ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: imagesList[index].url,
                            //    'https://unsplash.com/photos/TKPC9CvglVg/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjY0NzcyMzgw&force=true',
                            child: Container(
                              decoration: BoxDecoration(
                                  color: colors[index],
                                  borderRadius: BorderRadius.circular(6)),
                              height: index % 2 == 0 ? 180 : 250,
                              width: MediaQuery.of(context).size.width / 3,
                              child: ImageCard(
                                imageData: imagesList[index].url,
                                //     'https://unsplash.com/photos/TKPC9CvglVg/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjY0NzcyMzgw&force=true',
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: searchingWidget(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchingWidget() {
    if (searching) {
      return Lottie.asset('assets/searching.json');
    } else {
      return const Text("Generate any image");
    }
  }

  Widget _formChat() {
    return Positioned(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          color: Colors.white,
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Type your message...',
              suffixIcon: InkWell(
                onTap: () async {
                  setState(() {
                    searching = true;
                  });
                  imagesList = await submitGetImagesForm(
                    context: context,
                    prompt: searchController.text.toString(),
                    n: _value.round(),
                  );
                  setState(() {
                    imagesAvailable = imagesList.isNotEmpty ? true : false;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFE58500),
                  ),
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
              fillColor: Colors.blueGrey.shade50,
              labelStyle: const TextStyle(fontSize: 12),
              contentPadding: const EdgeInsets.all(20),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
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
        fit: BoxFit.cover,
      ),
    );
  }
}

class CustomPageRoute extends MaterialPageRoute {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  CustomPageRoute({builder}) : super(builder: builder);
}
