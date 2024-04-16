import 'flavors.dart';
import 'main.dart' as runner;

Future<void> main() async {
  FlavorConfig.appFlavor = Flavor.prod;
  await runner.main();
}
