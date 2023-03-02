import 'package:flutter/material.dart';

class Utils {
  static Widget textWithPadding(String data, double padd) {
    return Padding(
      padding: EdgeInsets.only(top: padd, bottom: padd),
      child: Text(
        data,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
