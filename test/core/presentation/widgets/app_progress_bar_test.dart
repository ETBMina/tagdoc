import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tagdoc/core/presentation/widgets/app_progress_bar.dart';

void main() {
  testWidgets('AppProgressBar renders determinate progress correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const FluentApp(
        home: ScaffoldPage(
          content: AppProgressBar(
            current: 25,
            total: 100,
            title: 'Opening Files...',
            statusMessage: 'sample.mp4',
          ),
        ),
      ),
    );

    expect(find.text('Opening Files...'), findsOneWidget);
    expect(find.text('25 / 100 (25%)'), findsOneWidget);
    expect(find.text('sample.mp4'), findsOneWidget);
    expect(find.byType(AnimatedContainer), findsOneWidget);
  });

  testWidgets('AppProgressBar handles indeterminate mode when total is 0', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const FluentApp(
        home: ScaffoldPage(
          content: AppProgressBar(
            current: 0,
            total: 0,
            title: 'Selecting Files...',
          ),
        ),
      ),
    );

    expect(find.text('Selecting Files...'), findsOneWidget);
    expect(find.byType(ProgressBar), findsOneWidget);
    expect(find.textContaining('%'), findsNothing);
  });
}
