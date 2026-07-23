import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

extension AsyncNotifierListenerExtension on WidgetRef {
  /// Listen to an AsyncValue provider with callbacks for data, error, and loading states.
  void listenToAsyncNotifier<T>(
    ProviderListenable<AsyncValue<T>> provider, {
    Function(T data)? onData,
    Function(String error)? onError,
    Function()? onLoading,
    bool defaultLogs = false,
  }) {
    listen<AsyncValue<T>>(provider, (previous, next) {
      // Prevent handling the same data multiple times
      if (previous == next) return;
      next.when(
        data: (data) {
          onData != null ? onData(data) : null;
          if (defaultLogs) log('AsyncProviderListener::${provider.runtimeType} Data =>  $data');
        },
        error: (error, _) {
          onError != null ? onError(error.toString()) : null;
          if (defaultLogs) log('AsyncProviderListener::${provider.runtimeType} Error =>  $error');
        },
        loading: () {
          onLoading != null ? onLoading() : null;
          if (defaultLogs) log('AsyncProviderListener::${provider.runtimeType} Loading ...');
        },
      );
    });
  }
}

extension ManagedDataDisposalProviderExtension on Ref {
  /// Manages data caching with automatic disposal after a timeout.
  /// 
  /// Useful for providers that fetch data and should cache it for a period
  /// but dispose when no longer needed.
  void manageDataCaching({
    required Duration disposalTimerDuration,
    CancelToken? cancelToken,
    Function(Timer? timer, CancelToken? cancelToken)? onDisposeCallback,
    Function(dynamic keepAliveLink, Timer? timer)? onCancelCallback,
    Function(Timer? timer)? onResumeCallback,
    bool showLogs = false,
    String? logTag,
  }) {
    if (showLogs || logTag != null) {
      log('================== Managing data caching for ${logTag ?? runtimeType} ==================');
    }
    
    final link = keepAlive();
    Timer? timer;

    onDispose(() {
      if (showLogs || logTag != null) log('${logTag ?? runtimeType}: onDispose');
      if (onDisposeCallback != null) {
        onDisposeCallback(timer, cancelToken);
      } else {
        timer?.cancel();
        cancelToken?.cancel();
      }
    });

    onCancel(() {
      if (showLogs || logTag != null) log('${logTag ?? runtimeType}: onCancel');
      if (onCancelCallback != null) {
        onCancelCallback(link, timer);
      } else {
        timer = Timer(disposalTimerDuration, () {
          link.close();
        });
      }
    });

    onResume(() {
      if (showLogs || logTag != null) log('${logTag ?? runtimeType}: onResume');
      if (onResumeCallback != null) {
        onResumeCallback(timer);
      } else {
        timer?.cancel();
      }
    });
  }
}
