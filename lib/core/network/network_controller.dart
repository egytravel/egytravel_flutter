import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// `true`  → device has an active network interface
  /// `false` → no connectivity
  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Check once at startup
    checkConnection();
    // Then listen for changes
    _subscription = _connectivity.onConnectivityChanged.listen(
      _updateStatus,
      onError: _handleConnectivityError,
    );
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  /// Called by the "Try Again" button.
  Future<void> checkConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateStatus(results);
    } on MissingPluginException {
      _handleMissingPlugin();
    } on PlatformException catch (_) {
      _handleConnectivityError();
    }
  }

  void _updateStatus(List<ConnectivityResult> results) {
    // Connected if at least one result is not `none`
    isConnected.value = results.any((r) => r != ConnectivityResult.none);
  }

  void _handleConnectivityError([Object? _]) {
    // Keep the app usable if the platform check fails temporarily.
    isConnected.value = true;
  }

  void _handleMissingPlugin() {
    // Native plugins need a full rebuild after dependency changes. Until then,
    // avoid crashing at startup and let the app continue online.
    isConnected.value = true;
  }
}
