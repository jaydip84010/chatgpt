import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../errors/exceptions.dart';
import '../models/images.dart';
import '../network/network_client.dart';
import '../utils/constants.dart';
import 'error_message.dart';

Future<List<Imagesmodel>> submitGetImagesmodelForm({
  required BuildContext context,
  required String prompt,
  required int n,
}) async {
  //
  NetworkClient networkClient = NetworkClient();
  List<Imagesmodel> ImagesmodelList = [];
  try {
    final res = await networkClient.post(
      'https://api.openai.com/v1/Imagesmodel/generations',
      {"prompt": prompt, "n": n, "size": "1024x1024"},
      token: OPEN_API_KEY,
    );
    Map<String, dynamic> mp = jsonDecode(res.toString());
    debugPrint(mp.toString());
    if (mp['data'].length > 0) {
      ImagesmodelList = List.generate(mp['data'].length, (i) {
        return Imagesmodel.fromJson(<String, dynamic>{
          'url': mp['data'][i]['url'],
        });
      });
      debugPrint(ImagesmodelList.toString());
    }
  } on RemoteDataException catch (e) {
    Logger().e(e.dioError);
    errorProviderMessage(context);
  }
  return ImagesmodelList;
}
