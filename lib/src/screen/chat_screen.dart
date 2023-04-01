import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt/models/model.dart';
import 'package:chatgpt/network/remote_config_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/chat.dart';
import '../../network/adhelper.dart';
import '../../network/api_services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String messagePrompt = '';
  int tokenValue = 500;
  List<Chatmodel> chatList = [];
  List<Model> modelsList = [];
  late SharedPreferences prefs;
  int _maxsearch = 4;
  AdHelper adhelper = AdHelper();

  RemoteConfigHelper configHelper = RemoteConfigHelper();
  bool? adshow;

  @override
  void initState() {
    adshow = configHelper.remoteConfig.getBool('isshowads');
    super.initState();
    getModels();
    initPrefs();
    myBanner.load();
  }

  void getModels() async {
    modelsList = await submitGetModelsForm(context: context);
  }

  List<DropdownMenuItem<String>> get models {
    List<DropdownMenuItem<String>> menuItems =
        List.generate(modelsList.length, (i) {
      return DropdownMenuItem(
        value: modelsList[i].id,
        child: Text(modelsList[i].id),
      );
    });
    return menuItems;
  }

  final BannerAd myBanner = BannerAd(
    adUnitId: AdHelper.bannerAdUnitId ?? '',
    size: AdSize.fullBanner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    tokenValue = prefs.getInt("token") ?? 500;
  }

  TextEditingController mesageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background3.png'),
                    fit: BoxFit.fill)),
            child: Column(
              children: [
                _topChat(),
                _bodyChat(),
                _formChat(),
                adshow == true
                    ? myBanner.load() != null
                        ? Container(
                            width: myBanner.size.width.toDouble(),
                            height: myBanner.size.height.toDouble(),
                            child: AdWidget(ad: myBanner),
                          )
                        : Container()
                    : Container()
              ],
            ),
          ),
        ),
      )),
    );
  }

  void saveData(int value) {
    prefs.setInt("token", value);
  }

  int getData() {
    return prefs.getInt("token") ?? 1;
  }

  _topChat() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: const Text(
                  'Ai Chat Assistant',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget chats() {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: chatList.length,
      itemBuilder: (context, index) => _itemChat(
        chat: chatList[index].chat,
        message: chatList[index].msg,
      ),
    );
  }

  Widget _bodyChat() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0), topRight: Radius.circular(0)),
          color: Colors.black26,
        ),
        child: ListView(
          children: [
            chats(),
          ],
        ),
      ),
    );
  }

  _itemChat({required int chat, required String message}) {
    return Row(
      mainAxisAlignment:
          chat == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: chat == 0 ? Colors.indigo.shade100 : Colors.indigo.shade50,
              borderRadius: chat == 0
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
            ),
            child: chatWidget(message),
          ),
        ),
      ],
    );
  }

  Widget chatWidget(String text) {
    return SizedBox(
      width: 250.0,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        child: AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
              text.replaceFirst('\n\n', ''),
            ),
          ],
          repeatForever: false,
          totalRepeatCount: 1,
        ),
      ),
    );
  }

  Widget _formChat() {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          color: null,
          child: TextField(
            controller: mesageController,
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: ' Type your message...',
              hintStyle: TextStyle(color: Colors.white),
              suffixIcon: InkWell(
                  onTap: (() async {
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

                    if (mesageController.text.isEmpty) {
                      FocusScope.of(context).unfocus();
                    }
                    FocusScope.of(context).unfocus();
                    messagePrompt = mesageController.text.toString();
                    setState(() {
                      chatList.add(Chatmodel(msg: messagePrompt, chat: 0));
                      mesageController.clear();
                    });
                    chatList.addAll(await submitGetChatsForm(
                      context: context,
                      prompt: messagePrompt,
                      tokenValue: tokenValue,
                    ));
                    setState(() {});
                  }),
                  child: Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Image.asset(
                        'assets/images/arrow.png',
                        height: 50,
                        width: 55,
                      ))),
              filled: true,
              fillColor: Colors.transparent,
              labelStyle: const TextStyle(fontSize: 12),
              contentPadding: const EdgeInsets.all(20),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
