import 'package:clnapp/api/api.dart';
import 'package:clnapp/api/client_provider.dart';
import 'package:clnapp/api/cln/cln_client.dart';
import 'package:clnapp/constants/user_setting.dart';
import 'package:clnapp/helper/settings/get_settings.dart';
import 'package:clnapp/utils/app_provider.dart';
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
    path == null ? setting.path = "No path found" : setting.path = path;
    return setting.path;
  }

  Future<bool> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    clients.asMap().forEach((index, element) async {
      if (setting.connectionType == element) {
        await prefs.setInt('connectionClient', index);
      }
    });

    await prefs.setString('selectedPath', setting.path);

    await prefs.setString('host', setting.host);

    await prefs.setString(
        'nickName', setting.nickName.isEmpty ? "null" : setting.nickName);

    return true;
  }

  Widget _buildMainView({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.2,
          right: MediaQuery.of(context).size.width * 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text("Connection type"),
          InputDecorator(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            child: DropdownButton(
              value: setting.connectionType,
              underline: const SizedBox(),
              items: clients.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  setting.connectionType = newValue!;
                });
              },
            ),
          ),
          const Text("Node Nick Name "),
          TextFormField(
            onChanged: (name) {
              setState(() {
                setting.nickName = name;
              });
            },
            initialValue: setting.nickName == "null" ? "" : setting.nickName,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'My lightning node',
            ),
          ),
          Row(
            children: [
              setting.connectionType == clients[0]
                  ? const Text("TLS certificate directory path")
                  : setting.connectionType == clients[1]
                      ? const Text("lightning-rpc file path")
                      : const Text("Lnlambda related file if any?"),
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
            onChanged: (text) {
              setState(() {
                setting.host = text;
              });
            },
            initialValue: setting.host,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (setting.path != "No path found") {
                setState(() {
                  isLoading = true;
                });
                saveSettings().then((value) => {
                      isLoading = false,
                    });
                widget.provider.registerLazyDependence<AppApi>(() {
                  if (setting.connectionType == clients[0]) {
                    return CLNApi(
                        mode: ClientMode.grpc,
                        client: ClientProvider.getClient(
                            mode: ClientMode.grpc,
                            opts: {
                              ///FIXME: make a login page and take some path as input
                              'certificatePath': setting.path,
                              'host': setting.host,
                              'port': 8001,
                            }));
                  } else {
                    return CLNApi(
                        mode: ClientMode.unixSocket,

                        ///FIXME: make a login page and take some path as input
                        client: ClientProvider.getClient(
                            mode: ClientMode.unixSocket,
                            opts: {
                              // include the path if you want use the unix socket. N.B it is broken!
                              'path': "${setting.path}/lightning-rpc",
                            }));
                  }
                });
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
        ],
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
