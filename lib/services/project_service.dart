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
      
      if (result.hasException) {
        throw Exception('Failed to get projects: ${result.exception.toString()}');
      }
      
      final data = result.data?['myProjects'];
      if (data == null) {
        return [];
      }
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
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
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getProjectContributions({
    required String projectId,
    int limit = 20,
    int offset = 0,
    String orderBy = '-created_at',
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
    String orderBy = '-created_at',
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
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getProjectEstimates({
    required String projectId,
    int limit = 20,
    int offset = 0,
    String orderBy = '-created_at',
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
      rethrow;
    }
  }

  // Project members query
  static const String getProjectMembersQuery = '''
    query GetProject(\$id: ID!) {
      project(id: \$id) {
        id
        members {
          id
          role
          createdAt
          user {
            id
            name
            email
          }
        }
      }
    }
  ''';

  static Future<List<Map<String, dynamic>>> getProjectMembers({
    required String projectId,
    int? limit,
    int? offset,
    String? orderBy,
  }) async {
    try {
      final result = await CeremoGraphQLClient.client.query(
        QueryOptions(
          document: gql(getProjectMembersQuery),
          variables: {
            'id': projectId,
          },
        ),
      );
      
      if (result.hasException) {
        throw Exception('Failed to get project members: ${result.exception.toString()}');
      }
      
      final project = result.data?['project'];
      if (project == null) {
        throw Exception('Project not found');
      }
      
      final members = project['members'] as List<dynamic>?;
      return members?.cast<Map<String, dynamic>>() ?? [];
    } catch (e) {
      rethrow;
    }
  }

  // Contribution mutations
  static const String createContributionMutation = '''
    mutation CreateContribution(\$input: CreateContributionInput!) {
      createContribution(input: \$input) {
        success
        contribution {
          id
          amount
          paymentMethod
          transactionId
          note
          currency
          status
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
        errors
      }
    }
  ''';

  static Future<Map<String, dynamic>> createContribution({
    required String projectId,
    required String memberId,
    required double amount,
    required String paymentMethod,
    String? transactionId,
    String? note,
    String? currency,
  }) async {
    try {
      final result = await CeremoGraphQLClient.client.mutate(
        MutationOptions(
          document: gql(createContributionMutation),
          variables: {
            'input': {
              'projectId': projectId,
              'memberId': memberId,
              'amount': amount,
              'paymentMethod': paymentMethod,
              if (transactionId != null) 'transactionId': transactionId,
              if (note != null) 'note': note,
              if (currency != null) 'currency': currency,
            },
          },
        ),
      );
      
      if (result.hasException) {
        throw Exception('Failed to create contribution: ${result.exception.toString()}');
      }
      
      final data = result.data?['createContribution'];
      if (data == null || !data['success']) {
        throw Exception('Create contribution failed: ${data?['errors']?.join(', ') ?? 'Unknown error'}');
      }
      
      return data['contribution'];
    } catch (e) {
      rethrow;
    }
  }

  static const String updateContributionMutation = '''
    mutation UpdateContribution(\$input: UpdateContributionInput!) {
      updateContribution(input: \$input) {
        success
        contribution {
          id
          amount
          paymentMethod
          transactionId
          note
          currency
          status
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
        errors
      }
    }
  ''';

  static const String deleteContributionMutation = '''
    mutation DeleteContribution(\$id: ID!) {
      deleteContribution(id: \$id) {
        success
        errors
      }
    }
  ''';

  // Expense mutations
  static const String updateExpenseMutation = '''
    mutation UpdateExpense(\$input: UpdateExpenseInput!) {
      updateExpense(input: \$input) {
        success
        expense {
          id
          amount
          description
          category
          receiptUrl
          currency
          status
          createdAt
        }
        errors
      }
    }
  ''';

  static const String deleteExpenseMutation = '''
    mutation DeleteExpense(\$input: DeleteExpenseInput!) {
      deleteExpense(input: \$input) {
        success
        errors
      }
    }
  ''';

  static Future<Map<String, dynamic>> updateContribution({
    required String contributionId,
    required String memberId,
    required double amount,
    String? paymentMethod,
    String? transactionId,
    String? note,
    String? currency,
    String? status,
  }) async {
    try {
      final result = await CeremoGraphQLClient.client.mutate(
        MutationOptions(
          document: gql(updateContributionMutation),
          variables: {
            'input': {
              'contributionId': contributionId,
              'memberId': memberId,
              'amount': amount,
              if (paymentMethod != null) 'paymentMethod': paymentMethod,
              if (transactionId != null) 'transactionId': transactionId,
              if (note != null) 'note': note,
              if (currency != null) 'currency': currency,
              if (status != null) 'status': status,
            },
          },
        ),
      );
      
      if (result.hasException) {
        throw Exception('Failed to update contribution: ${result.exception.toString()}');
      }
      
      final data = result.data?['updateContribution'];
      if (data == null || !data['success']) {
        throw Exception('Update contribution failed: ${data?['errors']?.join(', ') ?? 'Unknown error'}');
      }
      
      return data['contribution'];
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> deleteContribution({
    required String contributionId,
  }) async {
    try {
      final result = await CeremoGraphQLClient.client.mutate(
        MutationOptions(
          document: gql(deleteContributionMutation),
          variables: {
            'id': contributionId,
          },
        ),
      );
      
      if (result.hasException) {
        throw Exception('Failed to delete contribution: ${result.exception.toString()}');
      }
      
      final data = result.data?['deleteContribution'];
      if (data == null || !data['success']) {
        throw Exception('Delete contribution failed: ${data?['errors']?.join(', ') ?? 'Unknown error'}');
      }
      
      return true;
    } catch (e) {
      rethrow;
    }
  }

  // Expense methods
  static Future<Map<String, dynamic>> updateExpense({
    required String expenseId,
    required double amount,
    required String description,
    required String category,
    String? estimateId,
    String? receiptUrl,
    String? currency,
    String? status,
  }) async {
    try {
      final result = await CeremoGraphQLClient.client.mutate(
        MutationOptions(
          document: gql(updateExpenseMutation),
          variables: {
            'input': {
              'expenseId': expenseId,
              'amount': amount,
              'description': description,
              'category': category,
              if (estimateId != null) 'estimateId': estimateId,
              if (receiptUrl != null) 'receiptUrl': receiptUrl,
              if (currency != null) 'currency': currency,
              if (status != null) 'status': status,
            },
          },
        ),
      );
      
      if (result.hasException) {
        throw Exception('Failed to update expense: ${result.exception.toString()}');
      }
      
      final data = result.data?['updateExpense'];
      if (data == null || !data['success']) {
        throw Exception('Update expense failed: ${data?['errors']?.join(', ') ?? 'Unknown error'}');
      }
      
      return data['expense'];
    } catch (e) {
      print('Update expense error: $e');
      rethrow;
    }
  }

  static Future<bool> deleteExpense({
    required String expenseId,
  }) async {
    try {
      final result = await CeremoGraphQLClient.client.mutate(
        MutationOptions(
          document: gql(deleteExpenseMutation),
          variables: {
            'input': {
              'expenseId': expenseId,
            },
          },
        ),
      );
      
      if (result.hasException) {
        throw Exception('Failed to delete expense: ${result.exception.toString()}');
      }
      
      final data = result.data?['deleteExpense'];
      if (data == null || !data['success']) {
        throw Exception('Delete expense failed: ${data?['errors']?.join(', ') ?? 'Unknown error'}');
      }
      
      return true;
    } catch (e) {
      print('Delete expense error: $e');
      rethrow;
    }
  }
}
