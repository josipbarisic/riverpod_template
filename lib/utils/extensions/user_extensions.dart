import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_template/domain/user/user.dart' as domain;

extension FirebaseUserToDomainUser on User {
  domain.User toDomainUser() => domain.User(
        id: uid,
        email: providerData[0].email ?? email ?? 'N/A',
        firstName: displayName?.split(' ').first ?? '',
        lastName: displayName?.split(' ').skip(1).join(' ') ?? '',
        firebaseUserId: uid,
        createdAt: metadata.creationTime,
        updatedAt: metadata.lastSignInTime,
      );
}
