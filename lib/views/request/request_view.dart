import 'package:cln_common/cln_common.dart';
import 'package:clnapp/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:clnapp/components/buttons.dart';
import 'package:clnapp/model/app_model/generate_invoice.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/model/app_model/newaddr.dart';
import 'package:clnapp/utils/app_utils.dart';
import 'package:clnapp/utils/error.dart';

class RequestView extends StatefulWidget {
  final AppProvider provider;

  const RequestView({Key? key, required this.provider}) : super(key: key);

  @override
  State<RequestView> createState() => _RequestViewState();
}

enum RadioButtonData { btcAddress, lightningInvoice }

class _RequestViewState extends State<RequestView> {
  String display = '0';
  String? btcAddress;
  String? invoice;

  Future<bool> generateInvoice() async {
    String label = '${DateTime.now()}';
    String description =
        "This is a new description created at ${DateTime.now()}";
    try {
      AppGenerateInvoice response = await widget.provider
          .get<AppApi>()
          .generateInvoice(label, description, amount: int.parse(display));
      setState(() {
        invoice = response.invoice.bolt11;
      });
      return true;
    } on LNClientException catch (e) {
      PopUp.showPopUp(context, 'Invalid Rune', e.message, true);
      return false;
    }
  }

  Future<bool> newaddr() async {
    try {
      AppNewAddr response = await widget.provider.get<AppApi>().newAddr();
      setState(() {
        btcAddress = response.bech32;
      });
      return true;
    } on LNClientException catch (e) {
      PopUp.showPopUp(context, 'Invalid Rune', e.message, true);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true,
        top: true,
        child: Column(
          children: [
            const Spacer(flex: 1),
            Expanded(
              flex: 1,
              child: Text(
                display,
                textScaleFactor: 1.5,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(flex: 1),
            Expanded(
              child: ButtonBar(
                buttonHeight: 0,
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  numberButton(size, '1'),
                  numberButton(size, '2'),
                  numberButton(size, '3')
                ],
              ),
            ),
            Expanded(
              child: ButtonBar(
                buttonHeight: 0,
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  numberButton(size, '4'),
                  numberButton(size, '5'),
                  numberButton(size, '6')
                ],
              ),
            ),
            Expanded(
              child: ButtonBar(
                buttonHeight: 0,
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  numberButton(size, '7'),
                  numberButton(size, '8'),
                  numberButton(size, '9')
                ],
              ),
            ),
            Expanded(
              child: ButtonBar(
                buttonHeight: 0,
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  numberButton(size, '.'),
                  numberButton(size, '0'),
                  numberButton(
                    size,
                    '',
                    icon: Icons.backspace_outlined,
                  ),
                ],
              ),
            ),
            const Spacer(flex: 1),
            Expanded(
              child: MainCircleButton(
                  icon: Icons.send_outlined,
                  label: "Request",
                  onPress: () async {
                    if (display == '0') {
                      PopUp.showPopUp(context, 'Invalid amount',
                          'Enter an amount > 0', true);
                      return;
                    }
                    showDialogForRequest();
                  }),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  // FIXME: put this generic component inside the trash package
  void _showBottomDialog(
      {required BuildContext context, required RadioButtonData identifier}) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) {
          return FractionallySizedBox(
              heightFactor: 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Container(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                    padding: const EdgeInsets.all(25),
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(
                                      Icons.close,
                                      size: 20,
                                    )))),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        title(identifier),
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          description(identifier),
                          style: const TextStyle(fontSize: 20),
                        ),
                      )),
                  Expanded(flex: 4, child: showQR()),
                  const Spacer(flex: 1),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                          onPressed: () {
                            String text = checkText(identifier);
                            Clipboard.setData(ClipboardData(text: text));
                            showSnackBar('Copied to clipboard', context);
                          },
                          icon: const Icon(
                            Icons.copy,
                            size: 20,
                          ))),
                  const Spacer(flex: 1),
                ],
              ));
        });
  }

  /// Processes the QR for the invoice and the btc address
  Widget showQR() {
    if (btcAddress == null && invoice == null) {
      return const CircularProgressIndicator();
    }
    return QrImageView(
      data: invoice ?? btcAddress!,
      version: QrVersions.auto,
      backgroundColor: Colors.white,
    );
  }

  /// Returns description for the bottomSheet
  String description(RadioButtonData identifier) {
    if (identifier == RadioButtonData.btcAddress) {
      return 'Receive payments at this address';
    }
    return 'Receive payments via this lightning invoice';
  }

  /// Returns title for the bottomSheet
  String title(RadioButtonData identifier) {
    if (identifier == RadioButtonData.btcAddress) {
      return 'BTC address';
    }
    return 'Lightning invoice';
  }

  /// Returns the type of text which needs to be copied
  String checkText(RadioButtonData identifier) {
    if (identifier == RadioButtonData.btcAddress) {
      return btcAddress!;
    }
    return invoice!;
  }

  void showDialogForRequest() {
    RadioButtonData? selectedValue;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Payment Method',
            style: Theme.of(context).textTheme.bodyLarge!.apply(
                  fontSizeFactor: 1.6,
                )),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width * 0.25,
          child: StatefulBuilder(
            builder:
                (BuildContext context, void Function(void Function()) set) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('On chain'),
                      Radio<RadioButtonData>(
                        activeColor: Colors.pinkAccent,
                        groupValue: selectedValue,
                        onChanged: (RadioButtonData? value) async {
                          set(() {
                            selectedValue = value!;
                          });
                          bool isValid = await newaddr();
                          if (isValid && context.mounted) {
                            _showBottomDialog(
                                context: context,
                                identifier: RadioButtonData.btcAddress);
                          }
                        },
                        value: RadioButtonData.btcAddress,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Off chain {lightning}'),
                      Radio<RadioButtonData>(
                        activeColor: Colors.pinkAccent,
                        groupValue: selectedValue,
                        onChanged: (RadioButtonData? value) async {
                          set(() {
                            selectedValue = value!;
                          });
                          bool isValid = await generateInvoice();
                          if (isValid && context.mounted) {
                            _showBottomDialog(
                                context: context,
                                identifier: RadioButtonData.lightningInvoice);
                          }
                        },
                        value: RadioButtonData.lightningInvoice,
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget numberButton(Size size, String value, {IconData? icon}) {
    return InkWell(
      borderRadius: BorderRadius.circular(45),
      onTap: () {
        if (icon != null) {
          /// Handling the exception
          if (display.length == 1) {
            display = '0';
          } else {
            display = display.substring(0, display.length - 1);
          }
        }

        /// To get only one decimal in the field
        if (display.contains('.')) {
          if (value == '.') {
            return;
          }
        }

        /// Maximum length of 9
        if (display.length > 9) {
          return;
        }
        setState(() {
          display = int.parse(display + value).toString();
        });
      },
      child: Container(
        alignment: Alignment.center,
        height: size.height * 0.12,
        width: size.width * 0.15,
        child: Center(
          child: icon != null
              ? Icon(
                  icon,
                  size: 35,
                )
              : Text(
                  value,
                  textScaleFactor: 1.0,
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
