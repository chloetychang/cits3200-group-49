// lib/backend/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  // getusers
  static Future<List<dynamic>> getUsers() async {
    final res = await http.get(Uri.parse('$baseUrl/users/'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load users: ${res.statusCode}');
  }

 
  static Future<List<dynamic>> getSpecies() async {
    final res = await http.get(Uri.parse('$baseUrl/species/'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load species: ${res.statusCode}');
  }

  // get variety
  static Future<List<dynamic>> getVarieties() async {
    final res = await http.get(Uri.parse('$baseUrl/varieties/'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load varieties: ${res.statusCode}');
  }

  static Future<List<Map<String, dynamic>>> getSpeciesWithVarieties() async {
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

// -------------------------- Acquisition ------------------------------
  // For the old Species + variety dropdown:
  // GET genus dropdown
  static Future<List<String>> getGenusDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/acquisition/genus'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((item) => item['genus'] as String).toList();
    }
    throw Exception('Failed to load genus dropdown: ${res.statusCode}');
  }

  // GET species dropdown
  static Future<List<String>> getSpeciesDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/acquisition/species'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((item) => item['species'] as String).toList();
    }
    throw Exception('Failed to load species dropdown: ${res.statusCode}');
  }

  // GET suppliers dropdown
  static Future<List<String>> getSuppliersDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/acquisition/suppliers'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((item) => item['supplier_name'] as String).toList();
    }
    throw Exception('Failed to load suppliers dropdown: ${res.statusCode}');
  }

  // GET location dropdown  
  static Future<List<String>> getLocationDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/acquisition/provenance_locations'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((item) => item['location'] as String).toList();
    }
    throw Exception('Failed to load location dropdown: ${res.statusCode}');
  }

  static Future<List<String>> getBioregionDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/acquisition/bioregion_code'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((item) => item['bioregion_code'] as String).toList();
    }
    throw Exception('Failed to load bioregion code dropdown: ${res.statusCode}');
  }

  // POST Save button  
  static Future<Map<String, dynamic>> createAcquisition({
    required Map<String, dynamic> geneticSource,
    required Map<String, dynamic> supplier,
    required Map<String, dynamic> provenance,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/acquisition/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "genetic_source": geneticSource,
        "supplier": supplier,
        "provenance": provenance,
      }),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body);
    }
    print(jsonEncode({
      "genetic_source": geneticSource,
      "supplier": supplier,
      "provenance": provenance,
    }));
    throw Exception('Failed to create acquisition: ${res.statusCode}, error: ${res.body}');
  }
}



