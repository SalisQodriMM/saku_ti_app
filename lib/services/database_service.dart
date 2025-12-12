import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/todo_model.dart';
import '../models/project_model.dart';
import '../models/note_model.dart';

class DatabaseService {
  static const String _baseUrl =
      'https://sakti-app-12410-default-rtdb.asia-southeast1.firebasedatabase.app';

  // ==========================
  // 1. MODULE: CATATAN (NOTES)
  // ==========================

  // GET Notes
  Future<List<NoteModel>> getNotes(String uid) async {
    final url = Uri.parse('$_baseUrl/users/$uid/notes.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200 && response.body != 'null') {
        final Map<String, dynamic> data = json.decode(response.body);
        List<NoteModel> notes = [];
        data.forEach((key, value) {
          notes.add(NoteModel.fromJson(key, value));
        });
        return notes;
      }
      return [];
    } catch (e) {
      debugPrint("Error getNotes: $e");
      return [];
    }
  }

  // ADD Note
  Future<void> addNote(String uid, NoteModel note) async {
    final url = Uri.parse('$_baseUrl/users/$uid/notes.json');
    await http.post(url, body: json.encode(note.toJson()));
  }

  // UPDATE Note
  Future<void> updateNote(String uid, NoteModel note) async {
    final url = Uri.parse('$_baseUrl/users/$uid/notes/${note.id}.json');
    await http.patch(url, body: json.encode(note.toJson()));
  }

  // DELETE Note
  Future<void> deleteNote(String uid, String noteId) async {
    final url = Uri.parse('$_baseUrl/users/$uid/notes/$noteId.json');
    await http.delete(url);
  }

  // ==========================
  // 2. MODULE: TUGAS (TODOS)
  // ==========================

  // GET Todos
  Future<List<TodoModel>> getTodos(String uid) async {
    final url = Uri.parse('$_baseUrl/users/$uid/todos.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200 && response.body != 'null') {
        final Map<String, dynamic> data = json.decode(response.body);
        List<TodoModel> todos = [];
        data.forEach((key, value) {
          todos.add(TodoModel.fromJson(key, value));
        });
        return todos;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ADD Todo
  Future<void> addTodo(String uid, TodoModel todo) async {
    final url = Uri.parse('$_baseUrl/users/$uid/todos.json');
    await http.post(url, body: json.encode(todo.toJson()));
  }

  // UPDATE Todo (Full Edit)
  Future<void> updateTodo(String uid, TodoModel todo) async {
    final url = Uri.parse('$_baseUrl/users/$uid/todos/${todo.id}.json');
    await http.patch(url, body: json.encode(todo.toJson()));
  }

  // KHUSUS CHECKBOX: Update Status Selesai/Belum
  Future<void> updateTodoStatus(
    String uid,
    String todoId,
    bool isCompleted,
  ) async {
    final url = Uri.parse('$_baseUrl/users/$uid/todos/$todoId.json');
    await http.patch(url, body: json.encode({'isCompleted': isCompleted}));
  }

  // DELETE Todo
  Future<void> deleteTodo(String uid, String todoId) async {
    final url = Uri.parse('$_baseUrl/users/$uid/todos/$todoId.json');
    await http.delete(url);
  }

  // ==========================
  // 3. MODULE: PROJECT
  // ==========================

  // GET Projects
  Future<List<ProjectModel>> getProjects(String uid) async {
    final url = Uri.parse('$_baseUrl/users/$uid/projects.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200 && response.body != 'null') {
        final Map<String, dynamic> data = json.decode(response.body);
        List<ProjectModel> projects = [];
        data.forEach((key, value) {
          projects.add(ProjectModel.fromJson(key, value));
        });
        return projects;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ADD Project
  Future<void> addProject(String uid, ProjectModel project) async {
    final url = Uri.parse('$_baseUrl/users/$uid/projects.json');
    await http.post(url, body: json.encode(project.toJson()));
  }

  // UPDATE Project
  Future<void> updateProject(String uid, ProjectModel project) async {
    final url = Uri.parse('$_baseUrl/users/$uid/projects/${project.id}.json');
    await http.patch(url, body: json.encode(project.toJson()));
  }

  // DELETE Project
  Future<void> deleteProject(String uid, String projectId) async {
    final url = Uri.parse('$_baseUrl/users/$uid/projects/$projectId.json');
    await http.delete(url);
  }
}
