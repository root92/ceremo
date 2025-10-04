import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'graphql_client.dart';

class OrganizationService {
  // GraphQL Queries and Mutations
  static const String myOrganizationsQuery = '''
    query MyOrganizations {
      myOrganizations {
        id
        name
        slug
        description
        orgType
        createdAt
        updatedAt
      }
    }
  ''';
  
  static const String createOrganizationMutation = '''
    mutation CreateOrganization(\$input: CreateOrganizationInput!) {
      createOrganization(input: \$input) {
        success
        organization {
          id
          name
          slug
          description
          orgType
          email
          phone
          website
          address
          country
          isActive
          createdAt
          updatedAt
          memberCount
          projectCount
          isPersonal
          isBusiness
          subscriptionTier
          hasSubscription
        }
        errors
      }
    }
  ''';

  static const String createPersonalOrganizationMutation = '''
    mutation CreatePersonalOrganization {
      createPersonalOrganization {
        organization {
          id
          name
          slug
          description
          orgType
          email
          phone
          website
          address
          country
          isActive
          createdAt
          updatedAt
          memberCount
          projectCount
          isPersonal
          isBusiness
          subscriptionTier
          hasSubscription
        }
        success
        errors
      }
    }
  ''';
  
  static const String organizationMembersQuery = '''
    query OrganizationMembers(\$organizationId: ID!) {
      organizationMembers(organizationId: \$organizationId) {
        id
        role
        joinedAt
        isActive
        isAdmin
        isOwner
        user {
          id
          name
          email
          phoneNumber
          country
          createdAt
        }
        organization {
          id
          name
          slug
        }
      }
    }
  ''';
  
  // Organization methods
  static Future<List<Map<String, dynamic>>> getMyOrganizations() async {
    try {
      print('OrganizationService: Attempting to fetch organizations...');
      
      // Check if user is authenticated
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      print('OrganizationService: User token exists: ${token != null}');
      
      final result = await CeremoGraphQLClient.client.query(
        QueryOptions(
          document: gql(myOrganizationsQuery),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      
      print('OrganizationService: GraphQL result: ${result.data}');
      print('OrganizationService: GraphQL exceptions: ${result.exception}');
      print('OrganizationService: Raw response: ${result.data?['myOrganizations']}');
      
      if (result.hasException) {
        throw Exception('Failed to get organizations: ${result.exception.toString()}');
      }
      
      final data = result.data?['myOrganizations'];
      if (data == null) {
        print('OrganizationService: No organizations data found');
        return [];
      }
      
      print('OrganizationService: Found ${data.length} organizations');
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('OrganizationService: Get organizations error: $e');
      rethrow;
    }
  }
  
  static Future<Map<String, dynamic>?> createOrganization({
    required String name,
    required String slug,
    String? description,
    required String orgType,
    String? email,
    String? phone,
    String? website,
    String? address,
    String? country,
  }) async {
    try {
      final result = await CeremoGraphQLClient.client.mutate(
        MutationOptions(
          document: gql(createOrganizationMutation),
          variables: {
            'input': {
              'name': name,
              'slug': slug,
              if (description != null) 'description': description,
              'orgType': orgType,
              if (email != null) 'email': email,
              if (phone != null) 'phone': phone,
              if (website != null) 'website': website,
              if (address != null) 'address': address,
              if (country != null) 'country': country,
            },
          },
        ),
      );

      if (result.hasException) {
        throw Exception('Failed to create organization: ${result.exception.toString()}');
      }

      final data = result.data?['createOrganization'];
      if (data == null || !data['success']) {
        throw Exception('Create organization failed: ${data?['errors']?.join(', ') ?? 'Unknown error'}');
      }

      return data['organization'];
    } catch (e) {
      print('Create organization error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> createPersonalOrganization() async {
    try {
      print('OrganizationService: Creating personal organization...');
      
      // Get user info to create personal organization name
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      String userName = 'User';
      String userEmail = 'user@example.com';
      
      if (userData != null) {
        try {
          // Parse user data (stored as string representation)
          // This is a simple approach - in production you'd want proper JSON parsing
          if (userData.contains('name')) {
            // Extract name from user data string
            final nameMatch = RegExp(r"name: '([^']+)'").firstMatch(userData);
            if (nameMatch != null) {
              userName = nameMatch.group(1) ?? 'User';
            }
          }
          if (userData.contains('email')) {
            // Extract email from user data string
            final emailMatch = RegExp(r"email: '([^']+)'").firstMatch(userData);
            if (emailMatch != null) {
              userEmail = emailMatch.group(1) ?? 'user@example.com';
            }
          }
        } catch (e) {
          print('Error parsing user data: $e');
        }
      }
      
      // Create personal organization using regular createOrganization mutation
      final orgName = "$userName's Personal Organization";
      final orgSlug = "${userEmail.split('@')[0]}-personal-${DateTime.now().millisecondsSinceEpoch}";
      
      final result = await CeremoGraphQLClient.client.mutate(
        MutationOptions(
          document: gql(createOrganizationMutation),
          variables: {
            'input': {
              'name': orgName,
              'slug': orgSlug,
              'description': 'Personal organization for $userName',
              'orgType': 'personal',
              'email': userEmail,
            },
          },
        ),
      );

      print('OrganizationService: Create personal organization result: ${result.data}');
      print('OrganizationService: Create personal organization exceptions: ${result.exception}');

      if (result.hasException) {
        throw Exception('Failed to create personal organization: ${result.exception.toString()}');
      }

      final data = result.data?['createOrganization'];
      if (data == null || !data['success']) {
        throw Exception('Create personal organization failed: ${data?['errors']?.join(', ') ?? 'Unknown error'}');
      }

      print('OrganizationService: Personal organization created successfully');
      return data['organization'];
    } catch (e) {
      print('OrganizationService: Create personal organization error: $e');
      rethrow;
    }
  }
  
  static Future<List<Map<String, dynamic>>> getOrganizationMembers(String organizationId) async {
    try {
      final result = await CeremoGraphQLClient.client.query(
        QueryOptions(
          document: gql(organizationMembersQuery),
          variables: {
            'organizationId': organizationId,
          },
        ),
      );
      
      if (result.hasException) {
        throw Exception('Failed to get organization members: ${result.exception.toString()}');
      }
      
      final data = result.data?['organizationMembers'];
      if (data == null) {
        return [];
      }
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Get organization members error: $e');
      rethrow;
    }
  }
}
