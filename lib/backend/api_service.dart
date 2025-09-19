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

  // get species+variety for dropdown in Acquisitions Webpage
  static Future<List<String>> getSpeciesDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/species/dropdown'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((item) => item['species'] as String).toList();
    }
    throw Exception('Failed to load species dropdown: ${res.statusCode}');
  }
}

