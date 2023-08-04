import 'package:clnapp/utils/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:trash_component/components/button.dart';

class CLNBottomSheet {
  static void bottomSheet({
    required BuildContext context,
    required String display,
    required AppProvider provider,
    required Future<void> Function(dynamic) onPress,
    required String boltString,
    required dynamic invoice,
    required dynamic navigate,
    required String text1,
    required String text2,
  }) {
    var size = MediaQuery.of(context).size;
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
                    flex: 1,
                    child: GestureDetector(
                      onTap: () async {
                        if (invoice.amount != 0) {
                          return;
                        }
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => navigate));
                      },
                      child: Text(
                        '$display msats',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: size.height * 0.30,
                      width: size.width < 900
                          ? size.width * 0.90
                          : size.width * 0.5,
                      child: Card(
                        elevation: 10.0,
                        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  invoice.pubKey,
                                  style: TextStyle(
                                    color: Theme.of(context).disabledColor,
                                    fontSize: 18,
                                  ),
                                ),
                                Expanded(
                                  flex: size.width > 400 ? 1 : 2,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(
                                        color: Colors.white,
                                        width: 2.0,
                                      ),
                                    ),
                                    margin: const EdgeInsets.only(top: 15),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Center(
                                        child: Text(
                                          invoice.description,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        text1,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        text2,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  invoice.amount != 0
                      ? Expanded(
                          flex: 1,
                          child: MainCircleButton(
                              width: 200,
                              icon: Icons.paypal,
                              label: 'Pay invoice',
                              onPress: () async {
                                await onPress(boltString);
                              }),
                        )
                      : const Expanded(
                          flex: 1,
                          child: Text(
                              "You need to specify the amount of the given invoice"),
                        ),
                ],
              ));
        });
  }
}
