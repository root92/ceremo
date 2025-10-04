import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql_client.dart';

class ProjectService {
  // GraphQL Queries and Mutations
  static const String myOrganizationsQuery = '''
    query MyOrganizations {
      myOrganizations {
        id
        name
        slug
        description
        createdAt
      }
    }
  ''';

  static const String myProjectsQuery = '''
    query MyProjects {
      myProjects {
        id
        name
        description
        type
        status
        targetAmount
        currentBalance
        country
        currency
        createdAt
        updatedAt
        organization {
          id
          name
          slug
        }
      }
    }
  ''';
  
  static const String createProjectMutation = '''
    mutation CreateProject(\$input: CreateProjectInput!) {
      createProject(input: \$input) {
        success
        project {
          id
          name
          description
          type
          status
          targetAmount
          currentBalance
          country
          currency
          isPublic
          createdAt
          updatedAt
          owner {
            id
            name
            email
          }
          organization {
            id
            name
            slug
          }
        }
        errors
      }
    }
  ''';
  
  static const String projectDetailsQuery = '''
    query ProjectDetails(\$id: ID!) {
      project(id: \$id) {
        id
        name
        description
        type
        status
        targetAmount
        currentBalance
        country
        currency
        isPublic
        createdAt
        updatedAt
        closedAt
        owner {
          id
          name
          email
        }
        organization {
          id
          name
          slug
        }
        totalContributions
        totalExpenses
        progressPercentage
        contributions {
          id
          amount
          currency
          status
          paymentMethod
          createdAt
        }
        expenses {
          id
          amount
          currency
          category
          description
          status
          createdAt
        }
      }
    }
  ''';
  
  static const String updateProjectMutation = '''
    mutation UpdateProject(\$projectId: ID!, \$input: UpdateProjectInput!) {
      updateProject(projectId: \$projectId, input: \$input) {
        success
        project {
          id
          name
          description
          type
          status
          targetAmount
          currentBalance
          country
          currency
          isPublic
          createdAt
          updatedAt
        }
        errors
      }
    }
  ''';

  static const String getProjectContributionsQuery = '''
    query GetProjectContributions(\$projectId: ID!, \$limit: Int, \$offset: Int, \$orderBy: String) {
      contributions(projectId: \$projectId, limit: \$limit, offset: \$offset, orderBy: \$orderBy) {
        id
        reference
        amount
        note
        status
        paymentMethod
        transactionId
        currency
        createdAt
        member {
          id
          role
          user {
            id
            name
            email
          }
        }
      }
    }
  ''';

  static const String getProjectExpensesQuery = '''
    query GetProjectExpenses(\$projectId: ID!, \$limit: Int, \$offset: Int, \$orderBy: String) {
      expenses(projectId: \$projectId, limit: \$limit, offset: \$offset, orderBy: \$orderBy) {
        id
        reference
        amount
        description
        category
        status
        currency
        createdAt
        estimate {
          id
          description
          estimatedAmount
          category
          priority
          status
          currency
        }
      }
    }
  ''';

  static const String getProjectEstimatesQuery = '''
    query GetProjectEstimates(\$projectId: ID!, \$limit: Int, \$offset: Int, \$orderBy: String) {
      estimates(projectId: \$projectId, limit: \$limit, offset: \$offset, orderBy: \$orderBy) {
        id
        reference
        description
        estimatedAmount
        category
        priority
        status
        notes
        currency
        createdAt
      }
    }
  ''';
  
  // Organization methods
  static Future<List<Map<String, dynamic>>> getMyOrganizations() async {
    try {
      print('Attempting to fetch organizations...');
      final result = await CeremoGraphQLClient.client.query(
        QueryOptions(
          document: gql(myOrganizationsQuery),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      
      print('Organizations result: ${result.data}');
      print('Organizations exceptions: ${result.exception}');
      
      if (result.hasException) {
        throw Exception('Failed to get organizations: ${result.exception.toString()}');
      }
      
      final data = result.data?['myOrganizations'];
      if (data == null) {
        print('No organizations data found');
        return [];
      }
      
      print('Found ${data.length} organizations');
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Get organizations error: $e');
      rethrow;
    }
  }

  // Project methods
  static Future<List<Map<String, dynamic>>> getMyProjects() async {
    try {
      print('Attempting to fetch projects...');
      
      // First, check if user has organizations
      final organizations = await getMyOrganizations();
      if (organizations.isEmpty) {
        print('User has no organizations, cannot access projects');
        throw Exception('You need to be part of an organization to access projects. Please join an organization first.');
      }
      
      print('User has ${organizations.length} organizations, fetching projects...');
      
      // Now try to get projects
      final result = await CeremoGraphQLClient.client.query(
        QueryOptions(
          document: gql(myProjectsQuery),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      
      print('GraphQL result: ${result.data}');
      print('GraphQL exceptions: ${result.exception}');
      
      if (result.hasException) {
        throw Exception('Failed to get projects: ${result.exception.toString()}');
      }
      
      final data = result.data?['myProjects'];
      if (data == null) {
        print('No projects data found');
        return [];
      }
      
      print('Found ${data.length} projects');
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Get projects error: $e');
      rethrow;
    }
  }
  
  static Future<Map<String, dynamic>?> createProject({
    required String name,
    String? description,
    required String type,
    double? targetAmount,
    String? country,
    String? currency,
  }) async {
    try {
      final result = await CeremoGraphQLClient.client.mutate(
        MutationOptions(
          document: gql(createProjectMutation),
          variables: {
            'input': {
              'name': name,
              if (description != null) 'description': description,
              'type': type,
              if (targetAmount != null) 'targetAmount': targetAmount,
              if (country != null) 'country': country,
              if (currency != null) 'currency': currency,
            },
          },
        ),
      );
      
      if (result.hasException) {
        throw Exception('Failed to create project: ${result.exception.toString()}');
      }
      
      final data = result.data?['createProject'];
      if (data == null || !data['success']) {
        throw Exception('Create project failed: ${data?['errors']?.join(', ') ?? 'Unknown error'}');
      }
      
      return data['project'];
    } catch (e) {
      print('Create project error: $e');
      rethrow;
    }
  }
  
  static Future<Map<String, dynamic>?> getProjectDetails(String projectId) async {
    try {
      final result = await CeremoGraphQLClient.client.query(
        QueryOptions(
          document: gql(projectDetailsQuery),
          variables: {
            'id': projectId,
          },
        ),
      );
      
      if (result.hasException) {
        throw Exception('Failed to get project details: ${result.exception.toString()}');
      }
      
      return result.data?['project'];
    } catch (e) {
      print('Get project details error: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getProjectContributions({
    required String projectId,
    int limit = 20,
    int offset = 0,
    String orderBy = '-createdAt',
  }) async {
    try {
      final result = await CeremoGraphQLClient.client.query(
        QueryOptions(
          document: gql(getProjectContributionsQuery),
          variables: {
            'projectId': projectId,
            'limit': limit,
            'offset': offset,
            'orderBy': orderBy,
          },
        ),
      );
      
      if (result.hasException) {
        throw Exception('Failed to get project contributions: ${result.exception.toString()}');
      }
      
      final contributions = result.data?['contributions'] as List<dynamic>? ?? [];
      return contributions.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Get project contributions error: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getProjectExpenses({
    required String projectId,
    int limit = 20,
    int offset = 0,
    String orderBy = '-createdAt',
  }) async {
    try {
      final result = await CeremoGraphQLClient.client.query(
        QueryOptions(
          document: gql(getProjectExpensesQuery),
          variables: {
            'projectId': projectId,
            'limit': limit,
            'offset': offset,
            'orderBy': orderBy,
          },
        ),
      );
      
      if (result.hasException) {
        throw Exception('Failed to get project expenses: ${result.exception.toString()}');
      }
      
      final expenses = result.data?['expenses'] as List<dynamic>? ?? [];
      return expenses.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Get project expenses error: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getProjectEstimates({
    required String projectId,
    int limit = 20,
    int offset = 0,
    String orderBy = '-createdAt',
  }) async {
    try {
      final result = await CeremoGraphQLClient.client.query(
        QueryOptions(
          document: gql(getProjectEstimatesQuery),
          variables: {
            'projectId': projectId,
            'limit': limit,
            'offset': offset,
            'orderBy': orderBy,
          },
        ),
      );
      
      if (result.hasException) {
        throw Exception('Failed to get project estimates: ${result.exception.toString()}');
      }
      
      final estimates = result.data?['estimates'] as List<dynamic>? ?? [];
      return estimates.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Get project estimates error: $e');
      rethrow;
    }
  }
  
  static Future<Map<String, dynamic>?> updateProject({
    required String projectId,
    String? name,
    String? description,
    String? type,
    double? targetAmount,
    String? country,
    String? currency,
    String? status,
  }) async {
    try {
      final result = await CeremoGraphQLClient.client.mutate(
        MutationOptions(
          document: gql(updateProjectMutation),
          variables: {
            'projectId': projectId,
            'input': {
              if (name != null) 'name': name,
              if (description != null) 'description': description,
              if (type != null) 'type': type,
              if (targetAmount != null) 'targetAmount': targetAmount,
              if (country != null) 'country': country,
              if (currency != null) 'currency': currency,
              if (status != null) 'status': status,
            },
          },
        ),
      );
      
      if (result.hasException) {
        throw Exception('Failed to update project: ${result.exception.toString()}');
      }
      
      final data = result.data?['updateProject'];
      if (data == null || !data['success']) {
        throw Exception('Update project failed: ${data?['errors']?.join(', ') ?? 'Unknown error'}');
      }
      
      return data['project'];
    } catch (e) {
      print('Update project error: $e');
      rethrow;
    }
  }
}
