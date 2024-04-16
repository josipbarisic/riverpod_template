import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_template/services/network_service/network_service.dart';

part 'network_service_providers.g.dart';

@Riverpod(keepAlive: true)
NetworkService networkService(NetworkServiceRef ref) => NetworkService();
