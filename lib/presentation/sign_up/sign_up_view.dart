import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_template/data/firebase/firebase_api_providers.dart';

class SignUpView extends ConsumerWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationData = GoRouterState.of(context).extra as RemoteMessage?;
    log('Notification data: ${notificationData?.notification?.toMap() ?? 'EMPTY'}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp View'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text('NOTIFICATION MESSAGE:\n${notificationData?.notification?.title}'),
              Text('HAS MSG:${ref.watch(hasRemoteMessageProvider)}'),
            ],
          ),
        ),
      ),
    );
  }
}
