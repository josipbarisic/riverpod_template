import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_template/core/utils/user_handler/user_handler.dart';
import 'package:riverpod_template/data/repositories/user_repository/user_repository_providers.dart';
import 'package:riverpod_template/models/user/user.dart';

part 'profile_controller.g.dart';

/// Controls user profile viewing and editing.
///
/// Reads from [UserHandler] for current user state and uses
/// [UserRepository] for backend updates.
///
/// State semantics:
/// - `AsyncData(user)` — user profile loaded
/// - `AsyncLoading` — fetching or updating
/// - `AsyncError` — failed with message
@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<User?> build() {
    // Return current user from global state
    return ref.watch(userHandlerProvider);
  }

  /// Refreshes user data from the backend.
  Future<void> refreshProfile(int userId) async {
    state = const AsyncLoading();

    try {
      final user = await ref.read(userRepositoryProvider).fetchUserData(userId);
      if (!ref.mounted) return;
      state = AsyncData(user);
    } catch (e) {
      if (!ref.mounted) return;
      log('Error refreshing profile: $e');
      state = AsyncError(e, StackTrace.current);
    }
  }

  /// Updates user profile fields on the backend.
  ///
  /// [formData] should be a map of field names to values
  /// matching your API contract.
  Future<bool> updateProfile({required Map<String, dynamic> formData}) async {
    state = const AsyncLoading();

    try {
      final result = await ref.read(userRepositoryProvider).updateUserData(formData: formData);

      if (!ref.mounted) return false;

      if (result.httpStatusCode == 200) {
        // UserHandler is updated inside userRepository.updateUserData
        state = AsyncData(ref.read(userHandlerProvider));
        return true;
      } else {
        state = AsyncError(result.message, StackTrace.current);
        return false;
      }
    } catch (e) {
      if (!ref.mounted) return false;
      log('Error updating profile: $e');
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }
}
