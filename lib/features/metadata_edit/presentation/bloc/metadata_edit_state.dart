part of 'metadata_edit_bloc.dart';

sealed class MetadataEditState extends Equatable {
  const MetadataEditState();
  
  @override
  List<Object> get props => [];
}

final class MetadataEditInitial extends MetadataEditState {}
