import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../errors/exceptions.dart';
import '../models/chat.dart';
import '../models/images.dart';
import '../models/model.dart';

import '../utils/constants.dart';
import 'error_message.dart';
import 'network_client.dart';

Future<List<Imagesmodel>> submitGetImagesForm({
  required BuildContext context,
  required String prompt,
  required int n,
}) async {
  //
  NetworkClient networkClient = NetworkClient();
  List<Imagesmodel> imagesList = [];
  try {
    final res = await networkClient.post(
      '${BASE_URL}images/generations',
      {"prompt": prompt, "n": n, "size": "256x256"},
      token: OPEN_API_KEY,
    );
    Map<String, dynamic> mp = jsonDecode(res.toString());
    debugPrint(mp.toString());
    if (mp['data'].length > 0) {
      imagesList = List.generate(mp['data'].length, (i) {
        return Imagesmodel.fromJson(<String, dynamic>{
          'url': mp['data'][i]['url'],
        });
      });
      debugPrint(imagesList.toString());
    }
  } on RemoteDataException catch (e) {
    Logger().e(e.dioError);
    errorMessage(context);
  }
  return imagesList;
}

Future<List<Chatmodel>> submitGetChatsForm({
  required BuildContext context,
  required String prompt,
  required int tokenValue,
  String? model,
}) async {
  //
  NetworkClient networkClient = NetworkClient();
  List<Chatmodel> chatList = [];
  try {
    final res = await networkClient.post(
      "${BASE_URL}completions",
      {
        "model": model ?? "text-davinci-003",
        "prompt": prompt,
        "temperature": 0,
        "max_tokens": tokenValue
      },
      token: OPEN_API_KEY,
    );
    Map<String, dynamic> mp = jsonDecode(res.toString());
    debugPrint(mp.toString());
    if (mp['choices'].length > 0) {
      chatList = List.generate(mp['choices'].length, (i) {
        return Chatmodel.fromJson(<String, dynamic>{
          'msg': mp['choices'][i]['text'],
          'chat': 1,
        });
      });
      debugPrint(chatList.toString());
    }
  } on RemoteDataException catch (e) {
    Logger().e(e.dioError);
    errorMessage(context);
  }
  return chatList;
}

Future<List<Model>> submitGetModelsForm({
  required BuildContext context,
}) async {
  //
  NetworkClient networkClient = NetworkClient();
  List<Model> modelsList = [];
  try {
    final res = await networkClient.get(
      "${BASE_URL}models",
      token: OPEN_API_KEY,
    );
    Map<String, dynamic> mp = jsonDecode(res.toString());
    debugPrint(mp.toString());
    if (mp['data'].length > 0) {
      modelsList = List.generate(mp['data'].length, (i) {
        return Model.fromJson(<String, dynamic>{
          'id': mp['data'][i]['id'],
          'created': mp['data'][i]['created'],
          'root': mp['data'][i]['root'],
        });
      });
      debugPrint(modelsList.toString());
    }
  } on RemoteDataException catch (e) {
    Logger().e(e.dioError);
    errorMessage(context);
  }
  return modelsList;
}
