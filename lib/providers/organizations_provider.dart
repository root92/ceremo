import 'package:flutter/foundation.dart';
import '../services/organization_service.dart';

class OrganizationsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _organizations = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get organizations => _organizations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadOrganizations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final organizations = await OrganizationService.getMyOrganizations();
      _organizations = organizations;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _organizations = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createOrganization({
    required String name,
    String? description,
    String? slug,
    required String orgType,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final organization = await OrganizationService.createOrganization(
        name: name,
        description: description,
        slug: slug ?? name.toLowerCase().replaceAll(' ', '-'),
        orgType: orgType,
      );

      if (organization != null) {
        _organizations.insert(0, organization);
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

  // TODO: Implement joinOrganization when the backend supports it
  // Future<bool> joinOrganization(String organizationId) async {
  //   _isLoading = true;
  //   _error = null;
  //   notifyListeners();

  //   try {
  //     final success = await OrganizationService.joinOrganization(organizationId);
  //     if (success) {
  //       await loadOrganizations(); // Refresh the list
  //     }
  //     return success;
  //   } catch (e) {
  //     _error = e.toString();
  //     notifyListeners();
  //     return false;
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get organizations count
  int get totalOrganizations => _organizations.length;

  // Check if user has any organizations
  bool get hasOrganizations => _organizations.isNotEmpty;
}
