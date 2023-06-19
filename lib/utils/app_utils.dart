import 'package:flutter/material.dart';

/// For showing snackbar
void showSnackBar(String title, BuildContext context) {
  var snackBar = SnackBar(content: Text(title));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
