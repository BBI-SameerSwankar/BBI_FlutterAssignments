import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final int id;
  String title;
  String description;


  Todo({
    required this.id,
    required this.title,
    required this.description,
  });

 
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }


  Todo copyWith({
    int? id,
    String? title,
    String? description,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  @override
  List<Object> get props => [id, title, description];
}
