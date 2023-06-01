import 'package:clnapp/api/api.dart';
import 'package:clnapp/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:clnapp/components/buttons.dart';
import 'package:clnapp/model/app_model/generate_invoice.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:trash_component/components/global_components.dart';

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

    /// This could generate an error if the rune have restrictions=readonly
    AppGenerateInvoice response = await widget.provider
        .get<AppApi>()
        .generateInvoice(label, description,
            amount: double.parse(display).floor());
    return response;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
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
                textScaleFactor: 1.0,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
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
                    ///TODO: Show a warning here when the display value is in decimals
                    if (double.parse(display).floor() == 0) {
                      GlobalComponent.showAppDialog(
                          context: context,
                          title: 'Please enter a valid amount',
                          message: 'Enter a amount greater than 0',
                          closeMsg: 'Close',
                          imageProvided: const AssetImage(
                              'assets/images/exclamation.png'));
                      return;
                    }
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
        backgroundColor: Theme.of(context).disabledColor,
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
                            flex: 1,
                            child: Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.all(20),
                                child: IconButton(
                                    onPressed: () =>
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomeView(
                                                    provider: widget.provider)),
                                            (route) => false),
                                    icon: const Icon(
                                      Icons.home,
                                      size: 20,
                                      color: Colors.black,
                                      weight: 10,
                                      grade: 10,
                                    )))),
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
                                      color: Colors.black,
                                    )))),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 6,
                      child: QrImageView(
                        data: invoice.bolt11,
                        version: QrVersions.auto,
                        backgroundColor: Colors.white,
                        gapless: false,
                      )),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: invoice.bolt11));
                      const snackBar = SnackBar(
                        content: Text('Copied to clipboard!'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.2,
                        // margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.41),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.copy),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Copy invoice',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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
            setState(() {
              display = '0';
            });
            return;
          } else {
            display = display.substring(0, display.length - 1);
          }
        }

        /// To get only one decimal in the field
        if (display.contains('.') && value == '.') {
          return;
        }

        /// if value =='.' then the display would be in the form of '.23232'
        if (display == '0' && value != '.') {
          setState(() {
            display = value;
          });
          return;
        }

        /// Maximum length of 9
        if (display.length > 9) {
          return;
        }
        setState(() {
          display = display + value;
        });
      },
      child: Container(
        alignment: Alignment.center,
        height: size.height * 0.12,
        width: size.width * 0.15,
        decoration: BoxDecoration(border: Border.all(width: 0.025)),
        child: Center(
          child: icon != null
              ? Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 35,
                )
              : Text(
                  value,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
        ),
      ),
    );
  }
}