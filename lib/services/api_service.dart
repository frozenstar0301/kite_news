import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cluster_model.dart';

class ApiService {
  static const String url = 'https://kite.kagi.com/world.json';

  static Future<List<Cluster>> fetchClusters() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List clusters = data['clusters'];
        return clusters.map((json) => Cluster.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load clusters');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
