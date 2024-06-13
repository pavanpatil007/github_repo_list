import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/database_service.dart';
import '../services/api_service.dart';
import 'repository_event.dart';
import 'repository_state.dart';

class RepositoryBloc extends Bloc<RepositoryEvent, RepositoryState> {
  final ApiService apiService;
  final DatabaseService databaseService;

  RepositoryBloc({required this.apiService, required this.databaseService}) : super(RepositoryInitial()) {
    on<FetchRepositories>(_onFetchRepositories);
    on<RefreshRepositories>(_onRefreshRepositories);
  }

  Future<void> _onFetchRepositories(FetchRepositories event, Emitter<RepositoryState> emit) async {
    print("Fetching repositories from database...");
    emit(RepositoryLoadInProgress());
    try {
      final repositories = await databaseService.getRepositories();
      if (repositories.isEmpty) {
        print("No repositories in the database, fetching from API...");
        final repositoriesFromApi = await apiService.fetchRepositories();
        await databaseService.insertRepositories(repositoriesFromApi);
        emit(RepositoryLoadSuccess(repositoriesFromApi));
      } else {
        emit(RepositoryLoadSuccess(repositories));
      }
    } catch (e) {
      print("Error fetching repositories: $e");
      emit(RepositoryLoadFailure());
    }
  }

  Future<void> _onRefreshRepositories(RefreshRepositories event, Emitter<RepositoryState> emit) async {
    print("Refreshing repositories from API...");
    emit(RepositoryLoadInProgress());
    try {
      final repositories = await apiService.fetchRepositories();
      await databaseService.insertRepositories(repositories);
      final updatedRepositories = await databaseService.getRepositories();
      emit(RepositoryLoadSuccess(updatedRepositories));
    } catch (e) {
      print("Error refreshing repositories: $e");
      emit(RepositoryLoadFailure());
    }
  }
}
