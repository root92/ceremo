import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/organization_service.dart';
import '../services/graphql_client.dart';

class OrganizationContextProvider with ChangeNotifier {
  Map<String, dynamic>? _currentOrganization;
  List<Map<String, dynamic>> _organizations = [];
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get currentOrganization => _currentOrganization;
  List<Map<String, dynamic>> get organizations => _organizations;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasOrganizations => _organizations.isNotEmpty;

  static const String _currentOrganizationKey = 'current_organization';

  Future<void> initialize() async {
    print('OrganizationContextProvider: Initializing...');
    _isLoading = true;
    notifyListeners();

    try {
      // Load organizations
      await _loadOrganizations();
      
      // Load saved organization from storage
      await _loadSavedOrganization();
      
      // Auto-select default organization if none is selected
      await _autoSelectDefaultOrganization();
    } catch (e) {
      print('OrganizationContextProvider: Initialization error: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadOrganizations() async {
    try {
      print('OrganizationContextProvider: Loading organizations...');
      _organizations = await OrganizationService.getMyOrganizations();
      print('OrganizationContextProvider: Loaded ${_organizations.length} organizations');
      for (var org in _organizations) {
        print('OrganizationContextProvider: Organization: ${org['name']} (${org['id']})');
      }
    } catch (e) {
      print('OrganizationContextProvider: Error loading organizations: $e');
      _organizations = [];
    }
  }

  Future<void> _loadSavedOrganization() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedOrg = prefs.getString(_currentOrganizationKey);
      
      if (savedOrg != null) {
        // Find the organization in the current list
        if (_organizations.isNotEmpty) {
          final savedOrgId = savedOrg; // Assuming savedOrg is the ID
          final foundOrg = _organizations.firstWhere(
            (org) => org['id'] == savedOrgId,
            orElse: () => _organizations.first,
          );
          _currentOrganization = foundOrg;
          print('Restored saved organization: ${foundOrg['name']}');
        }
      }
    } catch (e) {
      print('Error loading saved organization: $e');
      // Clear invalid saved organization
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentOrganizationKey);
    }
  }

  Future<void> _autoSelectDefaultOrganization() async {
    if (_currentOrganization != null) return;
    
    if (_organizations.isNotEmpty) {
      // Try to find user's default organization or personal organization
      Map<String, dynamic>? defaultOrg;
      
      // First, try to find a personal organization
      try {
        defaultOrg = _organizations.firstWhere(
          (org) => org['orgType'] == 'personal',
        );
      } catch (e) {
        // No personal organization found, use the first one
        defaultOrg = _organizations.first;
      }
      
      if (defaultOrg.isNotEmpty) {
        await switchOrganization(defaultOrg);
        print('Auto-selected default organization: ${defaultOrg['name']}');
      }
    } else {
      // User has no organizations, create a personal one automatically (like the frontend does)
      print('No organizations found - creating personal organization...');
      try {
        final personalOrg = await OrganizationService.createPersonalOrganization();
        if (personalOrg != null) {
          _organizations = [personalOrg];
          await switchOrganization(personalOrg);
          print('Personal organization created and set as default: ${personalOrg['name']}');
        } else {
          _error = 'Failed to create personal organization. Please try again.';
        }
      } catch (e) {
        print('Error creating personal organization: $e');
        _error = 'Failed to create personal organization: $e';
      }
    }
  }

  Future<void> switchOrganization(Map<String, dynamic> organization) async {
    _currentOrganization = organization;
    
    // Save to storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentOrganizationKey, organization['id']);
    
    // Clear GraphQL cache to force fresh data
    await CeremoGraphQLClient.clearCache();
    
    print('Switched to organization: ${organization['name']} (${organization['id']})');
    notifyListeners();
  }

  Future<void> refreshData() async {
    await _loadOrganizations();
    
    // If current organization is no longer in the list, clear it
    if (_currentOrganization != null) {
      final stillExists = _organizations.any(
        (org) => org['id'] == _currentOrganization!['id'],
      );
      
      if (!stillExists) {
        _currentOrganization = null;
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_currentOrganizationKey);
      }
    }
    
    // Auto-select default if no current organization
    if (_currentOrganization == null) {
      await _autoSelectDefaultOrganization();
    }
    
    notifyListeners();
  }

  Future<void> clearOrganization() async {
    _currentOrganization = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentOrganizationKey);
    notifyListeners();
  }

  // Get organization header for GraphQL requests
  String? get organizationHeader {
    if (_currentOrganization != null) {
      return _currentOrganization!['slug'] ?? _currentOrganization!['id'];
    }
    return null;
  }

  
  // Check if user has a current organization
  bool get hasCurrentOrganization => _currentOrganization != null;
}
