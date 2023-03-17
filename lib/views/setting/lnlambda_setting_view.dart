import 'package:flutter/material.dart';
import '../../model/user_setting.dart';
import '../../utils/app_provider.dart';

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
    return Wrap(
        runSpacing: MediaQuery.of(context).size.height * 0.05,
        children: <Widget>[
          const Text("Node ID"),
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
          const Text("Host"),
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
          const Text("Lambda Server"),
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
          const Text("Rune"),
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
