// ignore_for_file: avoid_print

/// Feature Manifest Generator (Riverpod Template)
///
/// Scans lib/presentation/ and generates {feature}.manifest.generated.json per feature.
/// Uses AppRoute from lib/core/routing/app_route.dart.
///
/// Usage: dart run scripts/generate_feature_manifests.dart
library;

import 'dart:convert';
import 'dart:io';

// ═══════════════════════════════════════════════════════════════════════════
// TYPES
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
  final List<String> fields; // Format: "Type? fieldName" or "Type fieldName"
  final String file;

  StateClass({required this.name, required this.fields, required this.file});

  Map<String, dynamic> toJson() => {'name': name, 'fields': fields, 'file': file};
}

class RouteDefinition {
  final String appRouteConstant; // AppRoute constant name
  final String? view;

  RouteDefinition({required this.appRouteConstant, this.view});

  String get path => '/$appRouteConstant';
  String get appRoute => 'AppRoute.$appRouteConstant';

  Map<String, dynamic> toJson() => {
        'appRoute': appRoute,
        'path': path,
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

class CoreService {
  final String name;
  final String path;
  final List<String> usedIn;

  CoreService({required this.name, required this.path, required this.usedIn});

  Map<String, dynamic> toJson() => {
        'name': name,
        'path': path,
        'usedIn': usedIn,
      };
}

class ThirdPartyDependency {
  final String package;
  final List<String> usedIn;

  ThirdPartyDependency({required this.package, required this.usedIn});

  Map<String, dynamic> toJson() => {
        'package': package,
        'usedIn': usedIn,
      };
}

class MethodParameter {
  final String name;
  final String type;
  final bool isRequired;
  final String? defaultValue;

  MethodParameter({
    required this.name,
    required this.type,
    this.isRequired = false,
    this.defaultValue,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'isRequired': isRequired,
        if (defaultValue != null) 'defaultValue': defaultValue,
      };
}

class ControllerMethod {
  final String name;
  final String? returnType;
  final String? params; // Kept for backward compatibility
  final List<MethodParameter>? parameters;
  final String file;
  final int line;

  ControllerMethod({
    required this.name,
    this.returnType,
    this.params,
    this.parameters,
    required this.file,
    required this.line,
  });

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
  final String? testDirectory; // Nullable if no tests exist
  final List<String> testFiles;
  final List<String> testDataFiles;
  final String runCommand;

  TestingInfo({
    this.testDirectory,
    required this.testFiles,
    required this.testDataFiles,
    required this.runCommand,
  });

  Map<String, dynamic> toJson() => {
        if (testDirectory != null) 'testDirectory': testDirectory,
        'testFiles': testFiles,
        'testDataFiles': testDataFiles,
        'runCommand': runCommand,
        'hasTests': testFiles.isNotEmpty,
      };
}

class FeatureManifest {
  final String generatedAt;
  final String feature;
  final List<String> views;
  final List<String> controllers;
  final List<String> widgets;
  final List<String> models;
  final List<String> repositories;
  final List<RiverpodProvider> providers;
  final List<StateClass> stateClasses;
  final List<RouteDefinition> routes;
  final List<ApiEndpoint> apiEndpoints;
  final List<CoreService> coreServices;
  final List<ThirdPartyDependency> thirdPartyDependencies;
  final Map<String, List<ControllerMethod>> controllerMethods;
  final TestingInfo testing;

  FeatureManifest({
    required this.generatedAt,
    required this.feature,
    required this.views,
    required this.controllers,
    required this.widgets,
    required this.models,
    required this.repositories,
    required this.providers,
    required this.stateClasses,
    required this.routes,
    required this.apiEndpoints,
    required this.coreServices,
    required this.thirdPartyDependencies,
    required this.controllerMethods,
    required this.testing,
  });

  Map<String, dynamic> toJson() => {
        'generatedAt': generatedAt,
        'feature': feature,
        'views': views,
        'controllers': controllers,
        'widgets': widgets,
        'models': models,
        'repositories': repositories,
        'providers': providers.map((p) => p.toJson()).toList(),
        'stateClasses': stateClasses.map((s) => s.toJson()).toList(),
        'routes': routes.map((r) => r.toJson()).toList(),
        'apiEndpoints': apiEndpoints.map((e) => e.toJson()).toList(),
        'coreServices': coreServices.map((s) => s.toJson()).toList(),
        'thirdPartyDependencies': thirdPartyDependencies.map((d) => d.toJson()).toList(),
        'controllerMethods': controllerMethods.map(
          (key, value) => MapEntry(key, value.map((m) => m.toJson()).toList()),
        ),
        'testing': testing.toJson(),
      };
}

// ═══════════════════════════════════════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════

const _packageName = 'riverpod_template';
final presentationDir = Directory('lib/presentation');
final dataRepositoriesDir = Directory('lib/data/repositories');
final modelsDir = Directory('lib/models');
final testDir = Directory('test');
final testDataDir = Directory('test/test_data');
final routerFile = File('lib/core/routing/router.dart');
final appRouteFile = File('lib/core/routing/app_route.dart');
final endpointsFile = File('lib/core/utils/network/endpoints.dart');

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
// EXTRACTORS
// ═══════════════════════════════════════════════════════════════════════════

List<RiverpodProvider> extractProviders(String content, String fileName) {
  final providers = <RiverpodProvider>[];

  // Pattern 1: @riverpod or @Riverpod annotation followed by class
  final classProviderRegex = RegExp(
    r'@(?:riverpod|Riverpod)(?:\([^)]+\))?\s*\n\s*class\s+(\w+)\s+extends\s+_\$\w+',
    multiLine: true,
  );
  for (final match in classProviderRegex.allMatches(content)) {
    final className = match.group(1)!;
    providers.add(
      RiverpodProvider(
        name: _toProviderName(className),
        type: 'Notifier',
        returnType: className,
        file: fileName,
      ),
    );
  }

  // Pattern 2: @riverpod annotation followed by function
  final funcProviderRegex = RegExp(
    r'@riverpod\s*\n\s*(\w+(?:<[^>]+>)?)\s+(\w+)\s*\(',
    multiLine: true,
  );
  for (final match in funcProviderRegex.allMatches(content)) {
    final returnType = match.group(1)!;
    final funcName = match.group(2)!;
    if (returnType == 'class') continue;
    providers.add(
      RiverpodProvider(
        name: _toProviderName(funcName),
        type: 'Provider',
        returnType: returnType,
        file: fileName,
      ),
    );
  }

  return providers;
}

String _toProviderName(String name) {
  final lowerFirst = name[0].toLowerCase() + name.substring(1);
  return '${lowerFirst}Provider';
}

List<StateClass> extractStateClasses(String content, String fileName) {
  final states = <StateClass>[];

  // Skip widget files - they don't contain state management state classes
  final isWidgetFile = RegExp(
    r'extends\s+(?:StatelessWidget|StatefulWidget|ConsumerWidget|ConsumerStatefulWidget|HookWidget|HookConsumerWidget)',
  ).hasMatch(content);

  if (isWidgetFile) return states;

  // Pattern 1: @freezed class XxxState with _$XxxState
  final freezedRegex = RegExp(
    r'@freezed\s*\n?\s*(?:abstract\s+)?class\s+(\w+State)\s+with\s+_\$\w+\s*\{',
    multiLine: true,
  );

  for (final match in freezedRegex.allMatches(content)) {
    final className = match.group(1)!;
    final fields = _extractFreezedFields(content, className);
    states.add(StateClass(name: className, fields: fields, file: fileName));
  }

  // Pattern 2: Equatable-based state classes
  final equatableRegex = RegExp(
    r'(?:sealed\s+)?class\s+(\w+State)\s+extends\s+(?:Equatable|\w+State)',
    multiLine: true,
  );

  for (final match in equatableRegex.allMatches(content)) {
    final className = match.group(1)!;
    final fields = _extractEquatableFields(content);
    if (fields.isNotEmpty) {
      states.add(StateClass(name: className, fields: fields, file: fileName));
    }
  }

  return states;
}

List<String> _extractFreezedFields(String content, String className) {
  final fields = <String>[];
  final factoryRegex = RegExp(
    r'const\s+factory\s+' + className + r'\s*\(\s*\{([^}]+)\}\s*\)',
    multiLine: true,
  );
  final factoryMatch = factoryRegex.firstMatch(content);

  if (factoryMatch != null) {
    final factoryBody = factoryMatch.group(1) ?? '';
    final fieldRegex = RegExp(
      r'(required\s+)?([A-Za-z_][A-Za-z0-9_<>?,\s]+?)\s+([A-Za-z_][A-Za-z0-9_]*)(?:\s*=\s*([^,]+))?',
    );
    for (final fieldMatch in fieldRegex.allMatches(factoryBody)) {
      final typeStr = fieldMatch.group(2)?.trim() ?? '';
      final fieldName = fieldMatch.group(3)?.trim() ?? '';

      if (fieldName.isEmpty || fieldName.startsWith('_') || fieldName == 'factory') continue;

      final isNullable = typeStr.endsWith('?');
      final cleanType = isNullable ? typeStr.substring(0, typeStr.length - 1).trim() : typeStr;
      fields.add('$cleanType${isNullable ? '?' : ''} $fieldName');
    }
  }

  return fields;
}

List<String> _extractEquatableFields(String content) {
  final fields = <String>[];
  final fieldDeclRegex = RegExp(
    r'final\s+([A-Za-z_][A-Za-z0-9_<>?,\s\\.]+?)\s+([A-Za-z_][A-Za-z0-9_]*)\s*;',
    multiLine: true,
  );

  for (final fieldDeclMatch in fieldDeclRegex.allMatches(content)) {
    final typeStr = fieldDeclMatch.group(1)?.trim() ?? '';
    final fieldName = fieldDeclMatch.group(2)?.trim() ?? '';

    if (fieldName.isEmpty || fieldName == 'props' || fieldName == 'copyWith') continue;

    final isNullable = typeStr.trim().endsWith('?');
    final cleanType =
        isNullable ? typeStr.trim().substring(0, typeStr.trim().length - 1).trim() : typeStr.trim();
    final normalizedType = cleanType.replaceAll(RegExp(r'\s+'), ' ');
    fields.add('$normalizedType${isNullable ? '?' : ''} $fieldName');
  }

  return fields;
}

/// Extract AppRoute constants from app_route.dart
Map<String, String> extractAppRouteConstants(String appRouteContent) {
  final constants = <String, String>{};
  final constantRegex = RegExp("static\\s+const\\s+String\\s+(\\w+)\\s*=\\s*['\"]([^'\"]+)['\"];");

  for (final match in constantRegex.allMatches(appRouteContent)) {
    final constantName = match.group(1)!;
    final constantValue = match.group(2)!;
    constants[constantName] = constantValue;
  }

  return constants;
}

List<RouteDefinition> extractRoutesForFeature(
  String featureName,
  String routerContent,
  String appRouteContent,
  List<String> featureFiles,
) {
  final routes = <RouteDefinition>[];
  final appRouteConstants = extractAppRouteConstants(appRouteContent);

  // Zero-drift route discovery: scan feature files for actual AppRoute usage
  final usedRoutes = <String>{};
  final appRouteUsagePattern = RegExp(r'AppRoute\.(\w+)');

  for (final filePath in featureFiles) {
    final content = readFileSafe(filePath);
    for (final match in appRouteUsagePattern.allMatches(content)) {
      final routeName = match.group(1)!;
      if (appRouteConstants.containsKey(routeName)) {
        usedRoutes.add(routeName);
      }
    }
  }

  // Also include the feature's entry route by name
  final entryRouteName = _featureNameToRouteConstant(featureName);
  if (entryRouteName != null &&
      appRouteConstants.containsKey(entryRouteName) &&
      !usedRoutes.contains(entryRouteName)) {
    usedRoutes.add(entryRouteName);
  }

  if (usedRoutes.isEmpty) return routes;

  for (final routeConstantName in usedRoutes) {
    if (!appRouteConstants.containsKey(routeConstantName)) continue;

    // Find the view associated with this route in router.dart
    final blockPattern =
        "(?:name|path):\\s*AppRoute\\.$routeConstantName[\\s\\S]*?(?:builder:|pageBuilder:)";
    final blockRegex = RegExp(blockPattern, multiLine: true);
    final blockMatch = blockRegex.firstMatch(routerContent);
    if (blockMatch == null) continue;

    final blockEnd = blockMatch.end;
    const maxBlockLength = 800;
    final restOfRouter = routerContent.length - blockEnd > maxBlockLength
        ? routerContent.substring(blockEnd, blockEnd + maxBlockLength)
        : routerContent.substring(blockEnd);

    // Try builder: ... => (const)? XxxView(
    final builderViewRegex = RegExp(
      r'=>\s*(?:const\s+)?(\w+View)\s*\(',
      multiLine: true,
      dotAll: true,
    );
    final builderMatch = builderViewRegex.firstMatch(restOfRouter);

    // Try child: (const)? XxxView(
    final childViewRegex = RegExp(
      r'child:\s*(?:const\s+)?(\w+View)\s*\(',
      multiLine: true,
      dotAll: true,
    );
    final childMatch = childViewRegex.firstMatch(restOfRouter);

    final view = (builderMatch != null && childMatch != null)
        ? (builderMatch.start <= childMatch.start ? builderMatch.group(1) : childMatch.group(1))
        : (builderMatch?.group(1) ?? childMatch?.group(1));

    if (view != null) {
      routes.add(RouteDefinition(appRouteConstant: routeConstantName, view: view));
    }
  }

  return routes;
}

String? _featureNameToRouteConstant(String featureName) {
  if (featureName.contains('_')) {
    final camelCase = featureName.split('_').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join();
    return camelCase[0].toLowerCase() + camelCase.substring(1);
  }
  return featureName;
}

/// Extract third-party package dependencies from imports
Set<String> extractThirdPartyDependencies(String content) {
  final packages = <String>{};
  final importRegex = RegExp(r'''import\s+['"]package:([^/'"]+)/''');

  const excludedPackages = <String>{
    'flutter',
    'dart',
    _packageName,
    'flutter_test',
    'flutter_driver',
    'integration_test',
    'build_runner',
    'freezed_annotation',
    'json_annotation',
    'riverpod_annotation',
  };

  for (final match in importRegex.allMatches(content)) {
    final packageName = match.group(1)!;
    if (!excludedPackages.contains(packageName)) {
      packages.add(packageName);
    }
  }

  return packages;
}

/// Extract core services (from lib/core/services/) used in a file
Map<String, Set<String>> extractCoreServices(String content, String fileName) {
  final services = <String, Set<String>>{};
  final importRegex = RegExp(
    '''import\\s+['"]package:$_packageName/core/services/([^/]+)/''',
  );

  for (final match in importRegex.allMatches(content)) {
    final serviceName = match.group(1)!;
    services.putIfAbsent(serviceName, () => <String>{});
    services[serviceName]!.add(fileName);
  }

  return services;
}

/// Extract models (from lib/models/) used in a file
Set<String> extractModels(String content) {
  final models = <String>{};
  final importRegex = RegExp(
    '''import\\s+['"]package:$_packageName/models/([^/]+)/''',
  );

  for (final match in importRegex.allMatches(content)) {
    final modelName = match.group(1)!;
    models.add('lib/models/$modelName');
  }

  return models;
}

List<ControllerMethod> extractControllerMethods(String content, String fileName) {
  final methods = <ControllerMethod>[];
  final lines = content.split('\n');

  final classRegex = RegExp(r'class\s+(\w+Controller)\s+extends\s+_\$');
  if (!classRegex.hasMatch(content)) return methods;

  int braceDepth = 0;
  bool inClass = false;

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    final trimmed = line.trim();

    if (classRegex.hasMatch(line)) {
      inClass = true;
      braceDepth = 0;
    }

    if (inClass) {
      braceDepth += '{'.allMatches(line).length;
      braceDepth -= '}'.allMatches(line).length;

      if (braceDepth <= 0 && inClass && line.contains('}')) {
        inClass = false;
        continue;
      }

      final methodStartRegex = RegExp(
        r'^\s*(Future<[^>]+>|FutureOr<[^>]+>|void|bool|int|String|List<[^>]+>|Map<[^>]+>|\w+)\s+(\w+)\s*\(',
      );

      final match = methodStartRegex.firstMatch(trimmed);
      if (match != null) {
        final returnType = match.group(1);
        final methodName = match.group(2)!;

        if (methodName == 'build' || methodName == 'constructor' || methodName.startsWith('_')) {
          continue;
        }

        // Collect full parameter string across multiple lines
        String fullSignature = trimmed;
        int parenDepth = '('.allMatches(trimmed).length - ')'.allMatches(trimmed).length;
        int sigEndLine = i;

        while (parenDepth > 0 && sigEndLine < lines.length - 1) {
          sigEndLine++;
          final nextLine = lines[sigEndLine].trim();
          fullSignature += ' $nextLine';
          parenDepth += '('.allMatches(nextLine).length;
          parenDepth -= ')'.allMatches(nextLine).length;
        }

        if (!RegExp(r'\)\s*(async\s*)?[{=]').hasMatch(fullSignature)) continue;

        // Extract params from full signature
        final paramsMatch = RegExp(r'\(([^)]*)\)').firstMatch(fullSignature);
        var paramsStr = paramsMatch?.group(1)?.trim() ?? '';
        paramsStr = paramsStr.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');
        paramsStr = paramsStr.replaceAll(RegExp(r'//[^\n,]*'), '');
        paramsStr = paramsStr.trim();

        final parameters = _parseMethodParameters(paramsStr);

        methods.add(
          ControllerMethod(
            name: methodName,
            returnType: returnType,
            params: paramsStr.isEmpty ? null : '($paramsStr)',
            parameters: parameters.isNotEmpty ? parameters : null,
            file: fileName,
            line: i + 1,
          ),
        );
      }
    }
  }

  return methods;
}

List<MethodParameter> _parseMethodParameters(String paramsStr) {
  final params = <MethodParameter>[];
  if (paramsStr.isEmpty) return params;

  final isNamedParams = paramsStr.startsWith('{') && paramsStr.endsWith('}');
  final paramsContent =
      isNamedParams ? paramsStr.substring(1, paramsStr.length - 1).trim() : paramsStr;

  if (paramsContent.isEmpty) return params;

  // Split by comma, respecting generics
  final paramParts = <String>[];
  int depth = 0;
  String currentParam = '';

  for (int j = 0; j < paramsContent.length; j++) {
    final char = paramsContent[j];
    if (char == '<' || char == '(' || char == '{') {
      depth++;
      currentParam += char;
    } else if (char == '>' || char == ')' || char == '}') {
      depth--;
      currentParam += char;
    } else if (char == ',' && depth == 0) {
      if (currentParam.trim().isNotEmpty) paramParts.add(currentParam.trim());
      currentParam = '';
    } else {
      currentParam += char;
    }
  }
  if (currentParam.trim().isNotEmpty) paramParts.add(currentParam.trim());

  for (final paramStr in paramParts) {
    final trimmedParam = paramStr.trim();
    if (trimmedParam.isEmpty) continue;

    final requiredMatch = RegExp(r'^(required\s+)').firstMatch(trimmedParam);
    final isRequired = requiredMatch != null || !isNamedParams;

    final paramWithoutRequired =
        requiredMatch != null ? trimmedParam.substring(requiredMatch.group(0)!.length).trim() : trimmedParam;

    // Extract type and name
    final typeNameMatch = RegExp(r'^([A-Za-z_][A-Za-z0-9_<>?,\s]*?)\s+([A-Za-z_][A-Za-z0-9_]*)').firstMatch(paramWithoutRequired);
    if (typeNameMatch == null) continue;

    final typeStr = typeNameMatch.group(1)!.trim();
    final paramName = typeNameMatch.group(2)!.trim();

    final defaultValueMatch = RegExp(r'=\s*([^,]+)').firstMatch(paramWithoutRequired);
    final defaultValue = defaultValueMatch?.group(1)?.trim();

    final isNullable = typeStr.endsWith('?');
    final cleanType = isNullable ? typeStr.substring(0, typeStr.length - 1).trim() : typeStr;

    params.add(
      MethodParameter(
        name: paramName,
        type: cleanType,
        isRequired: isRequired,
        defaultValue: defaultValue,
      ),
    );
  }

  return params;
}

List<ApiEndpoint> extractApiEndpoints(
  String content,
  String fileName,
  String endpointsContent,
  List<String> allDartFiles,
) {
  final endpoints = <ApiEndpoint>[];

  final methodRegex = RegExp(
    r'(?:@override\s+)?Future(?:<[^>]+>)?\s+(\w+)\s*\([^)]*\)\s*(?:async\s*)?(?:=>|{)',
    multiLine: true,
    dotAll: true,
  );

  final networkServiceStartRegex = RegExp(
    r'networkService\.(getHttp|postHttp|putHttp|deleteHttp)\s*\(',
    multiLine: true,
    dotAll: true,
  );

  for (final methodMatch in methodRegex.allMatches(content)) {
    final methodName = methodMatch.group(1)!;
    final methodStart = methodMatch.start;

    int methodEnd = content.length;
    final nextMethodMatch = methodRegex.firstMatch(content.substring(methodMatch.end));
    if (nextMethodMatch != null) {
      methodEnd = methodMatch.end + nextMethodMatch.start;
    }

    final methodBody = content.substring(methodStart, methodEnd);

    for (final networkMatch in networkServiceStartRegex.allMatches(methodBody)) {
      final httpMethodName = networkMatch.group(1)!;
      final httpMethod = httpMethodName.replaceAll('Http', '').toUpperCase();

      // Extract endpoint
      final endpointMatch = RegExp(
        r'''endpoint:\s*(Endpoints\.\w+(?:\([^)]*\))?|['"]([^'"]+)['"])''',
        multiLine: true,
        dotAll: true,
      ).firstMatch(methodBody);

      String? endpoint;
      if (endpointMatch != null) {
        final endpointRef = endpointMatch.group(1) ?? endpointMatch.group(2);
        endpoint = endpointRef;
      }

      if (endpoint == null) continue;

      endpoints.add(
        ApiEndpoint(
          httpMethod: httpMethod,
          endpoint: endpoint,
          repository: fileName,
          method: methodName,
          methodParameters: [],
          endpointPathParams: [],
          usedIn: [fileName],
        ),
      );
    }
  }

  return endpoints;
}

/// Extracts test information for a feature
TestingInfo extractTestsForFeature(String featureName, String featurePath) {
  final testDirPath = 'test/presentation/$featurePath';
  final featureTestDir = Directory(testDirPath);

  final testFiles = <String>[];
  String? testDirectory;

  if (featureTestDir.existsSync()) {
    testDirectory = testDirPath;
    testFiles.addAll(
      listDartFilesRecursive(featureTestDir)
          .where((f) => f.endsWith('_test.dart'))
          .map((f) => f.startsWith('test/') ? f : 'test/${f.split('test/').last}')
          .toList()
        ..sort(),
    );
  }

  // Find test data files related to this feature
  final testDataFiles = <String>[];
  if (testDataDir.existsSync()) {
    final featurePatterns = [
      featureName,
      featureName.replaceAll('_', ''),
    ];

    for (final file in listDartFilesRecursive(testDataDir)) {
      final fileName = file.split('/').last.toLowerCase();
      for (final pattern in featurePatterns) {
        if (fileName.contains(pattern)) {
          testDataFiles.add(file.startsWith('test/') ? file : 'test/${file.split('test/').last}');
          break;
        }
      }
    }
    testDataFiles.sort();
  }

  final runCommand =
      testFiles.isNotEmpty ? 'fvm flutter test $testDirPath/' : 'fvm flutter test test/presentation/$featurePath/';

  return TestingInfo(
    testDirectory: testDirectory,
    testFiles: testFiles,
    testDataFiles: testDataFiles,
    runCommand: runCommand,
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// MAIN GENERATION LOGIC
// ═══════════════════════════════════════════════════════════════════════════

FeatureManifest generateManifestForFeature(String featureName, String featurePath) {
  final featureDir = Directory('lib/presentation/$featurePath');

  if (!featureDir.existsSync()) {
    throw Exception('Feature directory not found: $featureDir');
  }

  final routerContent = readFileSafe(routerFile.path);
  final appRouteContent = readFileSafe(appRouteFile.path);
  final endpointsContent = readFileSafe(endpointsFile.path);

  final allDartFiles = listDartFilesRecursive(featureDir);

  // Extract file lists
  final views =
      allDartFiles.where((f) => f.endsWith('_view.dart')).map((f) => getRelativePath(f)).toList()..sort();

  final controllers =
      allDartFiles.where((f) => f.endsWith('_controller.dart')).map((f) => getRelativePath(f)).toList()
        ..sort();

  final widgets =
      allDartFiles
          .where((f) => f.contains('/widgets/') && !f.endsWith('_view.dart'))
          .map((f) => getRelativePath(f))
          .toList()
        ..sort();

  // Find repositories
  final pathParts = featurePath.split('/');
  final parentGroup = pathParts.isNotEmpty ? pathParts[0] : featureName;

  String repositoryPattern;
  if (parentGroup == 'auth' || featureName == 'login' || featureName == 'sign_up') {
    repositoryPattern = 'auth_repository';
  } else {
    repositoryPattern = '${featureName}_repository';
    final altRepositoryDir = Directory('lib/data/repositories/$repositoryPattern');
    if (!altRepositoryDir.existsSync()) {
      repositoryPattern = '${parentGroup}_repository';
    }
  }

  final repositoryDir = Directory('lib/data/repositories/$repositoryPattern');
  final repositoryFiles = repositoryDir.existsSync()
      ? listDartFilesRecursive(repositoryDir)
          .where((f) =>
              f.contains('repository') &&
              !f.contains('_providers') &&
              !f.contains('_interface'))
          .toList()
      : <String>[];
  final repositories = repositoryFiles.map((f) => getRelativePath(f)).toList()..sort();

  // Aggregate enhanced data
  final allProviders = <RiverpodProvider>[];
  final allStateClasses = <StateClass>[];
  final allApiEndpoints = <ApiEndpoint>[];
  final coreServicesMap = <String, Set<String>>{};
  final thirdPartyMap = <String, Set<String>>{};
  final allModels = <String>{};
  final allControllerMethods = <String, List<ControllerMethod>>{};

  // Scan all presentation dart files
  for (final filePath in allDartFiles) {
    final content = readFileSafe(filePath);
    if (content.isEmpty) continue;

    final relativeName = getRelativePath(filePath);

    allProviders.addAll(extractProviders(content, relativeName));
    allStateClasses.addAll(extractStateClasses(content, relativeName));

    // Extract third-party package dependencies
    final packages = extractThirdPartyDependencies(content);
    for (final pkg in packages) {
      thirdPartyMap.putIfAbsent(pkg, () => <String>{});
      thirdPartyMap[pkg]!.add(relativeName);
    }

    // Extract core services
    final coreServices = extractCoreServices(content, relativeName);
    for (final entry in coreServices.entries) {
      coreServicesMap.putIfAbsent(entry.key, () => <String>{});
      coreServicesMap[entry.key]!.addAll(entry.value);
    }

    // Extract models used by this feature
    allModels.addAll(extractModels(content));

    if (relativeName.contains('controller')) {
      final methods = extractControllerMethods(content, relativeName);
      if (methods.isNotEmpty) {
        final controllerName = relativeName
            .split('/')
            .last
            .replaceAll('.dart', '')
            .split('_')
            .map((w) => w[0].toUpperCase() + w.substring(1))
            .join();
        allControllerMethods[controllerName] = methods;
      }
    }
  }

  // Scan repository files for API endpoints
  for (final filePath in repositoryFiles) {
    final content = readFileSafe(filePath);
    if (content.isEmpty) continue;

    final relativeName = getRelativePath(filePath);
    allApiEndpoints.addAll(
      extractApiEndpoints(content, relativeName, endpointsContent, allDartFiles),
    );
  }

  // Extract routes
  final allRoutes = extractRoutesForFeature(featureName, routerContent, appRouteContent, allDartFiles);

  // Deduplicate routes
  final routes =
      allRoutes
          .fold<Map<String, RouteDefinition>>({}, (map, route) {
            map[route.appRouteConstant] = route;
            return map;
          })
          .values
          .toList()
        ..sort((a, b) => a.appRouteConstant.compareTo(b.appRouteConstant));

  // Convert core services map to list
  final coreServicesList = coreServicesMap.entries
      .map((e) => CoreService(
            name: e.key,
            path: 'lib/core/services/${e.key}',
            usedIn: e.value.toList()..sort(),
          ))
      .toList()
    ..sort((a, b) => a.name.compareTo(b.name));

  // Convert third-party dependencies map to list
  final thirdPartyList = thirdPartyMap.entries
      .map((e) => ThirdPartyDependency(
            package: e.key,
            usedIn: e.value.toList()..sort(),
          ))
      .toList()
    ..sort((a, b) => a.package.compareTo(b.package));

  // Deduplicate
  final uniqueProviders = <String, RiverpodProvider>{};
  for (final p in allProviders) {
    uniqueProviders[p.name] = p;
  }

  final uniqueStateClasses = <String, StateClass>{};
  for (final s in allStateClasses) {
    uniqueStateClasses[s.name] = s;
  }

  // Extract testing information
  final testing = extractTestsForFeature(featureName, featurePath);

  return FeatureManifest(
    generatedAt: DateTime.now().toUtc().toIso8601String(),
    feature: featureName,
    views: views,
    controllers: controllers,
    widgets: widgets,
    models: allModels.toList()..sort(),
    repositories: repositories,
    providers: uniqueProviders.values.toList()..sort((a, b) => a.name.compareTo(b.name)),
    stateClasses: uniqueStateClasses.values.toList()..sort((a, b) => a.name.compareTo(b.name)),
    routes: routes,
    apiEndpoints: allApiEndpoints..sort((a, b) => a.endpoint.compareTo(b.endpoint)),
    coreServices: coreServicesList,
    thirdPartyDependencies: thirdPartyList,
    controllerMethods: allControllerMethods,
    testing: testing,
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// GENERATE ALL
// ═══════════════════════════════════════════════════════════════════════════

void generateAllManifests() {
  print('Generating feature manifests...\n');

  final outputDir = Directory('lib/manifests');
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  int generatedCount = 0;

  // Template features
  final features = [
    ('splash', 'splash'),
    ('onboarding', 'onboarding'),
    ('login', 'login'),
    ('sign_up', 'sign_up'),
    ('bottom_navigation', 'bottom_navigation'),
    ('home', 'home'),
  ];

  for (final entry in features) {
    final (name, path) = entry;
    final featureDir = Directory('lib/presentation/$path');
    if (!featureDir.existsSync()) {
      print('  ⚠️  Skip $name (no lib/presentation/$path)');
      continue;
    }
    try {
      final manifest = generateManifestForFeature(name, path);
      final outputPath = '${outputDir.path}/$name.manifest.generated.json';
      final encoder = JsonEncoder.withIndent('  ');
      File(outputPath).writeAsStringSync('${encoder.convert(manifest.toJson())}\n');
      print('  ✅ $name.manifest.generated.json');
      generatedCount++;
    } catch (e) {
      print('  ⚠️  Error $name: $e');
    }
  }

  print('\n✨ Done! Generated $generatedCount manifests in lib/manifests/');
}

// ═══════════════════════════════════════════════════════════════════════════
// CLI
// ═══════════════════════════════════════════════════════════════════════════

void main() {
  generateAllManifests();
}
