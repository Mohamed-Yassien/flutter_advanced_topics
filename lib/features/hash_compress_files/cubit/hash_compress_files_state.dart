abstract class HashCompressFilesState {}

class HashCompressFilesInitial extends HashCompressFilesState {}

class HashCompressFilesLoading extends HashCompressFilesState {}

class HashCompressFilesSuccess extends HashCompressFilesState {
  final String hash;

  HashCompressFilesSuccess(this.hash);
}

class HashCompressFilesError extends HashCompressFilesState {
  final String error;

  HashCompressFilesError(this.error);
}
