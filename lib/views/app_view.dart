import 'package:clnapp/model/user_setting.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:flutter/material.dart';

abstract class AppView extends StatelessWidget {
  final AppProvider provider;

  final Setting setting;

  const AppView({Key? key, required this.provider, required this.setting})
      : super(key: key);
}
