import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/repository.dart';

class ApiService {
  final String apiUrl = 'https://api.github.com/search/repositories?q=created:%3E2022-04-29&sort=stars&order=desc';

  Future<List<Repository>> fetchRepositories() async {
    print("Fetching repositories from API...");
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> items = data['items'];
      print("Fetched ${items.length} repositories.");
      return items.map((item) => Repository.fromJson(item)).toList();
    } else {
      print("Failed to fetch repositories: ${response.body}");
      throw Exception('Failed to load repositories');
    }
  }
}
