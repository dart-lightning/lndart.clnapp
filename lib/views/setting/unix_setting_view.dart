import 'package:flutter/material.dart';

import '../../model/user_setting.dart';
import '../../utils/app_provider.dart';
import '../../utils/directory_picker.dart';

class UnixSettingView extends StatefulWidget {
  final BuildContext context;
  const UnixSettingView({Key? key, required this.context}) : super(key: key);

  @override
  State<UnixSettingView> createState() => _UnixSettingViewState();
}

class _UnixSettingViewState extends State<UnixSettingView> {
  Widget _buildUnixSettingView(
      {required BuildContext context, required Setting setting}) {
    var padding = MediaQuery.of(context).size.width * 0.1;

    return Wrap(
        runSpacing: MediaQuery.of(context).size.height * 0.05,
        children: <Widget>[
          Row(
            children: [
              const Text("lightning-rpc file path"),
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
        ]);
  }

  @override
  Widget build(BuildContext context) {
    final setting = AppProvider().get<Setting>();
    return Container(
      child: _buildUnixSettingView(context: context, setting: setting),
    );
  }
}
