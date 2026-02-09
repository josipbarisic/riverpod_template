import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_template/data/firebase/firebase_api_providers.dart';
import 'package:riverpod_template/data/repositories/auth_repository/auth_repository.dart';

part 'auth_repository_providers.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepository(
      firebaseAuth: ref.read(firebaseApiProvider).firebaseAuth,
    );
