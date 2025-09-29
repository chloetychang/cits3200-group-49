// lib/backend/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  // get users
  static Future<List<dynamic>> getView_Users() async {
    final res = await http.get(Uri.parse('$baseUrl/users/View_users'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load users: ${res.statusCode}');
  }

  // get species
  static Future<List<dynamic>> getSpecies() async {
    final res = await http.get(Uri.parse('$baseUrl/species/'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load species: ${res.statusCode}');
  }

  // get varieties
  static Future<List<dynamic>> getVarieties() async {
    final res = await http.get(Uri.parse('$baseUrl/varieties/'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load varieties: ${res.statusCode}');
  }

  // species with varieties
  static Future<List<Map<String, dynamic>>> getView_Species() async {
    final species = await getSpecies();
    final varieties = await getVarieties();

    final Map<int, List<dynamic>> varietyBySpeciesId = {};
    for (final v in varieties) {
      final sid = v['species_id'];
      if (sid == null) continue;
      varietyBySpeciesId.putIfAbsent(sid, () => []).add(v);
    }

    final rows = <Map<String, dynamic>>[];
    for (final s in species) {
      final sid = s['species_id'];
      final list = varietyBySpeciesId[sid] ?? [];
      final varietiesText = list.isEmpty
          ? ''
          : list
              .map((v) => (v['variety'] ?? v['common_name'] ?? '').toString())
              .where((e) => e.trim().isNotEmpty)
              .join(', ');
      rows.add({
        'species_id': sid,
        'species': s['species'] ?? '',
        'varieties': varietiesText,
      });
    }
    return rows;
  }

  /// get genetic sources full
static Future<List<Map<String, dynamic>>> getView_GeneticSources({int skip = 0, int? limit}) async {
  final uri = Uri.parse(
    '$baseUrl/genetic_sources/View_GeneticSources?skip=$skip${limit != null ? '&limit=$limit' : ''}',
  );
  final res = await http.get(uri);
  if (res.statusCode == 200) {
    return List<Map<String, dynamic>>.from(jsonDecode(res.body));
  }
  throw Exception('Failed to load genetic sources full: ${res.statusCode}');
}

// get progeny with family
static Future<List<Map<String, dynamic>>> getView_Progeny({int skip = 0, int? limit}) async {
  final uri = Uri.parse(
    '$baseUrl/progeny/View_Progeny?skip=$skip${limit != null ? '&limit=$limit' : ''}',
  );
  final res = await http.get(uri);
  if (res.statusCode == 200) {
    return List<Map<String, dynamic>>.from(jsonDecode(res.body));
  }
  throw Exception('Failed to load progeny with family: ${res.statusCode}');
}

// get suppliers
static Future<List<Map<String, dynamic>>> getView_Suppliers({int skip = 0, int? limit}) async {
  final uri = Uri.parse(
    '$baseUrl/suppliers/View_Suppliers?skip=$skip${limit != null ? '&limit=$limit' : ''}',
  );
  final res = await http.get(uri);
  if (res.statusCode == 200) {
    return List<Map<String, dynamic>>.from(jsonDecode(res.body));
  }
  throw Exception('Failed to load suppliers: ${res.statusCode}');
}
// get plantings
static Future<List<Map<String, dynamic>>> getView_Plantings() async {
  final res = await http.get(Uri.parse('$baseUrl/plantings/View_plantings'));
  if (res.statusCode == 200) {
    final List<dynamic> data = jsonDecode(res.body);
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  }
  throw Exception('Failed to load plantings: ${res.statusCode}');
}

// get provenances
static Future<List<Map<String, dynamic>>> getView_Provenances() async {
  final res = await http.get(Uri.parse('$baseUrl/provenances/View_provenances'));
  if (res.statusCode == 200) {
    final List<dynamic> decoded = jsonDecode(res.body);
    return decoded.cast<Map<String, dynamic>>();
  }
  throw Exception('Failed to load provenances: ${res.statusCode}');
}

// get zones
static Future<List<Map<String, dynamic>>> getView_Zones() async {
  final res = await http.get(Uri.parse('$baseUrl/zones/View_zones'));
  if (res.statusCode == 200) {
    final List<dynamic> decoded = jsonDecode(res.body);
    return decoded.cast<Map<String, dynamic>>();
  }
  throw Exception('Failed to load zones: ${res.statusCode}');
}

}
