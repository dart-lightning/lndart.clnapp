import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/utils/directory_picker.dart';
import 'package:flutter/material.dart';

import '../../model/user_setting.dart';

class GrpcSettingView extends StatefulWidget {
  final BuildContext context;

  const GrpcSettingView({Key? key, required this.context}) : super(key: key);

  @override
  State<GrpcSettingView> createState() => _GrpcSettingViewState();
}

class _GrpcSettingViewState extends State<GrpcSettingView> {
  Widget buildGrpcSettingView(
      {required BuildContext context, required Setting setting}) {
    var padding = MediaQuery.of(context).size.width * 0.1;

    return Wrap(
        runSpacing: MediaQuery.of(context).size.height * 0.05,
        children: <Widget>[
          Row(
            children: [
              const Text("TLS certificate directory path"),
              Padding(
                padding: EdgeInsets.only(left: padding),
                child: ElevatedButton(
                    onPressed: () async {
                      String picker = await DirectoryPicker.pickDir();
                      setState(() {
                        setting.path = picker;
                      });
                    },
                    child: const Text('Browser')),
              ),
            ],
          ),
          InputDecorator(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            child: Text(setting.path ?? "not found"),
          ),
          const Text("Host"),
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
