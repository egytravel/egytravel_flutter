import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget buildLoadingOverlay(bool isLoading, bool isLogin) {
  if (!isLoading) return const SizedBox.shrink();

  return Container(
    color: Colors.black.withValues(alpha:0.35),
    child: Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha:0.25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingAnimationWidget.inkDrop(color: Colors.white, size: 50),
                const SizedBox(height: 20),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    isLogin ? 'Signing you in...' : 'Creating your account...',
                    key: ValueKey(isLogin),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
//
// Widget buildLoadingOverlay(bool isLoading, {String? text}) {
//   if (!isLoading) return const SizedBox.shrink();
//
//   return Container(
//     alignment: Alignment.center,
//     decoration: BoxDecoration(
//       color: Colors.black.withOpacity(0.35),
//     ),
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(24),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.12),
//             borderRadius: BorderRadius.circular(24),
//             border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.4),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.30),
//                 blurRadius: 12,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               LoadingAnimationWidget.flickr(
//                 leftDotColor: Colors.white,
//                 rightDotColor: Colors.blueAccent,
//                 size: 60,
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 text ?? "Please wait...",
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
