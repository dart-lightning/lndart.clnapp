import 'dart:convert';

import 'package:clnapp/api/client_provider.dart';
import 'package:clnapp/model/user_setting.dart';
import 'package:clnapp/helper/settings/get_settings.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/utils/register_provider.dart';
import 'package:clnapp/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingView extends StatefulWidget {
  final AppProvider provider;

  const SettingView({Key? key, required this.provider}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  late bool isLoading;

  TextEditingController nickNameController = TextEditingController()..text = "";

  TextEditingController hostController = TextEditingController()
    ..text = "localhost";

  Setting setting = Setting();

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getSettingsInfo().then((value) => {
          setState(() {
            isLoading = false;
            setting = value;
          }),
        });
  }

  Future<String> pickDir() async {
    String? path = await FilePicker.platform.getDirectoryPath();
    // FIXME: migrate the setting to null safety, use the null to avoid
    // check on string
    path == null ? setting.path = "No path found" : setting.path = path;
    return setting.path;
  }

  Future<bool> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("setting", json.encode(setting.toJson()));
    return true;
  }

  Widget _buildGrpcSettingView({required BuildContext context}) {
    return Wrap(
        runSpacing: MediaQuery.of(context).size.height * 0.05,
        children: <Widget>[
          Row(
            children: [
              const Text("TLS certificate directory path"),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              ElevatedButton(
                  onPressed: () {
                    pickDir().then((value) => {
                          setState(() {
                            setting.path = value;
                          }),
                        });
                  },
                  child: const Text('Browser')),
            ],
          ),
          InputDecorator(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            child: Text(setting.path),
          ),
          const Text("Host"),
          TextFormField(
            controller: hostController,
            onChanged: (text) {
              setState(() {
                setting.host = text;
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ]);
  }

  Widget _buildUnixSettingView({required BuildContext context}) {
    return Wrap(
        runSpacing: MediaQuery.of(context).size.height * 0.05,
        children: <Widget>[
          Row(
            children: [
              const Text("lightning-rpc file path"),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              ElevatedButton(
                  onPressed: () {
                    pickDir().then((value) => {
                          setState(() {
                            setting.path = value;
                          }),
                        });
                  },
                  child: const Text('Browser')),
            ],
          ),
          InputDecorator(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            child: Text(setting.path),
          ),
        ]);
  }

  Widget _buildLnlambdaSettingView({required BuildContext context}) {
    return Wrap(
        runSpacing: MediaQuery.of(context).size.height * 0.05,
        children: <Widget>[
          const Text("Node ID"),
          TextFormField(
            onChanged: (text) {
              setState(() {
                setting.nodeId = text;
              });
            },
            decoration: const InputDecoration(
              label: Text("node Id"),
              border: OutlineInputBorder(),
            ),
          ),
          const Text("Host"),
          TextFormField(
            onChanged: (text) {
              setState(() {
                setting.host = text;
              });
            },
            decoration: const InputDecoration(
              label: Text("host"),
              border: OutlineInputBorder(),
            ),
          ),
          const Text("Lambda Server"),
          TextFormField(
            onChanged: (text) {
              setState(() {
                setting.lambdaServer = text;
              });
            },
            decoration: const InputDecoration(
              label: Text("lnlambda server url"),
              border: OutlineInputBorder(),
            ),
          ),
          const Text("Rune"),
          TextFormField(
            onChanged: (text) {
              setState(() {
                setting.rune = text;
              });
            },
            decoration: const InputDecoration(
              label: Text("rune"),
              border: OutlineInputBorder(),
            ),
          ),
        ]);
  }

  Widget _buildCorrectSettingView(
      {required BuildContext context, required Setting setting}) {
    switch (setting.clientMode) {
      case ClientMode.grpc:
        return _buildGrpcSettingView(context: context);
      case ClientMode.unixSocket:
        return _buildUnixSettingView(context: context);
      case ClientMode.lnlambda:
        return _buildLnlambdaSettingView(context: context);
    }
  }

  Widget _buildMainView({required BuildContext context}) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.2,
            right: MediaQuery.of(context).size.width * 0.2),
        child: Wrap(
          runSpacing: MediaQuery.of(context).size.height * 0.05,
          children: [
            const Text("Connection type"),
            InputDecorator(
              decoration: const InputDecoration(border: OutlineInputBorder()),
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
            ),
            const Text("Node Nick Name "),
            TextFormField(
              controller: nickNameController,
              onChanged: (name) {
                setState(() {
                  setting.nickName = name;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'My lightning node',
              ),
            ),
            _buildCorrectSettingView(context: context, setting: setting),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (setting.isValid()) {
                      saveSettings();
                      RegisterProvider()
                          .registerClientFromSetting(setting, widget.provider);
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
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.remove("setting");
                    getSettingsInfo().then((value) => {
                          setState(() {
                            setting = value;
                            nickNameController.clear();
                            hostController.text = "localhost";
                          }),
                        });
                  },
                  child: const Text("Clear"),
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildMainView(context: context),
    );
  }
}
