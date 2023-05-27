import 'package:clnapp/api/api.dart';
import 'package:clnapp/views/request/qr_screen.dart';
import 'package:flutter/material.dart';
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
  String msats = 'msats';

  Future<AppGenerateInvoice> generateInvoice() async {
    String label = '${DateTime.now()}';
    String description =
        "This is a new description created at${DateTime.now()}";
    AppGenerateInvoice response = await widget.provider
        .get<AppApi>()
        .generateInvoice(label, description, amount: double.parse(display).floor());
    ///TODO: Implement a Alertbox for decimal values
    return response;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: size.width * 0.35,
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$display $msats',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                numberButton(size, '1'),
                numberButton(size, '2'),
                numberButton(size, '3')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                numberButton(size, '4'),
                numberButton(size, '5'),
                numberButton(size, '6')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                numberButton(size, '7'),
                numberButton(size, '8'),
                numberButton(size, '9')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
            MainCircleButton(
                icon: Icons.send_outlined,
                label: "Request",
                onPress: () async {
                  AppGenerateInvoice invoiceModel = await generateInvoice();
                  if (context.mounted) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => QrScreen(
                            invoice: invoiceModel.invoice,
                            provider: widget.provider)));
                  }
                }),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }

  Widget numberButton(Size size, String value, {IconData? icon}) {
    return InkWell(
      onTap: () {
        if (icon != null) {
          /// Handling the exception
          if (display.isEmpty) {
            return;
          }
          display = display.substring(0, display.length - 1);
        }

        /// when we first boot up the request screen
        if(display == '0') {
          setState(() {
            display = value;
          });
          return;
        }

        // if(display.startsWith('.')) {
        //   setState(() {
        //     display = '0.';
        //   });
        //   return;
        // }

        /// To get only one decimal in the field
        if (display.contains('.')) {
          if (value == '.') {
            return;
          }
        }

        /// When display value sets to null
        if(display.isEmpty) {
          setState(() {
            display = '0';
          });
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
        height: size.height * 0.12,
        width: size.width * 0.25,
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
