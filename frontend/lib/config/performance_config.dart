import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

class PerformanceConfig {
  // Control image caching
  static const int maxImageCacheSize = 50;
  static const int maxImageCacheSizeBytes = 50 * 1024 * 1024; // 50MB

  // Control network timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  
  // Control pagination
  static const int itemsPerPage = 10;
  
  // Debug flags
  static bool get shouldPrintPerformanceLogs => kDebugMode;
  
  // Memory management
  static void optimizeMemory() {
    PaintingBinding.instance.imageCache.maximumSize = maxImageCacheSize;
    PaintingBinding.instance.imageCache.maximumSizeBytes = maxImageCacheSizeBytes;
  }
} 