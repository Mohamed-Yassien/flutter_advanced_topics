import 'dart:io';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/// The result of preparing a file for upload.
class PreparedUpload {
  const PreparedUpload({
    required this.file,
    required this.hash,
    required this.sizeBytes,
  });

  final File file; // the compressed file, ready to upload
  final String hash; // SHA-256 of the COMPRESSED bytes
  final int sizeBytes; // final size after compression
}

/// Prepares a file for upload: compress → hash → ready.
/// Order matters: we hash what we actually send.
Future<PreparedUpload> prepareForUpload(File original) async {
  // 1. Compress (only if it's an image worth compressing).
  final isImage = _looksLikeImage(original.path);
  final fileToUpload = isImage ? await compressFile(file: original) : original;

  // 2. Hash the bytes we'll actually upload.
  final hash = await hashFileStreaming(fileToUpload);

  // 3. Report final size.
  final size = await fileToUpload.length();

  return PreparedUpload(
    file: fileToUpload,
    hash: hash,
    sizeBytes: size,
  );
}

bool _looksLikeImage(String path) {
  final ext = path.toLowerCase();
  return ext.endsWith('.jpg') || ext.endsWith('.jpeg') || ext.endsWith('.png');
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

Future<File> compressFile(
    {required File file,
    int quality = 80,
    int maxWidth = 1920,
    int maxHeight = 1920}) async {
  final directory = await getTemporaryDirectory();
  final targetPath =
      join(directory.path, 'cmp_${DateTime.now().millisecondsSinceEpoch}.jpg');

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
