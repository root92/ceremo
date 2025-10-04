import 'package:flutter/foundation.dart';
import '../services/project_service.dart';

class ProjectsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _projects = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProjects() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final projects = await ProjectService.getMyProjects();
      _projects = projects;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _projects = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createProject({
    required String name,
    String? description,
    required String type,
    double? targetAmount,
    String? country,
    String? currency,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final project = await ProjectService.createProject(
        name: name,
        description: description,
        type: type,
        targetAmount: targetAmount,
        country: country,
        currency: currency,
      );

      if (project != null) {
        _projects.insert(0, project);
        _error = null;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProject({
    required String projectId,
    String? name,
    String? description,
    String? type,
    double? targetAmount,
    String? country,
    String? currency,
    String? status,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final project = await ProjectService.updateProject(
        projectId: projectId,
        name: name,
        description: description,
        type: type,
        targetAmount: targetAmount,
        country: country,
        currency: currency,
        status: status,
      );

      if (project != null) {
        final index = _projects.indexWhere((p) => p['id'] == projectId);
        if (index != -1) {
          _projects[index] = project;
        }
        _error = null;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> getProjectDetails(String projectId) async {
    try {
      return await ProjectService.getProjectDetails(projectId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Filter projects by status
  List<Map<String, dynamic>> getProjectsByStatus(String status) {
    return _projects.where((project) => project['status'] == status).toList();
  }

  // Get active projects
  List<Map<String, dynamic>> get activeProjects => getProjectsByStatus('active');

  // Get completed projects
  List<Map<String, dynamic>> get completedProjects => getProjectsByStatus('completed');

  // Get total projects count
  int get totalProjects => _projects.length;

  // Get total target amount
  double get totalTargetAmount {
    return _projects.fold(0.0, (sum, project) => sum + (project['targetAmount'] ?? 0.0));
  }

  // Get total current balance
  double get totalCurrentBalance {
    return _projects.fold(0.0, (sum, project) => sum + (project['currentBalance'] ?? 0.0));
  }
}
