import 'package:clnapp/utils/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class SettingView extends StatefulWidget {
  final AppProvider provider;

  const SettingView({Key? key, required this.provider}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  String? nickName;

  String connectionClient = 'gRPC connection';

  String selectedPath = "No path found";

  String host = "localhost";

  @override
  void initState() {
    super.initState();
  }

  var clients = [
    'gRPC connection',
    'Unix connection',
    'Lnlambda connection',
  ];

  Future<String> pickDir() async {
    String? path = await FilePicker.platform.getDirectoryPath();
    path == null ? selectedPath = "No path found" : selectedPath = path;
    return selectedPath;
  }

  saveSettings() {}

  Widget _buildMainView({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.2,
          right: MediaQuery.of(context).size.width * 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text("Node Nick Name "),
          TextFormField(
            onChanged: (name) {
              name = nickName!;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'My lightning node',
            ),
          ),
          const Text("Connection type"),
          InputDecorator(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            child: DropdownButton(
              value: connectionClient,
              underline: const SizedBox(),
              items: clients.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  connectionClient = newValue!;
                });
              },
            ),
          ),
          Row(
            children: [
              connectionClient == clients[0]
                  ? const Text("TLS certificate directory path")
                  : connectionClient == clients[1]
                      ? const Text("lightning-rpc file path")
                      : const Text("Lnlambda related file if any?"),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              ElevatedButton(
                  onPressed: () {
                    pickDir().then((value) => {
                          setState(() {
                            selectedPath = value;
                          }),
                        });
                  },
                  child: const Text('Browser')),
            ],
          ),
          InputDecorator(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            child: Text(selectedPath),
          ),
          const Text("Host"),
          TextFormField(
            onChanged: (host) {
              host = host;
            },
            initialValue: host,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              saveSettings();
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
      body: _buildMainView(context: context),
    );
  }
}
