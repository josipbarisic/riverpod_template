// ignore_for_file: avoid_print

/// Feature Manifest Generator (Riverpod Template)
///
/// Scans lib/presentation/ and generates {feature}.manifest.generated.json per feature.
/// Uses RoutePath from lib/routing/router.dart. Output schema matches AI-first playbook.
///
/// Usage: dart run scripts/generate_feature_manifests.dart
library;

import 'dart:convert';
import 'dart:io';

// ═══════════════════════════════════════════════════════════════════════════
// TYPES (same schema as playbook)
// ═══════════════════════════════════════════════════════════════════════════

class RiverpodProvider {
  final String name;
  final String type;
  final String? returnType;
  final String file;
  RiverpodProvider({required this.name, required this.type, this.returnType, required this.file});
  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        if (returnType != null) 'returnType': returnType,
        'file': file,
      };
}

class StateClass {
  final String name;
  final List<String> fields;
  final String file;
  StateClass({required this.name, required this.fields, required this.file});
  Map<String, dynamic> toJson() => {'name': name, 'fields': fields, 'file': file};
}

class RouteDefinition {
  final String routePathConstant;
  final String pathValue;
  final String? view;
  RouteDefinition({required this.routePathConstant, required this.pathValue, this.view});
  String get appRoute => 'RoutePath.$routePathConstant';
  Map<String, dynamic> toJson() => {
        'appRoute': appRoute,
        'path': pathValue,
        if (view != null) 'view': view,
      };
}

class ApiEndpoint {
  final String httpMethod;
  final String endpoint;
  final String repository;
  final String method;
  final List<MethodParameter> methodParameters;
  final List<String> endpointPathParams;
  final Map<String, dynamic>? endpointBody;
  final List<String> usedIn;
  ApiEndpoint({
    required this.httpMethod,
    required this.endpoint,
    required this.repository,
    required this.method,
    required this.methodParameters,
    required this.endpointPathParams,
    this.endpointBody,
    required this.usedIn,
  });
  Map<String, dynamic> toJson() => {
        'httpMethod': httpMethod,
        'endpoint': endpoint,
        'repository': repository,
        'method': method,
        'methodParameters': methodParameters.map((p) => p.toJson()).toList(),
        'endpointPathParams': endpointPathParams,
        if (endpointBody != null) 'endpointBody': endpointBody,
        'usedIn': usedIn,
      };
}

class MethodParameter {
  final String name;
  final String type;
  final bool isRequired;
  final String? defaultValue;
  MethodParameter({required this.name, required this.type, this.isRequired = false, this.defaultValue});
  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'isRequired': isRequired,
        if (defaultValue != null) 'defaultValue': defaultValue,
      };
}

class ExternalService {
  final String service;
  final List<String> usedIn;
  ExternalService({required this.service, required this.usedIn});
  Map<String, dynamic> toJson() => {'service': service, 'usedIn': usedIn};
}

class ControllerMethod {
  final String name;
  final String? returnType;
  final String? params;
  final List<MethodParameter>? parameters;
  final String file;
  final int line;
  ControllerMethod({required this.name, this.returnType, this.params, this.parameters, required this.file, required this.line});
  Map<String, dynamic> toJson() => {
        'name': name,
        if (returnType != null) 'returnType': returnType,
        if (params != null) 'params': params,
        if (parameters != null) 'parameters': parameters!.map((p) => p.toJson()).toList(),
        'file': file,
        'line': line,
      };
}

class TestingInfo {
  final String testDirectory;
  final List<String> testFiles;
  final List<String> testDataFiles;
  final String runCommand;
  final bool hasTests;

  TestingInfo({
    required this.testDirectory,
    required this.testFiles,
    required this.testDataFiles,
    required this.runCommand,
  }) : hasTests = testFiles.isNotEmpty;

  Map<String, dynamic> toJson() => {
        'testDirectory': testDirectory,
        'testFiles': testFiles,
        'testDataFiles': testDataFiles,
        'runCommand': runCommand,
        'hasTests': hasTests,
      };
}

class FeatureManifest {
  final String generatedAt;
  final String feature;
  final List<String> views;
  final List<String> controllers;
  final List<String> widgets;
  final List<String> models;
  final List<String> services;
  final List<String> states;
  final List<String> repositories;
  final List<String> dependencies;
  final List<RiverpodProvider> providers;
  final List<StateClass> stateClasses;
  final List<RouteDefinition> routes;
  final List<ApiEndpoint> apiEndpoints;
  final List<ExternalService> externalServices;
  final Map<String, List<ControllerMethod>> controllerMethods;
  final TestingInfo testing;

  FeatureManifest({
    required this.generatedAt,
    required this.feature,
    required this.views,
    required this.controllers,
    required this.widgets,
    required this.models,
    required this.services,
    required this.states,
    required this.repositories,
    required this.dependencies,
    required this.providers,
    required this.stateClasses,
    required this.routes,
    required this.apiEndpoints,
    required this.externalServices,
    required this.controllerMethods,
    required this.testing,
  });

  Map<String, dynamic> toJson() => {
        'generatedAt': generatedAt,
        'feature': feature,
        'exports': {
          'views': views,
          'controllers': controllers,
          'widgets': widgets,
          'models': models,
          'services': services,
          'states': states,
          'repositories': repositories,
        },
        'dependencies': dependencies,
        'providers': providers.map((p) => p.toJson()).toList(),
        'stateClasses': stateClasses.map((s) => s.toJson()).toList(),
        'routes': routes.map((r) => r.toJson()).toList(),
        'apiEndpoints': apiEndpoints.map((e) => e.toJson()).toList(),
        'externalServices': externalServices.map((e) => e.toJson()).toList(),
        'controllerMethods': controllerMethods.map(
          (key, value) => MapEntry(key, value.map((m) => m.toJson()).toList()),
        ),
        'testing': testing.toJson(),
      };
}

// ═══════════════════════════════════════════════════════════════════════════
// CONSTANTS (template layout)
// ═══════════════════════════════════════════════════════════════════════════

const _packageName = 'riverpod_template';
final presentationDir = Directory('lib/presentation');
final dataRepositoriesDir = Directory('lib/data/repositories');
final domainDir = Directory('lib/domain');
final routerFile = File('lib/routing/router.dart');
final endpointsFile = File('lib/utils/network/endpoints.dart');

// ═══════════════════════════════════════════════════════════════════════════
// PARSING UTILITIES
// ═══════════════════════════════════════════════════════════════════════════

String readFileSafe(String filePath) {
  try {
    return File(filePath).readAsStringSync();
  } catch (e) {
    return '';
  }
}

List<String> listDartFilesRecursive(Directory dir) {
  if (!dir.existsSync()) return [];
  return dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .where((f) => !f.path.contains('.g.dart'))
      .where((f) => !f.path.contains('.freezed.dart'))
      .map((f) => f.path.replaceAll('\\', '/'))
      .toList()
    ..sort();
}

String getRelativePath(String absolutePath) {
  final libIndex = absolutePath.indexOf('lib/');
  if (libIndex == -1) return absolutePath;
  return absolutePath.substring(libIndex).replaceAll('\\', '/');
}

// ═══════════════════════════════════════════════════════════════════════════
// ROUTE PATH (template uses RoutePath in router.dart)
// ═══════════════════════════════════════════════════════════════════════════

/// Extract RoutePath constants from router.dart: static const String xxx = 'path';
Map<String, String> extractRoutePathConstants(String routerContent) {
  final constants = <String, String>{};
  final regex = RegExp(r"static\s+const\s+String\s+(\w+)\s*=\s*'([^']+)';");
  for (final m in regex.allMatches(routerContent)) {
    constants[m.group(1)!] = m.group(2)!;
  }
  return constants;
}

List<RouteDefinition> extractRoutesForFeature(
  String featureName,
  String routerContent,
  Map<String, String> routePathConstants,
  List<String> featureFiles,
) {
  final routes = <RouteDefinition>[];
  final usedRoutes = <String>{};
  final usageRegex = RegExp(r'RoutePath\.(\w+)');
  for (final filePath in featureFiles) {
    final content = readFileSafe(filePath);
    for (final m in usageRegex.allMatches(content)) {
      final name = m.group(1)!;
      if (routePathConstants.containsKey(name)) usedRoutes.add(name);
    }
  }

  List<String> routeNames = usedRoutes.isNotEmpty
      ? usedRoutes.toList()
      : _featureToRouteNames(featureName).where(routePathConstants.containsKey).toList();
  if (routeNames.isEmpty) return routes;

  for (final routeName in routeNames) {
    final pathValue = routePathConstants[routeName] ?? '/$routeName';
    // Match builder: ... => XxxView( or builder: ... return const XxxView(
    final routePattern = RegExp(
      'path:\\s*RoutePath\\.$routeName[\\s\\S]*?builder:[\\s\\S]*?(?:=>\\s*(?:const\\s+)?(\\w+View)\\s*\\(|return\\s+(?:const\\s+)?(\\w+View)\\s*\\()',
      multiLine: true,
    );
    for (final m in routePattern.allMatches(routerContent)) {
      final view = m.group(1) ?? m.group(2);
      if (view != null) routes.add(RouteDefinition(routePathConstant: routeName, pathValue: pathValue, view: view));
    }
  }
  return routes;
}

List<String> _featureToRouteNames(String featureName) {
  if (featureName == 'sign_up') return ['signUp'];
  if (featureName == 'bottom_navigation') return ['bottomNavigation'];
  return [featureName];
}

// ═══════════════════════════════════════════════════════════════════════════
// EXTRACTORS (simplified from playbook)
// ═══════════════════════════════════════════════════════════════════════════

List<RiverpodProvider> extractProviders(String content, String fileName) {
  final providers = <RiverpodProvider>[];
  final classRegex = RegExp(
    r'@(?:riverpod|Riverpod)(?:\([^)]+\))?\s*\n\s*class\s+(\w+)\s+extends\s+_\$\w+',
    multiLine: true,
  );
  for (final m in classRegex.allMatches(content)) {
    final className = m.group(1)!;
    final name = '${className[0].toLowerCase()}${className.substring(1)}Provider';
    providers.add(RiverpodProvider(name: name, type: 'Notifier', returnType: className, file: fileName));
  }
  return providers;
}

List<StateClass> extractStateClasses(String content, String fileName) {
  final states = <StateClass>[];
  final regex = RegExp(
    r'(?:@freezed\s*\n?\s*(?:abstract\s+)?class\s+(\w+State)\s+with\s+_\$\w+|(?:sealed\s+)?class\s+(\w+State)\s+extends\s+(?:Equatable|\w+State))',
    multiLine: true,
  );
  for (final m in regex.allMatches(content)) {
    final name = m.group(1) ?? m.group(2)!;
    states.add(StateClass(name: name, fields: [], file: fileName));
  }
  return states;
}

List<String> extractFeatureDependencies(String content) {
  final deps = <String>{};
  final regex = RegExp(
    'import\\s+[\'"]package:$_packageName/(?:presentation|data|domain)/(\\w+)',
  );
  for (final m in regex.allMatches(content)) {
    deps.add(m.group(1)!);
  }
  return deps.toList()..sort();
}

Map<String, List<ControllerMethod>> extractControllerMethods(String content, String fileName) {
  final result = <String, List<ControllerMethod>>{};
  final classRegex = RegExp(r'class\s+(\w+Controller)\s+extends\s+_\$');
  final match = classRegex.firstMatch(content);
  if (match == null) return result;
  final className = match.group(1)!;
  final methodRegex = RegExp(
    r'^\s*(Future<[^>]+>|FutureOr<[^>]+>|void|bool|int|String|\w+)\s+(\w+)\s*\(',
    multiLine: true,
  );
  final methods = <ControllerMethod>[];
  for (final m in methodRegex.allMatches(content)) {
    final methodName = m.group(2)!;
    if (methodName == 'build' || methodName.startsWith('_')) continue;
    methods.add(ControllerMethod(name: methodName, file: fileName, line: 0));
  }
  if (methods.isNotEmpty) result[className] = methods;
  return result;
}

List<ExternalService> extractExternalServices(String content, String fileName) {
  final services = <String, Set<String>>{};
  if (content.contains('FirebaseAuth') || content.contains('firebaseAuth')) {
    services.putIfAbsent('FirebaseAuth', () => {}).add(fileName);
  }
  if (content.contains('GoogleSignIn')) services.putIfAbsent('GoogleSignIn', () => {}).add(fileName);
  return services.entries.map((e) => ExternalService(service: e.key, usedIn: e.value.toList()..sort())).toList();
}

List<ApiEndpoint> extractApiEndpoints(String content, String fileName, String endpointsContent, List<String> allDartFiles) {
  final endpoints = <ApiEndpoint>[];
  final methodRegex = RegExp(r'Future<[^>]+>\s+(\w+)\s*\([^)]*\)\s*(?:async\s*)?(?:=>|{)', multiLine: true);
  final networkRegex = RegExp(r'networkService\.(getHttp|postHttp|putHttp|deleteHttp)\s*\(');
  for (final methodMatch in methodRegex.allMatches(content)) {
    final methodName = methodMatch.group(1)!;
    if (networkRegex.hasMatch(content.substring(methodMatch.start, methodMatch.end + 200))) {
      endpoints.add(ApiEndpoint(
        httpMethod: 'GET',
        endpoint: '/$methodName',
        repository: fileName,
        method: methodName,
        methodParameters: [],
        endpointPathParams: [],
        usedIn: [fileName],
      ));
    }
  }
  return endpoints;
}

/// Extract testing info for a feature by scanning test directories
TestingInfo extractTestsForFeature(String featureName, String featurePath) {
  final testDir = Directory('test/presentation/$featurePath');
  final testDataDir = Directory('test/test_data');

  // Find test files in test/presentation/{featurePath}/
  final testFiles = <String>[];
  if (testDir.existsSync()) {
    for (final entity in testDir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('_test.dart')) {
        testFiles.add(entity.path.replaceAll('\\', '/'));
      }
    }
  }
  testFiles.sort();

  // Find test data files that match feature name in test/test_data/
  final testDataFiles = <String>[];
  if (testDataDir.existsSync()) {
    final featurePatterns = [
      featureName.toLowerCase(),
      featureName.replaceAll('_', '').toLowerCase(),
    ];
    // For auth-related features, also check for 'auth' pattern
    if (featureName == 'login' || featureName == 'sign_up') {
      featurePatterns.add('auth');
    }

    for (final entity in testDataDir.listSync()) {
      if (entity is File && entity.path.endsWith('.dart')) {
        final fileName = entity.path.split('/').last.toLowerCase();
        for (final pattern in featurePatterns) {
          if (fileName.contains(pattern)) {
            testDataFiles.add(entity.path.replaceAll('\\', '/'));
            break;
          }
        }
      }
    }
  }
  testDataFiles.sort();

  final testDirectory = 'test/presentation/$featurePath';
  final runCommand = testFiles.isNotEmpty ? 'flutter test $testDirectory' : '';

  return TestingInfo(
    testDirectory: testDirectory,
    testFiles: testFiles,
    testDataFiles: testDataFiles,
    runCommand: runCommand,
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// GENERATE ONE MANIFEST
// ═══════════════════════════════════════════════════════════════════════════

FeatureManifest generateManifestForFeature(String featureName, String featurePath) {
  final featureDir = Directory('lib/presentation/$featurePath');
  if (!featureDir.existsSync()) throw Exception('Feature directory not found: $featureDir');

  final routerContent = readFileSafe(routerFile.path);
  final routePathConstants = extractRoutePathConstants(routerContent);
  final endpointsContent = readFileSafe(endpointsFile.path);

  final allDartFiles = listDartFilesRecursive(featureDir);

  final views = allDartFiles.where((f) => f.endsWith('_view.dart')).map(getRelativePath).toList()..sort();
  final controllers = allDartFiles.where((f) => f.endsWith('_controller.dart')).map(getRelativePath).toList()..sort();
  final widgets = allDartFiles.where((f) => f.contains('/widgets/') && !f.endsWith('_view.dart')).map(getRelativePath).toList()..sort();
  final states = allDartFiles.where((f) => f.endsWith('_state.dart')).map(getRelativePath).toList()..sort();

  final pathParts = featurePath.split('/');
  final parentGroup = pathParts.isNotEmpty ? pathParts[0] : featureName;
  final repoPattern = parentGroup == 'auth' || featureName == 'login' || featureName == 'sign_up'
      ? 'auth_repository'
      : '${featureName}_repository';
  final repoDir = Directory('lib/data/repositories/$repoPattern');
  final repositoryFiles = repoDir.existsSync()
      ? listDartFilesRecursive(repoDir).where((f) => f.contains('repository') && !f.contains('.g.dart')).toList()
      : <String>[];
  final repositories = repositoryFiles.map(getRelativePath).toList()..sort();

  final allProviders = <RiverpodProvider>[];
  final allStateClasses = <StateClass>[];
  final allApiEndpoints = <ApiEndpoint>[];
  final externalServicesMap = <String, Set<String>>{};
  final allDependencies = <String>{};
  final allControllerMethods = <String, List<ControllerMethod>>{};

  for (final filePath in allDartFiles) {
    final content = readFileSafe(filePath);
    if (content.isEmpty) continue;
    final rel = getRelativePath(filePath);
    allProviders.addAll(extractProviders(content, rel));
    allStateClasses.addAll(extractStateClasses(content, rel));
    for (final e in extractExternalServices(content, rel)) {
      externalServicesMap.putIfAbsent(e.service, () => {}).addAll(e.usedIn);
    }
    allDependencies.addAll(extractFeatureDependencies(content));
    final cm = extractControllerMethods(content, rel);
    for (final entry in cm.entries) {
      allControllerMethods[entry.key] = entry.value;
    }
  }

  for (final filePath in repositoryFiles) {
    final content = readFileSafe(filePath);
    if (content.isEmpty) continue;
    allApiEndpoints.addAll(extractApiEndpoints(content, getRelativePath(filePath), endpointsContent, allDartFiles));
  }

  final routes = extractRoutesForFeature(featureName, routerContent, routePathConstants, allDartFiles);
  final routesDedup = routes.fold<Map<String, RouteDefinition>>({}, (map, r) {
    map[r.routePathConstant] = r;
    return map;
  }).values.toList()..sort((a, b) => a.routePathConstant.compareTo(b.routePathConstant));

  final externalServices = externalServicesMap.entries
      .map((e) => ExternalService(service: e.key, usedIn: e.value.toList()..sort()))
      .toList()
    ..sort((a, b) => a.service.compareTo(b.service));

  final uniqueProviders = <String, RiverpodProvider>{};
  for (final p in allProviders) uniqueProviders[p.name] = p;
  final uniqueStateClasses = <String, StateClass>{};
  for (final s in allStateClasses) uniqueStateClasses[s.name] = s;

  // Extract testing info
  final testing = extractTestsForFeature(featureName, featurePath);

  return FeatureManifest(
    generatedAt: DateTime.now().toUtc().toIso8601String(),
    feature: featureName,
    views: views,
    controllers: controllers,
    widgets: widgets,
    models: [],
    services: [],
    states: states,
    repositories: repositories,
    dependencies: allDependencies.toList()..sort(),
    providers: uniqueProviders.values.toList()..sort((a, b) => a.name.compareTo(b.name)),
    stateClasses: uniqueStateClasses.values.toList()..sort((a, b) => a.name.compareTo(b.name)),
    routes: routesDedup,
    apiEndpoints: allApiEndpoints..sort((a, b) => a.endpoint.compareTo(b.endpoint)),
    externalServices: externalServices,
    controllerMethods: allControllerMethods,
    testing: testing,
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// GENERATE ALL (template features)
// ═══════════════════════════════════════════════════════════════════════════

void generateAllManifests() {
  print('Generating feature manifests...\n');

  final outputDir = Directory('lib/manifests');
  if (!outputDir.existsSync()) outputDir.createSync(recursive: true);

  int count = 0;
  final features = [
    ('splash', 'splash'),
    ('onboarding', 'onboarding'),
    ('login', 'login'),
    ('sign_up', 'sign_up'),
    ('bottom_navigation', 'bottom_navigation'),
    ('home', 'home'),
  ];

  for (final entry in features) {
    final (name, path) = (entry.$1, entry.$2);
    final featureDir = Directory('lib/presentation/$path');
    if (!featureDir.existsSync()) {
      print('  ⚠️  Skip $name (no lib/presentation/$path)');
      continue;
    }
    try {
      final manifest = generateManifestForFeature(name, path);
      final outPath = '${outputDir.path}/$name.manifest.generated.json';
      File(outPath).writeAsStringSync('${const JsonEncoder.withIndent('  ').convert(manifest.toJson())}\n');
      print('  ✅ $name.manifest.generated.json');
      count++;
    } catch (e) {
      print('  ⚠️  Error $name: $e');
    }
  }

  print('\n✨ Done! Generated $count manifests in lib/manifests/');
}

void main() {
  generateAllManifests();
}
