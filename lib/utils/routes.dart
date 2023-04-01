import 'package:chatgpt/src/screen/chat_screen.dart';
import 'package:chatgpt/src/screen/dalle_screen.dart';
import 'package:flutter/material.dart';

import '../errors/exceptions.dart';

class RouteGeneratorService {
  static const String dalle = 'dalle';
  static const String chat = 'chat';
  RouteGeneratorService._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dalle:
        return MaterialPageRoute(builder: (_) => const DalleImgScreen());
      case chat:
        return MaterialPageRoute(builder: (_) => const ChatScreen());

      default:
        throw RouteDataException('Route not found');
    }
  }
}
