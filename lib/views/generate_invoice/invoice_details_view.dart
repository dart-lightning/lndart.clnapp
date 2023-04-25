import 'package:clnapp/components/buttons.dart';
import 'package:clnapp/model/app_model/generate_invoice.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class InvoiceDetailsView extends StatefulWidget {
  final AppGenerateInvoice invoiceResponse;

  const InvoiceDetailsView({Key? key, required this.invoiceResponse})
      : super(key: key);
  @override
  State<InvoiceDetailsView> createState() => _InvoiceDetailsViewState();
}

class _InvoiceDetailsViewState extends State<InvoiceDetailsView> {
  Widget _buildMainView() {
    return Padding(
      padding: const EdgeInsets.all(26.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            "Share lightning invoice",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            width: 180,
            child:
                QrImage(data: widget.invoiceResponse.generateResponse.invoice),
          ),
          Text(widget.invoiceResponse.generateResponse.invoice),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MainCircleButton(
                  icon: Icons.send_outlined, label: "Share", onPress: () {}),
              const SizedBox(
                width: 20,
              ),
              MainCircleButton(icon: Icons.copy, label: "Copy", onPress: () {}),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
      ),
      body: _buildMainView(),
    );
  }
}
