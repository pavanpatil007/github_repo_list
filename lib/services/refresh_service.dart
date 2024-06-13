import 'dart:isolate';

import 'package:github_assignment/repositories/database_service.dart';
import 'package:github_assignment/services/api_service.dart';


class RefreshService {
  static void refreshData(ApiService apiService, DatabaseService databaseService) async {
    final responsePort = ReceivePort();
    await Isolate.spawn(_refreshData, responsePort.sendPort);
    responsePort.listen((message) {
      if (message == 'completed') {
        print('Data refresh completed');
      }
    });
  }

  static void _refreshData(SendPort sendPort) async {
    final apiService = ApiService();
    final databaseService = DatabaseService();

    try {
      final repositories = await apiService.fetchRepositories();
      await databaseService.insertRepositories(repositories);
      sendPort.send('completed');
    } catch (e) {
      sendPort.send('error');
    }
  }
}
