import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/repository_bloc.dart';
import 'bloc/repository_event.dart';
import 'repositories/database_service.dart';
import 'screens/repository_list_screen.dart';
import 'services/api_service.dart';


void main() {
  final apiService = ApiService();
  final databaseService = DatabaseService();
  runApp(MyApp(apiService: apiService, databaseService: databaseService));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;
  final DatabaseService databaseService;

  const MyApp({super.key, required this.apiService, required this.databaseService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Repositories',
      home: BlocProvider(
        create: (context) => RepositoryBloc(apiService: apiService, databaseService: databaseService)..add(FetchRepositories()),
        child: const RepositoryListScreen(),
      ),
    );
  }
}
