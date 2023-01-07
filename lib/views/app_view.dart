import 'package:clnapp/utils/app_provider.dart';
import 'package:flutter/material.dart';

abstract class AppView extends StatelessWidget {
  final AppProvider provider;

  const AppView({Key? key, required this.provider}) : super(key: key);

  void showSnackBar(BuildContext context, String message,
      {Action? action, String label = "Close"}) {
    var snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Theme.of(context).cardColor,
        content: Text(message),
        action: SnackBarAction(
            label: label,
            textColor: Theme.of(context).textTheme.labelLarge!.color,
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar()));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

abstract class StatefulAppView extends StatefulWidget {
  final AppProvider provider;

  const StatefulAppView({Key? key, required this.provider}) : super(key: key);

  void showSnackBar(
      {required BuildContext context,
      required String message,
      Action? action,
      String label = "Close"}) {
    var snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Theme.of(context).cardColor,
        content: Text(message),
        action: SnackBarAction(
            label: label,
            textColor: Theme.of(context).textTheme.labelLarge!.color,
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar()));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
