import 'package:flutter/material.dart';

void errorProviderMessage(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Something went wrong. please try again later"),
      backgroundColor: Colors.lightBlue,
    ),
  );
  Navigator.pop(context);
}
