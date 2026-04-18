import 'package:fluent_ui/fluent_ui.dart';
import 'package:tagdoc/core/theme/tagdoc_theme.dart';

import 'package:tagdoc/features/movies_renamer/presentation/pages/movies_renamer_page_v2.dart';
import 'package:tagdoc/init_dependencies.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tagdoc/l10n/app_localizations.dart';
import 'package:tagdoc/core/config/settings_manager.dart';

void main() async {
  // make sure the Flutter engine is ready for any async setup
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  
  // Load dynamic logic for tags (Qualities, Sources)
  SettingsManager.loadSettingsFromFile('settings.json');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Windows App',
      theme: FluentThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: TagDocColors.surface,
        accentColor: Colors
            .blue, // Fluent UI requires a SystemAccentColor for some internal defaults
        navigationPaneTheme: NavigationPaneThemeData(
          backgroundColor: TagDocColors.surfaceContainerLowest,
          selectedIconColor: WidgetStateProperty.all(TagDocColors.primary),
          selectedTextStyle: WidgetStateProperty.all(
            const TextStyle(
              color: TagDocColors.primary,
              fontWeight: FontWeight.w600,
              fontFamily: 'Manrope',
            ),
          ),
          unselectedIconColor: WidgetStateProperty.resolveWith((states) {
            if (states.isHovered) return TagDocColors.primary;
            return TagDocColors.onSurfaceVariant;
          }),
          unselectedTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.isHovered) {
              return const TextStyle(
                color: TagDocColors.primary,
                fontFamily: 'Manrope',
              );
            }
            return const TextStyle(
              color: TagDocColors.onSurfaceVariant,
              fontFamily: 'Manrope',
            );
          }),
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MyHomePage(title: 'Windows App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int topIndex = 0;

  @override
  Widget build(BuildContext context) {
    debugPrint('main page built');
    return NavigationView(
      pane: NavigationPane(
        selected: topIndex,
        onChanged: (index) => setState(() => topIndex = index),
        // displayMode: ???,
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.home),
            title: const Text('Renamer'),
            body: MoviesRenamerPageV2(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Settings'),
            body: const Center(child: Text('Settings Page')),
          ),
        ],
      ),
    );
  }
}
