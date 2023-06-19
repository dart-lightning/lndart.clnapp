import 'package:clnapp/components/buttons.dart';
import 'package:clnapp/views/request/request_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:clnapp/api/api.dart';
import 'package:clnapp/model/app_model/newaddr.dart';
import 'package:clnapp/utils/app_provider.dart';

class BTCAddress extends StatefulWidget {
  final AppProvider provider;

  const BTCAddress({Key? key, required this.provider}) : super(key: key);

  @override
  State<BTCAddress> createState() => _BTCAddressState();
}

class _BTCAddressState extends State<BTCAddress> {
  String? address;

  Future<void> newaddr() async {
    AppNewAddr response = await widget.provider.get<AppApi>().newAddr();
    setState(() {
      address = response.bech32;
    });
  }

  @override
  void initState() {
    newaddr();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(20),
                        child: const Text(
                          'Your BTC address',
                          style: TextStyle(fontSize: 30),
                        ),
                      )),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    'Receive payments at this address',
                    style: TextStyle(fontSize: 20),
                  ),
                )),
            Expanded(
                flex: 3,
                child: address == null
                    ? const CircularProgressIndicator()
                    : QrImageView(
                        data: address!,
                        version: QrVersions.auto,
                        backgroundColor: Colors.white,
                      )),
            Expanded(
                flex: 1,
                child: IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: address!));
                      const snackBar =
                          SnackBar(content: Text('Copied to clipboard!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    icon: const Icon(
                      Icons.copy,
                      size: 20,
                    ))),
            Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    'Create a lightning invoice',
                    style: TextStyle(fontSize: 16),
                  ),
                )),
            Expanded(
                flex: 1,
                child: MainCircleButton(
                  icon: Icons.send,
                  label: 'invoice',
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            RequestView(provider: widget.provider)));
                  },
                )),
            const Spacer(flex: 1),
          ],
        ));
  }
}
