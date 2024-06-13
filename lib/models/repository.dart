import 'package:json_annotation/json_annotation.dart';

part 'repository.g.dart';

@JsonSerializable()
class Repository {
  final int id;
  final String name;
  final String? description;
  final int stargazers_count;
  final String html_url;

  Repository({
    required this.id,
    required this.name,
    this.description,
    required this.stargazers_count,
    required this.html_url,
  });

  factory Repository.fromJson(Map<String, dynamic> json) => _$RepositoryFromJson(json);
  Map<String, dynamic> toJson() => _$RepositoryToJson(this);
}
