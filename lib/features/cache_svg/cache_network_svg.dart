import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';

class CacheNetworkSvg extends StatelessWidget {
  const CacheNetworkSvg(
      {super.key,
      required this.url,
      this.width,
      this.height,
      this.placeholder});

  final String url;
  final double? width;
  final double? height;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadSvg(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SvgPicture.memory(
            snapshot.data!,
            width: width,
            height: height,
          );
        }
        if (snapshot.hasError) {
          return const Icon(Icons.error);
        }
        return placeholder ?? const CircularProgressIndicator();
      },
    );
  }

  Future<Uint8List> _loadSvg() async {
    var file = await DefaultCacheManager().getSingleFile(url);
    return file.readAsBytes();
  }
}

Future<void> precacheSvg(List<String> urls) async {
  for (var url in urls) {
    final loader = SvgAssetLoader(url);
    await svg.cache.putIfAbsent(
      loader.cacheKey(null),
      () => loader.loadBytes(null),
    );
  }
}
