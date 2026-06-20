import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'metadata_edit_event.dart';
part 'metadata_edit_state.dart';

class MetadataEditBloc extends Bloc<MetadataEditEvent, MetadataEditState> {
  MetadataEditBloc() : super(MetadataEditInitial()) {
    on<MetadataEditEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
