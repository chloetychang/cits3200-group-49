// lib/backend/api_service.dart
import 'dart:convert';
import 'package:botanic_guide_a_tool_for_garden_planters/manage_lookups_table/manage_provenance/manage_provenance_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000';

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

  // POST Save button - (Pending Fix, still WIP)
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


  /// Fetch all conservation statuses
  static Future<List<dynamic>> getConservationStatus() async {
    final res = await http.get(Uri.parse('$baseUrl/conservation_status/'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load conservation status: ${res.statusCode}');
  }


  /// Create a new conservation status row
  static Future<Map<String, dynamic>> createConservationStatus({
    required String status,
    required String shortName,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/conservation_status/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "status": status,
        "status_short_name": shortName,
      }),
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to create conservation status: ${res.statusCode} ${res.body}');
  }


  /// Update an existing conservation status row by id
  static Future<Map<String, dynamic>> updateConservationStatus({
    required int id,
    required String status,
    required String shortName,
  }) async {
    final res = await http.put(
      Uri.parse('$baseUrl/conservation_status/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "status": status,
        "status_short_name": shortName,
      }),
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to update conservation status: ${res.statusCode} ${res.body}');
  }
  
    /// Get all container types
  static Future<List<dynamic>> getContainerTypes() async {
    final res = await http.get(Uri.parse('$baseUrl/container_type/'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load container types: ${res.statusCode}');
  }

  /// Create container type
  static Future<Map<String, dynamic>> createContainerType({
    required String containerType,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/container_type/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"container_type": containerType}),
    );
    if (res.statusCode == 200 || res.statusCode == 201) return jsonDecode(res.body);
    throw Exception('Failed to create container type: ${res.statusCode}');
  }

  /// Update container type
  static Future<Map<String, dynamic>> updateContainerType({
    required int id,
    required String containerType,
  }) async {
    final res = await http.put(
      Uri.parse('$baseUrl/container_type/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"container_type": containerType}),
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to update container type: ${res.statusCode}');
  }

// get plant utilities
static Future<List<dynamic>> getPlantUtilities() async {
  final res = await http.get(Uri.parse('$baseUrl/plant_utility/'));
  if (res.statusCode == 200) return jsonDecode(res.body);
  throw Exception('Failed to load plant utilities: ${res.statusCode}');
}

// create plant utility
static Future<Map<String, dynamic>> createPlantUtility({required String utility}) async {
  final res = await http.post(
    Uri.parse('$baseUrl/plant_utility/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'utility': utility}),
  );
  if (res.statusCode == 200) return jsonDecode(res.body);
  throw Exception('Failed to create plant utility: ${res.statusCode}');
}

// update plant utility
static Future<Map<String, dynamic>> updatePlantUtility({required int id, required String utility}) async {
  final res = await http.put(
    Uri.parse('$baseUrl/plant_utility/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'utility': utility}),
  );
  if (res.statusCode == 200) return jsonDecode(res.body);
  throw Exception('Failed to update plant utility: ${res.statusCode}');
}

// get removal causes
static Future<List<dynamic>> getRemovalCauses() async {
  final res = await http.get(Uri.parse('$baseUrl/removal_cause/'));
  if (res.statusCode == 200) return jsonDecode(res.body);
  throw Exception('Failed to load removal causes: ${res.statusCode}');
}

// create removal cause
static Future<void> createRemovalCause({required String cause}) async {
  final res = await http.post(
    Uri.parse('$baseUrl/removal_cause/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'cause': cause}),
  );
  if (res.statusCode != 200) throw Exception(res.body);
}

// update removal cause
static Future<void> updateRemovalCause({required int id, required String cause}) async {
  final res = await http.put(
    Uri.parse('$baseUrl/removal_cause/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'cause': cause}),
  );
  if (res.statusCode != 200) throw Exception(res.body);
}


  // Get all Provenances
  static Future<List<dynamic>> getProvenances() async {
    final res = await http.get(Uri.parse('$baseUrl/provenance/'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load provenances: ${res.statusCode}');
  }

  // Create new Provenance
  static Future<Map<String, dynamic>> createProvenance({
    required String location,
    String? bioregionCode,
    int? locationTypeId,
    String? extraDetails,
  }) async {
    final body = {
      'location': location,
      'bioregion_code': bioregionCode,
      'location_type_id': locationTypeId,
      'extra_details': extraDetails,
    }..removeWhere((k, v) => v == null);

    final res = await http.post(
      Uri.parse('$baseUrl/provenance/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to create provenance: ${res.body}');
  }

  // Update Provenance
  static Future<Map<String, dynamic>> updateProvenance({
    required int id,
    required String location,
    String? bioregionCode,
    int? locationTypeId,
    String? extraDetails,
  }) async {
    final body = {
      'location': location,
      'bioregion_code': bioregionCode,
      'location_type_id': locationTypeId,
      'extra_details': extraDetails,
    }..removeWhere((k, v) => v == null);

    final res = await http.put(
      Uri.parse('$baseUrl/provenance/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to update provenance: ${res.body}');
  }

  static Future<List<LocationTypeRow>> getLocationTypes() async {
  final res = await http.get(Uri.parse('$baseUrl/location_type'));
  if (res.statusCode == 200) {
    final List<dynamic> data = jsonDecode(res.body);
    return data
        .map((e) => LocationTypeRow.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  throw Exception('Failed to load location types: ${res.statusCode}');
}
}
