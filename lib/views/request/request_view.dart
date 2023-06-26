import 'package:clnapp/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:clnapp/components/buttons.dart';
import 'package:clnapp/model/app_model/generate_invoice.dart';
import 'package:clnapp/utils/app_provider.dart';

class RequestView extends StatefulWidget {
  final AppProvider provider;

  const RequestView({Key? key, required this.provider}) : super(key: key);

  @override
  State<RequestView> createState() => _RequestViewState();
}

class _RequestViewState extends State<RequestView> {
  String display = '0';

  Future<AppGenerateInvoice> generateInvoice() async {
    String label = '${DateTime.now()}';
    String description =
        "This is a new description created at${DateTime.now()}";
    AppGenerateInvoice response = await widget.provider
        .get<AppApi>()
        .generateInvoice(label, description, amount: int.parse(display));
    return response;
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
                    AppGenerateInvoice invoiceModel = await generateInvoice();
                    if (context.mounted) {
                      _showBottomDialog(
                          context: context, invoice: invoiceModel.invoice);
                    }
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
      {required BuildContext context, required AppInvoice invoice}) {
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
                        const Spacer(flex: 2),
                        Expanded(
                            flex: 1,
                            child: Container(
                                alignment: Alignment.topRight,
                                padding: const EdgeInsets.all(20),
                                child: IconButton(
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
                      child: QrImageView(
                        data: invoice.bolt11,
                        version: QrVersions.auto,
                        backgroundColor: Colors.white,
                      )),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: invoice.bolt11));
                            const snackBar =
                                SnackBar(content: Text('Copied to clipboard!'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          icon: const Icon(
                            Icons.copy,
                            size: 20,
                          ))),
                  const Spacer(flex: 2),
                ],
              ));
        });
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
