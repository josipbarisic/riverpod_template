/// Represents the authentication provider used for sign-in.
///
/// The [providerId] matches Firebase's provider ID format.
enum SignInProvider {
  phone('phone'),
  google('google.com'),
  apple('apple.com'),
  email('password');

  final String providerId;

  const SignInProvider(this.providerId);
}
