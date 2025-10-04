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
  // get subzones
static Future<List<Map<String, dynamic>>> getView_Subzones() async {
  final res = await http.get(Uri.parse('$baseUrl/subzones/View_subzones'));
  if (res.statusCode == 200) {
    final List<dynamic> decoded = jsonDecode(res.body);
    return decoded.cast<Map<String, dynamic>>();
  }
  throw Exception('Failed to load subzones: ${res.statusCode}');
}

  // -------------------------- Add Screen Designs ------------------------------
  // ------------------------------- Acquisition --------------------------------
  // GET suppliers dropdown
  static Future<List<Map<String, dynamic>>> getSuppliersDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/acquisition/suppliers'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    }
    throw Exception('Failed to load suppliers dropdown: ${res.statusCode}');
  }

  // GET location dropdown  
  static Future<List<Map<String, dynamic>>> getLocationDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/acquisition/provenance_locations'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
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

  // GET generation numbers dropdown
  static Future<List<int>> getGenerationNumberDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/acquisition/generation_numbers'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((item) => item as int).toList();
    }
    throw Exception('Failed to load generation numbers: ${res.statusCode}');
  }

  // GET varieties with species names dropdown (replaces separate genus/species)
  static Future<List<Map<String, dynamic>>> getVarietiesWithSpeciesDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/acquisition/varieties_with_species'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    }
    throw Exception('Failed to load varieties with species: ${res.statusCode}');
  }

  // POST Save button - Create new genetic source (acquisition)
  static Future<Map<String, dynamic>> createAcquisition({
    required String acquisitionDate,
    required int varietyId,
    required int supplierId,
    required String supplierLotNumber,
    double? price,
    int? gramWeight,
    int? provenanceId,
    int? viability,
    int? propagationType,
    int? generationNumber,
    bool landscapeOnly = false,
    String? researchNotes,
    int? femaleGeneticSource,
    int? maleGeneticSource,
  }) async {
    final Map<String, dynamic> requestBody = {
      "acquisition_date": acquisitionDate,
      "variety_id": varietyId,
      "supplier_id": supplierId,
      "supplier_lot_number": supplierLotNumber,
      "generation_number": generationNumber ?? 0,
      "landscape_only": landscapeOnly,
    };

    // Add optional fields only if they have values
    if (price != null) requestBody["price"] = price;
    if (gramWeight != null) requestBody["gram_weight"] = gramWeight;
    if (provenanceId != null) requestBody["provenance_id"] = provenanceId;
    if (viability != null) requestBody["viability"] = viability;
    if (propagationType != null) requestBody["propagation_type"] = propagationType;
    if (researchNotes != null && researchNotes.isNotEmpty) requestBody["research_notes"] = researchNotes;
    if (femaleGeneticSource != null) requestBody["female_genetic_source"] = femaleGeneticSource;
    if (maleGeneticSource != null) requestBody["male_genetic_source"] = maleGeneticSource;

    final res = await http.post(
      Uri.parse('$baseUrl/acquisition/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );
    
    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body);
    }
    
    print('Request body: ${jsonEncode(requestBody)}');
    throw Exception('Failed to create acquisition: ${res.statusCode}, error: ${res.body}');
  }

  // ------------------------------- Planting  --------------------------------
  // GET Genetic Source dropdown - missing data 25/09/25, to be implemented

  // GET Planted by (full name) dropdown
  static Future<List<String>> getPlantedByDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/plantings/planted_by'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((item) => item['full_name'] as String).toList();
    }
    throw Exception('Failed to load planted by (full name) dropdown: ${res.statusCode}');
  }
    
  // GET Zone Number dropdown
  static Future<List<String>> getZoneNumberDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/plantings/zone_number'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((item) => item['zone_number'] as String).toList();
    }
    throw Exception('Failed to load zone number dropdown: ${res.statusCode}');
  }

  // GET Container Type dropdown
  static Future<List<String>> getContainerTypeDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/plantings/container_type'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((item) => item['container_type'] as String).toList();
    }
    throw Exception('Failed to load container type dropdown: ${res.statusCode}');
  }

  // ------------------------------- New Family  --------------------------------

  // GET propagation type dropdown  
  static Future<List<String>> getPropagationTypeDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/newfamily/propagation_type'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((item) => item['propagation_type'] as String).toList();
    }
    throw Exception('Failed to load propagation type dropdown: ${res.statusCode}');
  }

  // GET breeding team dropdown - missing data 25/09/25, to be implemented

  // GET provenance location dropdown
  static Future<List<String>> getProvenanceLocationDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/newfamily/provenance_locations'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((item) => item['location'] as String).toList();
    }
    throw Exception('Failed to load provenance location dropdown: ${res.statusCode}');
  }

  // ------------------------------- Progeny --------------------------------

  // GET Family name dropdown - there's an intentional miss spell of family to famiy. Due to current DB storing this column name
  static Future<List<String>> getFamilyNameDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/progeny/family_name'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((item) => item['famiy_name'] as String).toList();
    }
    throw Exception('Failed to load family name dropdown: ${res.statusCode}');
  }

}