import 'package:flutter_test/flutter_test.dart';
import 'package:agrichili/main.dart';

void main() {
  testWidgets('AgriChili app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AgriChiliApp());

    // Verify app title exists in app bar
    expect(find.text('AgriChili Monitor'), findsWidgets);
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Sensor'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);
    expect(find.text('Sistem'), findsOneWidget);
  });
}
