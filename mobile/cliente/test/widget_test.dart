import 'package:cliente/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Renderiza o aplicativo HubArena Cliente', (tester) async {
    await tester.pumpWidget(const HubArenaClienteApp());

    expect(find.text('HubArena Cliente'), findsOneWidget);
  });
}
