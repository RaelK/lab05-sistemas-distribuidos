import 'package:flutter_test/flutter_test.dart';
import 'package:prestador/main.dart';

void main() {
  testWidgets('Renderiza app do prestador', (tester) async {
    await tester.pumpWidget(const HubArenaProviderApp());

    expect(find.text('HubArena Prestador'), findsOneWidget);
  });
}
