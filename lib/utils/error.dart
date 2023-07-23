import 'package:flutter/cupertino.dart';
import 'package:trash_component/components/global_components.dart';

class PopUp {
  static void showPopUp(
      BuildContext context, String title, String message, bool isError) {
    GlobalComponent.showAppDialog(
        context: context,
        title: title,
        message: message,
        closeMsg: 'Ok',
        imageProvided: isError
            ? const AssetImage('assets/images/exclamation.png')
            : const AssetImage('assets/images/checkmark.png'));
  }
}
