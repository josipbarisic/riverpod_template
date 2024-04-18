# riverpod_template

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

This template's architecture is based off of the
following: https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/

Template relies on Riverpod and is utilising its auto-generation for providers feature. To learn
more about it, check the following: https://codewithandrea.com/articles/flutter-riverpod-generator/

There are multiple sources to get you more familiar with both riverpod in general and the
architecture/structure of this template:

- [Structure](https://codewithandrea.com/articles/flutter-project-structure/)
- [Domain Layer](https://codewithandrea.com/articles/flutter-app-architecture-domain-model/)
- [Presentation Layer](https://codewithandrea.com/articles/flutter-presentation-layer/)
- Data Layer
  - Data Layer encompasses Repositories and Models as mentioned in the Structure section.
  - [Data utilisation/flow and mutations](https://codewithandrea.com/articles/data-mutations-riverpod/)
- [Repository Pattern](https://codewithandrea.com/articles/flutter-repository-pattern/)
- [Application/Service
  Layer](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/)

Several other useful resources:

- [Data Caching and Provider
  Lifecycle](https://codewithandrea.com/articles/flutter-riverpod-data-caching-providers-lifecycle/)

This template is not a one-size-fits-all solution. It is a starting point and
everything in it is subject to change based on the requirements of the project. It is a good idea to
familiarise yourself with the architecture and structure of the template and adjust it to your
needs.

[Important note]: Template has Firebase set up in order to implement widely used features such as
Push Notifications, Authentication, etc. If you are not planning to use Firebase, make sure to
remove all the Firebase related code and dependencies. Outside of pubspec.yaml, those are:

- firebase.json
- firebase_options.dart
- android/app/google-services.json
- ios/Runner/GoogleService-Info.plist
- android/app/src/main/AndroidManifest.xml notification icon meta-data=
- Google services plugin in android/build.gradle and settings.gradle, and GoogleService-Info
  mentions in project.pbxproj
