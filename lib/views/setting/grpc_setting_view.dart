import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/utils/directory_picker.dart';
import 'package:flutter/material.dart';

import '../../model/user_setting.dart';
import '../../utils/utils.dart';

class GrpcSettingView extends StatefulWidget {
  final BuildContext context;

  const GrpcSettingView({Key? key, required this.context}) : super(key: key);

  @override
  State<GrpcSettingView> createState() => _GrpcSettingViewState();
}

class _GrpcSettingViewState extends State<GrpcSettingView> {
  Widget buildGrpcSettingView(
      {required BuildContext context, required Setting setting}) {
    Size size = MediaQuery.of(context).size;
    return Wrap(runSpacing: size.height * 0.05, children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("TLS certificate directory path"),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ElevatedButton(
                onPressed: () async {
                  await DirectoryPicker.pickDir();
                },
                child: const Text('Browser')),
          ),
        ],
      ),
      InputDecorator(
        decoration: const InputDecoration(border: OutlineInputBorder()),
        child: Text(setting.path ?? "not found"),
      ),
      Utils.textWithPadding("Host", 4),
      TextFormField(
        controller: TextEditingController(text: setting.host ?? ''),
        onChanged: (text) {
          setting.host = text;
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final setting = AppProvider().get<Setting>();
    return Container(
      child: buildGrpcSettingView(context: context, setting: setting),
    );
  }
}
