enum Flavor {
  dev,
  prod,
}

final class FlavorConfig {
  static late Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title => switch (appFlavor) {
        Flavor.dev => 'DEV Riverpod Template',
        Flavor.prod => 'Riverpod Template',
      };

  // TODO(Developer): Uncomment and adjust if needed
  // static Image get logo => switch (appFlavor) {
  //   Flavor.dev => Assets.icons.logoDev.image(),
  //   Flavor.prod => Assets.icons.logo.image(),
  // };

  static String get baseURL => switch (appFlavor) {
        // TODO(User): Update these values
        Flavor.dev => 'https://jsonplaceholder.typicode.com',
        Flavor.prod => 'https://jsonplaceholder.typicode.com',
      };
}
