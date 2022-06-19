import 'package:clnapp/main.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    var provider = await AppProvider().init();
    await tester.pumpWidget(CLNApp(provider: provider));
  });
}
