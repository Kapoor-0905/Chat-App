import 'package:flutter/material.dart';

class Constants {
  static String appId = "1:696106708622:web:2c9887df6f1ecc3e00a3df";
  static String apiKey = "AIzaSyBClkTXNzeKK20XhhsIdTZMYAGruqfo6Mo";
  static String messagingSenderId = "696106708622";
  static String projectId = "chatapp-5b417";

  static const primaryColor = Color.fromARGB(255, 137, 44, 220);
}

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}
