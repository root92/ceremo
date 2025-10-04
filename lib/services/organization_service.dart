import 'package:graphql_flutter/graphql_flutter.dart';
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
        isDefault
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
      final result = await CeremoGraphQLClient.client.query(
        QueryOptions(
          document: gql(myOrganizationsQuery),
        ),
      );
      
      if (result.hasException) {
        throw Exception('Failed to get organizations: ${result.exception.toString()}');
      }
      
      final data = result.data?['myOrganizations'];
      if (data == null) {
        return [];
      }
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Get organizations error: $e');
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
