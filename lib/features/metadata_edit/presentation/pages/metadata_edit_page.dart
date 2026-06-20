import 'package:fluent_ui/fluent_ui.dart';
import 'package:tagdoc/core/constants/app_constants.dart';
import 'package:tagdoc/core/presentation/widgets/app_page_scaffold.dart';

/// A page that allows editing metadata of movies.
///
/// It uses the common [AppPageScaffold] to ensure consistent typography and padding.
class MetadataEditPage extends StatelessWidget {
  /// Creates an [MetadataEditPage].
  const MetadataEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPageScaffold(
      title: AppConstants.metadataPageTitle,
      child: Center(child: Text('Edit Metadata Page')),
    );
  }
}
