import 'package:clnapp/api/api.dart';
import 'package:clnapp/views/pay/qr_screen.dart';
import 'package:flutter/material.dart';
import '../../components/buttons.dart';
import '../../model/app_model/generate_invoice.dart';
import '../../utils/app_provider.dart';

class RequestView extends StatefulWidget {
  final AppProvider provider;

  const RequestView({Key? key, required this.provider}) : super(key: key);

  @override
  State<RequestView> createState() => _RequestViewState();
}

class _RequestViewState extends State<RequestView> {
  String display = '';

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
        title: const Text('Generate an invoice'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 350,
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    display,
                    textScaleFactor: 1.0,
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
