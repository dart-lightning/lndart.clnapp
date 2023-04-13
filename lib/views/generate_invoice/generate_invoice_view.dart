import 'package:clnapp/api/api.dart';
import 'package:clnapp/components/buttons.dart';
import 'package:clnapp/model/app_model/generate_invoice.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/views/generate_invoice/invoice_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GenerateInvoiceView extends StatefulWidget {
  final AppProvider provider;

  const GenerateInvoiceView({Key? key, required this.provider})
      : super(key: key);
  @override
  State<GenerateInvoiceView> createState() => _GenerateInvoiceViewState();
}

class _GenerateInvoiceViewState extends State<GenerateInvoiceView> {
  String state = "";
  String? boltString;
  String? labelString;
  String? descriptionString;
  int? amountMsat;
  AppGenerateInvoice? invoiceResponse;
  String? error;

  Future<AppGenerateInvoice> generateInvoice(
      String labelString, String descriptionString, int? amountMsat) async {
    // we don't need error handling here
    final response = await widget.provider.get<AppApi>().generateInvoice(
        label: labelString, msat: amountMsat, description: descriptionString);
    setState(() {
      state = "Generated Invoice ${response.generateResponse.invoice}";
    });
    return response;
  }

  Widget _buildMainView() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextField(
            onChanged: (invoiceLabel) {
              labelString = invoiceLabel;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Label',
              hintText: 'Invoice label',
            ),
          ),
          TextField(
            onChanged: (invoiceDescription) {
              descriptionString = invoiceDescription;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
              hintText: 'Invoice description',
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: amountMsat == null ? false : true,
                onChanged: (value) {
                  setState(() {
                    amountMsat = (value == true ? 0 : null);
                  });
                },
              ),
              const Text(
                'Enter milli-satoshi amount?',
                style: TextStyle(fontSize: 17.0),
              ), //Text//SizedBox
            ],
          ),
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            onChanged: (amount) {
              amountMsat = int.parse(amount);
            },
            enabled: amountMsat == null ? false : true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              disabledBorder: OutlineInputBorder(),
              labelText: 'Amount to receive in millisatoshi',
              hintText: 'Eg: 100 msats',
            ),
          ),
          MainCircleButton(
              icon: Icons.send_outlined,
              label: "Request",
              onPress: () {
                if (labelString == null || labelString!.isEmpty) {
                  setState(() {
                    error = "Error: Label is required";
                  });
                } else {
                  generateInvoice(labelString!, descriptionString!, amountMsat)
                      .then((value) => {
                            setState(() {
                              invoiceResponse = value;
                              error = null;
                            }),
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InvoiceDetailsView(
                                        invoiceResponse: invoiceResponse!)))
                          });
                }
              }),
          error == null ? Text(state) : Text(error!)
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
