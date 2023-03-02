import 'dart:convert';

import 'package:clnapp/api/client_provider.dart';
import 'package:clnapp/model/user_setting.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/utils/register_provider.dart';
import 'package:clnapp/views/home/home_view.dart';
import 'package:clnapp/views/setting/lnlambda_setting_view.dart';
import 'package:clnapp/views/setting/unix_setting_view.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/utils.dart';
import 'grpc_setting_view.dart';

class SettingView extends StatefulWidget {
  final AppProvider provider;

  const SettingView({Key? key, required this.provider}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  // FIXME: move in a util function
  Future<String> pickDir() async {
    final setting = widget.provider.get<Setting>();
    String? path = await FilePicker.platform.getDirectoryPath();
    setState(() {
      setting.path = path ?? "No path found";
    });
    return setting.path!;
  }

  Future<bool> saveSettings({required Setting setting}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("setting", json.encode(setting.toJson()));
    widget.provider.overrideDependence(setting);
    return true;
  }

  Widget _buildCorrectSettingView(
      {required BuildContext context, required Setting setting}) {
    switch (setting.clientMode!) {
      case ClientMode.grpc:
        return GrpcSettingView(context: context);
      case ClientMode.unixSocket:
        return UnixSettingView(context: context);
      case ClientMode.lnlambda:
        return LnlambdaSettingView(context: context);
    }
  }

  Widget _buildMainView({required BuildContext context}) {
    Size size = MediaQuery.of(context).size;
    var setting = widget.provider.get<Setting>();
    final clients = ClientProvider.getClientByDefPlatform();
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(left: size.width * 0.2, right: size.width * 0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              height: size.height * 0.09,
              child: const Text(
                "Settings",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Utils.textWithPadding("Connection Type", 10),
            InputDecorator(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), isCollapsed: true),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                    value: setting.clientMode,
                    underline: const SizedBox(),
                    items: clients.map((ClientMode items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items.toString()),
                      );
                    }).toList(),
                    onChanged: (ClientMode? newValue) {
                      setState(() {
                        setting.clientMode = newValue!;
                      });
                    },
                  ),
                )),
            _buildCorrectSettingView(context: context, setting: setting),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 5),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (setting.isValid()) {
                        await saveSettings(setting: setting);
                        await ManagerAPIProvider.registerClientFromSetting(
                            setting, widget.provider);
                        // https://stackoverflow.com/questions/68871880/do-not-use-buildcontexts-across-async-gaps
                        if (!mounted) return;
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => HomeView(
                                      provider: widget.provider,
                                    )),
                            (Route<dynamic> route) => false);
                      }
                    },
                    child: const Text("Save"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 5),
                  child: ElevatedButton(
                    onPressed: () async => {
                      await ManagerAPIProvider.clear(provider: widget.provider),
                      setState(() {
                        setting = setting;
                      })
                    },
                    child: const Text("Clear"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildMainView(context: context),
    );
  }
}
