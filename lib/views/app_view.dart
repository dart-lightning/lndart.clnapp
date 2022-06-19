import 'package:clnapp/utils/app_provider.dart';
import 'package:flutter/material.dart';

abstract class AppView extends StatelessWidget {
  final AppProvider provider;

  const AppView({Key? key, required this.provider}) : super(key: key);
}
