import 'package:fluent_ui/fluent_ui.dart';

import 'package:tagdoc/features/movies_renamer/presentation/widgets/card_dropdown_wdgt.dart';

import 'package:tagdoc/features/movies_renamer/presentation/widgets/card_text_box_wdgt.dart';

class MovieCardWdgt extends StatefulWidget {
  const MovieCardWdgt({
    super.key,
    required this.fileName,
    required this.title,
    required this.year,
    required this.resolution,
    required this.quality,
    required this.source,
    required this.poster,
  });

  final String fileName;
  final String title;
  final String year;
  final String resolution;
  final String quality;
  final String source;
  final String poster;

  @override
  State<MovieCardWdgt> createState() => _MovieCardWdgtState();
}

class _MovieCardWdgtState extends State<MovieCardWdgt> {
  late String _selectedResolution;
  late String _selectedQuality;
  late String _selectedSource;

  final List<String> _resolutions = ['2160p', '1080p', '720p', '480p'];
  final List<String> _qualities = [
    'WEB-DL',
    'BluRay',
    'DVDRip',
    'HDDRip',
    'HC',
  ];
  final List<String> _sources = [
    'Netflix',
    'Amazon',
    'Disney+',
    'Hulu',
    'iTunes',
    'Google Play',
  ];

  late final TextEditingController _titleController;
  late final TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _selectedResolution = widget.resolution;
    _selectedQuality = widget.quality;
    _selectedSource = widget.source;

    _titleController = TextEditingController(text: widget.title);
    _yearController = TextEditingController(text: widget.year);

    _ensureInitialValueExists(_resolutions, _selectedResolution);
    _ensureInitialValueExists(_qualities, _selectedQuality);
    _ensureInitialValueExists(_sources, _selectedSource);
  }

  void _ensureInitialValueExists(List<String> list, String value) {
    if (!list.contains(value)) {
      list.insert(0, value);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      borderRadius: BorderRadius.circular(20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Container(
              width: 60,
              height: 90,
              color: FluentTheme.of(context).resources.subtleFillColorSecondary,
              child: const Icon(FluentIcons.media, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.fileName,
                  style: FluentTheme.of(context).typography.caption,
                ),
                const SizedBox(height: 8),
                Wrap(
                  direction: Axis.horizontal,
                  // alignment: WrapAlignment.spaceBetween,
                  spacing: 10,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      child: CardTextBoxWdgt(
                        controller: _titleController,
                        placeholder: 'Title',
                        title: 'Title',
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: CardTextBoxWdgt(
                        controller: _yearController,
                        placeholder: 'Year',
                        title: 'Year',
                      ),
                    ),
                    CardDropdownWdgt(
                      items: _resolutions,
                      value: _selectedResolution,
                      onChanged: (value) {
                        if (value != null && value != _selectedResolution) {
                          setState(() => _selectedResolution = value);
                        }
                      },
                      title: 'Resolution',
                    ),
                    CardDropdownWdgt(
                      items: _qualities,
                      value: _selectedQuality,
                      onChanged: (value) {
                        if (value != null && value != _selectedQuality) {
                          setState(() => _selectedQuality = value);
                        }
                      },
                      title: 'Quality',
                    ),
                    CardDropdownWdgt(
                      items: _sources,
                      value: _selectedSource,
                      onChanged: (value) {
                        if (value != null && value != _selectedSource) {
                          setState(() => _selectedSource = value);
                        }
                      },
                      title: 'Source',
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(icon: const Icon(FluentIcons.delete), onPressed: () {}),
        ],
      ),
    );
  }
}
