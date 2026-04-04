import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagdoc/features/movies_renamer/presentation/bloc/movies_renamer_bloc.dart';
import 'package:tagdoc/features/movies_renamer/presentation/widgets/movie_card_wdgt.dart';
import 'package:tagdoc/init_dependencies.dart';

import 'package:tagdoc/l10n/app_localizations.dart';

class MoviesRenamerPage extends StatelessWidget {
  const MoviesRenamerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    debugPrint('movies rebuilder page built');
    return BlocProvider(
      create: (_) => serviceLocator<MoviesRenamerBloc>(),
      child: Builder(
        builder: (context) {
          debugPrint('movies rebuilder page built after bloc provider');
          return ScaffoldPage(
            header: Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20.0),
              child: Text(
                l10n.moviesRenamer,
                style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
              ),
            ),
            content: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: FluentTheme.of(context).cardColor,
                      border: Border.all(
                        color: FluentTheme.of(
                          context,
                        ).resources.surfaceStrokeColorDefault,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: BlocBuilder<MoviesRenamerBloc, MoviesRenamerState>(
                      builder: (context, state) {
                        debugPrint('listview rebuilt');
                        return ListView(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          children: const [
                            // This area will be populated with movie items
                            MovieCardWdgt(
                              fileName: 'movie.mp4',
                              title: 'title',
                              year: '2025',
                              resolution: '1080p',
                              quality: 'WEB-DL',
                              source: 'Netflix',
                              poster: 'poster',
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 100.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Button(
                          onPressed: () {
                            context.read<MoviesRenamerBloc>().add(
                              const SelectMoviesEvent(),
                            );
                          },
                          child: Text(l10n.addMovies),
                        ),
                        const Expanded(child: SizedBox()),
                        Button(onPressed: null, child: Text(l10n.clearAll)),
                        Button(
                          onPressed: null,
                          child: Text(l10n.exportToExcel),
                        ),
                        Button(onPressed: null, child: Text(l10n.renameAll)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
