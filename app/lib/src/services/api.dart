import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiConfig {
  // Point this to your backend; default to localhost:8080
  static String baseUrl = const String.fromEnvironment(
    'SHOPLY_API_BASE',
    defaultValue: 'http://localhost:8080',
  );
}

class ProductOffer {
  final String id;
  final String title;
  final double price;
  final String currency;
  final String? imageUrl;
  final String? productUrl;
  final bool inStock;
  final String store;
  final double? originalPrice;
  final String? offerText;

  ProductOffer({
    required this.id,
    required this.title,
    required this.price,
    required this.currency,
    required this.inStock,
    required this.store,
    this.imageUrl,
    this.productUrl,
    this.originalPrice,
    this.offerText,
  });

  factory ProductOffer.fromJson(Map<String, dynamic> json) {
    return ProductOffer(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      currency: json['currency'],
      imageUrl: json['imageUrl'],
      productUrl: json['productUrl'],
      inStock: json['inStock'] == true,
      store: json['store'],
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : null,
      offerText: json['offerText'],
    );
  }
}

class PlatformResult {
  final String platform;
  final List<ProductOffer> items;
  final bool notAvailable;

  PlatformResult({
    required this.platform,
    required this.items,
    required this.notAvailable,
  });

  factory PlatformResult.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>)
        .map((e) => ProductOffer.fromJson(e))
        .toList();
    return PlatformResult(
      platform: json['platform'],
      items: items,
      notAvailable: json['notAvailable'] == true,
    );
  }
}

class SearchResponse {
  final String query;
  final Map<String, dynamic>? location;
  final List<PlatformResult> results;

  SearchResponse({
    required this.query,
    required this.location,
    required this.results,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    final results = (json['results'] as List<dynamic>)
        .map((e) => PlatformResult.fromJson(e))
        .toList();
    return SearchResponse(
      query: json['query'],
      location: json['location'],
      results: results,
    );
  }
}

class BackendApi {
  static Future<List<String>> getPlatforms() async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/platforms');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('Failed to fetch platforms');
    }
    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final platforms = (data['platforms'] as List<dynamic>)
        .map((e) => (e as Map<String, dynamic>)['key'] as String)
        .toList();
    return platforms;
  }

  static Future<SearchResponse> search({
    required String query,
    double? lat,
    double? lon,
    List<String>? platforms,
  }) async {
    final params = <String, String>{'q': query};
    if (lat != null && lon != null) {
      params['lat'] = lat.toString();
      params['lon'] = lon.toString();
    }
    if (platforms != null && platforms.isNotEmpty) {
      params['platforms'] = platforms.join(',');
    }
    final uri = Uri.parse('${ApiConfig.baseUrl}/search').replace(queryParameters: params);
    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('Search failed: ${resp.statusCode}');
    }
    return SearchResponse.fromJson(jsonDecode(resp.body));
  }
}
