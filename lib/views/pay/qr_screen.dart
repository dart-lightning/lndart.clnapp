import 'package:clnapp/model/app_model/generate_invoice.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScreen extends StatefulWidget {
  final AppProvider provider;
  final AppInvoice invoice;

  const QrScreen({Key? key, required this.invoice, required this.provider})
      : super(key: key);

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated QR'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImageView(
                data: widget.invoice.bolt11,
                version: QrVersions.auto,
                size: 350.0,
                backgroundColor: Colors.white,
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: widget.invoice.bolt11));
              const snackBar = SnackBar(content: Text('Copied to clipboard!'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Container(
              margin: const EdgeInsets.only(top: 40),
              width: 150,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.copy,
                    size: 20,
                  ),
                  Center(child: Text('Copy invoice'))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
