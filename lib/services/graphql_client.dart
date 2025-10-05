import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class CeremoGraphQLClient {
  static GraphQLClient? _client;
  
  static GraphQLClient get client {
    if (_client == null) {
      _client = _createClient();
    }
    return _client!;
  }
  
  static GraphQLClient _createClient() {
    final HttpLink httpLink = HttpLink(ApiConfig.graphqlEndpoint);
    
    final AuthLink authLink = AuthLink(
      getToken: () async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('access_token');
        print('GraphQL Client - Retrieved token: ${token != null ? '${token.substring(0, 20)}...' : 'null'}');
        
        // Validate token format
        if (token != null && token.isNotEmpty) {
          // Check if token looks like a JWT (has 3 parts separated by dots)
          final parts = token.split('.');
          if (parts.length != 3) {
            await prefs.remove('access_token');
            return null;
          }
        }
        
        return token;
      },
    );

    // Add request/response logging
    final Link loggingLink = Link.function(
      (request, [next]) {
        
        // Log the actual request being sent
        if (request.operation != null) {
          print('GraphQL Document: ${request.operation!.document}');
        }
        
        return next!(request).map((response) {
          if (response.errors != null && response.errors!.isNotEmpty) {
            print('GraphQL Errors: ${response.errors}');
          }
          return response;
        });
      },
    );
    
    final Link link = Link.from([
      loggingLink,
      authLink,
      httpLink,
    ]);
    
    return GraphQLClient(
      link: link,
      cache: GraphQLCache(
        store: InMemoryStore(),
      ),
    );
  }
  
  static Future<void> clearCache() async {
    if (_client != null) {
      _client!.cache.store.reset();
    }
  }

  static void refreshClient() {
    _client = null; // Force recreation of client with new token
  }
}
