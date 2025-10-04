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
        return prefs.getString('access_token');
      },
    );
    
    final Link link = Link.from([
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
}
