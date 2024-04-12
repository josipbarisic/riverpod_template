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

  // TODO(Me): Add later
  /*static Image get logo => switch (appFlavor) {
    Flavor.dev => Assets.icons.logoDev.image(),
    Flavor.prod => Assets.icons.logo.image(),
  };*/

  static String get baseURL => switch (appFlavor) {
        // TODO(User): Update these values
        Flavor.dev => 'https://j85c3h.buildship.run',
        Flavor.prod => 'https://j85c3h.buildship.run',
      };
}
