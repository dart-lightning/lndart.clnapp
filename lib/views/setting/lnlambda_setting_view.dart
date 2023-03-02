import 'package:flutter/material.dart';

import '../../model/user_setting.dart';
import '../../utils/app_provider.dart';
import '../../utils/utils.dart';

class LnlambdaSettingView extends StatefulWidget {
  final BuildContext context;
  const LnlambdaSettingView({Key? key, required this.context})
      : super(key: key);

  @override
  State<LnlambdaSettingView> createState() => _LnlambdaSettingViewState();
}

class _LnlambdaSettingViewState extends State<LnlambdaSettingView> {
  Widget _buildLnlambdaSettingView(
      {required BuildContext context, required Setting setting}) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Utils.textWithPadding("Node ID", 10),
          TextFormField(
            controller: TextEditingController(text: setting.nodeId ?? ''),
            onChanged: (text) {
              setting.nodeId = text;
            },
            decoration: const InputDecoration(
              label: Text("node Id"),
              border: OutlineInputBorder(),
            ),
          ),
          Utils.textWithPadding("Host", 10),
          TextFormField(
            controller: TextEditingController(text: setting.host ?? ''),
            onChanged: (text) {
              setting.host = text;
            },
            decoration: const InputDecoration(
              label: Text("host"),
              border: OutlineInputBorder(),
            ),
          ),
          Utils.textWithPadding("Lambda Server", 10),
          TextFormField(
            controller: TextEditingController(text: setting.lambdaServer ?? ''),
            onChanged: (text) {
              setting.lambdaServer = text;
            },
            decoration: const InputDecoration(
              label: Text("lnlambda server url"),
              border: OutlineInputBorder(),
            ),
          ),
          Utils.textWithPadding("Rune", 10),
          TextFormField(
            controller: TextEditingController(text: setting.rune ?? ''),
            onChanged: (text) {
              setting.rune = text;
            },
            decoration: const InputDecoration(
              label: Text("rune"),
              border: OutlineInputBorder(),
            ),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    final setting = AppProvider().get<Setting>();
    return Container(
      child: _buildLnlambdaSettingView(context: context, setting: setting),
    );
  }
}
