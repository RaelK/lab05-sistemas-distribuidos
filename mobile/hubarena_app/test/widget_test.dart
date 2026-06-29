import 'package:flutter_test/flutter_test.dart';
import 'package:hubarena_app/main.dart';

void main() {
  testWidgets('Renderiza seleção de perfil', (tester) async {
    await tester.pumpWidget(const HubArenaApp());

    expect(find.text('HubArena'), findsOneWidget);
    expect(find.text('Entrar como Cliente'), findsOneWidget);
    expect(find.text('Entrar como Prestador'), findsOneWidget);
  });
}
