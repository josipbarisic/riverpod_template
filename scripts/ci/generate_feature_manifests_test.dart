// Regression fixture for the manifest generator's per-run file cache.
// Run: dart run scripts/ci/generate_feature_manifests_test.dart

import 'dart:convert';
import 'dart:io';

import '../generate_feature_manifests.dart' as generator;

void expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}

void write(String path, String content) {
  final file = File(path);
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(content);
}

Map<String, String> outputs() => {
  for (final file in Directory('lib/manifests').listSync().whereType<File>())
    file.path.replaceAll('\\', '/'): jsonEncode(
      (jsonDecode(file.readAsStringSync()) as Map)..remove('generatedAt'),
    ),
};

List<String> consumersOf(String repository) => generator.findRepositoryMethodUsages(
  'fetch',
  'lib/data/repositories/$repository',
  [],
);

void main() {
  final previous = Directory.current;
  final fixture = Directory.systemTemp.createTempSync('manifest-inputs-');
  try {
    Directory.current = fixture;
    const onboardingController = 'lib/presentation/onboarding/onboarding_controller.dart';
    const splashController = 'lib/presentation/splash/splash_controller.dart';
    const onboardingManifest = 'lib/manifests/onboarding.manifest.generated.json';
    const addition = 'lib/presentation/onboarding/addition.dart';
    const newTest = 'test/presentation/onboarding/new_test.dart';

    write(onboardingController, 'void load() { repository.fetch(1); }');
    write(splashController, 'void boot() { repository.fetch(2); }');
    write('lib/data/repositories/first_repository.dart', 'Future<String> fetch(int id) async => "first";');
    write('lib/data/repositories/second_repository.dart', 'Future<String> fetch(int id) async => "second";');
    write('lib/data/interfaces/first_interface.dart', 'Future<String> fetch(int id);');
    write(
      'lib/presentation/onboarding/labels.dart',
      "const label = 'call repository.fetch(5) later';\nfinal entry = fetchProvider('fetch');",
    );

    generator.generateAllManifests();
    final first = outputs();
    expect(first.length == 2, 'Every emitted fixture manifest is checked');

    final expected = [onboardingController, splashController];
    for (final repository in ['first_repository.dart', 'second_repository.dart']) {
      expect(
        jsonEncode(consumersOf(repository)) == jsonEncode(expected),
        'Duplicate method names keep both cross-feature consumers, '
        'and string-literal mentions are not consumers',
      );
    }

    final content = generator.readFileSafe(splashController);
    write(splashController, 'void boot() { repository.fetch(3); }');
    expect(
      generator.readFileSafe(splashController) == content,
      'One generation reads each file once',
    );
    generator.generateAllManifests();
    expect(
      generator.readFileSafe(splashController).contains('fetch(3)'),
      'The next generation reads changed content afresh',
    );

    write(newTest, 'void main() {}');
    write(addition, 'void added() { repository.fetch(4); }');
    generator.generateAllManifests();
    final withAddition = outputs();
    expect(
      withAddition.keys.toSet().containsAll(first.keys),
      'Manifest output paths stay stable',
    );
    expect(
      withAddition[onboardingManifest]!.contains('new_test.dart'),
      'New test files are discovered on the next generation',
    );
    expect(
      consumersOf('first_repository.dart').contains(addition),
      'New cross-feature consumers are discovered',
    );

    File(newTest).deleteSync();
    File(addition).deleteSync();
    generator.generateAllManifests();
    expect(
      !outputs()[onboardingManifest]!.contains('new_test.dart'),
      'Removed test files disappear on the next generation',
    );
    expect(
      !consumersOf('first_repository.dart').contains(addition),
      'Removed consumers disappear',
    );

    stdout.writeln(
      'PASS: per-run snapshot, additions and removals, duplicate names, '
      'cross-feature consumers, string-literal filter',
    );
  } finally {
    Directory.current = previous;
    fixture.deleteSync(recursive: true);
  }
}
