import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql_client.dart';

class ProjectService {
  // GraphQL Queries and Mutations
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
          contributor {
            id
            name
            email
          }
        }
        expenses {
          id
          amount
          currency
          category
          description
          status
          createdAt
          createdBy {
            id
            name
            email
          }
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
  
  // Project methods
  static Future<List<Map<String, dynamic>>> getMyProjects() async {
    try {
      final result = await CeremoGraphQLClient.client.query(
        QueryOptions(
          document: gql(myProjectsQuery),
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
