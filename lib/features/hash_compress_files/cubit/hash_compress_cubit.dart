import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_advanced_topics/features/hash_compress_files/cubit/hash_compress_files_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:convert/convert.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'; // for hex encoding

class HashCompressCubit extends Cubit<HashCompressFilesState> {
  HashCompressCubit() : super(HashCompressFilesInitial());

  static HashCompressCubit get(context) =>
      BlocProvider.of<HashCompressCubit>(context);

  Future<String> hashFileWithFuture(File file) {
    final bytes = file.readAsBytesSync();
    final digets = sha256.convert(bytes);
    return Future.value(digets.toString());
  }

  Future<String> hashFileStreaming(File file) async {
    final output = AccumulatorSink<Digest>();
    final input = sha256.startChunkedConversion(output);

    // openRead() yields the file in chunks instead of all at once.
    await for (final chunk in file.openRead()) {
      input.add(chunk);
    }
    input.close();
    return output.events.single.toString();
  }

  // compress images and files
  Future<File> compressFile(
      {required File file,
      int quality = 80,
      int maxWidth = 1920,
      int maxHeight = 1920}) async {
    final directory = await getTemporaryDirectory();
    final targetPath = join(
        directory.path, 'cmp_${DateTime.now().millisecondsSinceEpoch}.jpg');

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      minWidth: maxWidth,
      minHeight: maxHeight,
    );
    if (result == null) {
      return file;
    } else {
      return File(result.path);
    }
  }

  //compress big json files
  Uint8List compressJsonFile(Object data) {
    final jsonString = jsonEncode(data);
    final bytes = utf8.encode(jsonString);
    return Uint8List.fromList(gzip.encode(bytes));
  }

  ///hash big file in background using isolate
  Future<String> hashBigFileInBackground(File file) async {
    return compute(hashWithIsolste, file.path);
  }

  Future<String> hashWithIsolste(String path) async {
    final file = File(path);
    return hashFileStreaming(file);
  }
}
