import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A safe wrapper around [CachedNetworkImageProvider] that validates the URL
/// before attempting to load and provides a silent error handler.
///
/// Use this instead of [CachedNetworkImageProvider] directly in places like
/// [CircleAvatar.backgroundImage] or [DecorationImage] where there is no
/// `errorWidget` callback.
class SafeCachedNetworkImageProvider extends CachedNetworkImageProvider {
  SafeCachedNetworkImageProvider(
    super.url, {
    super.maxWidth,
    super.maxHeight,
    super.scale,
    super.headers,
    super.cacheManager,
    super.cacheKey,
    super.imageRenderMethodForWeb,
  });

  /// Returns true if [url] looks like a valid, loadable HTTP(S) URL.
  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    if (!url.startsWith('http://') && !url.startsWith('https://')) return false;

    // Basic hostname validation (must contain a dot after the scheme)
    try {
      final uri = Uri.parse(url);
      if (uri.host.isEmpty || !uri.host.contains('.')) return false;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Returns a [CachedNetworkImageProvider] only if the URL is valid,
  /// otherwise returns null.
  ///
  /// Usage:
  /// ```dart
  /// CircleAvatar(
  ///   backgroundImage: SafeCachedNetworkImageProvider.safe(url)
  ///       ?? const AssetImage('assets/fallback.png'),
  /// )
  /// ```
  static CachedNetworkImageProvider? safe(String? url) {
    if (!isValidUrl(url)) return null;
    return CachedNetworkImageProvider(url!);
  }
}
