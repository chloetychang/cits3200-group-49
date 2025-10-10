// lib/backend/api_service.dart
import 'dart:convert';
import 'package:botanic_guide_a_tool_for_garden_planters/manage_lookups_table/manage_provenance/manage_provenance_model.dart';
import 'package:botanic_guide_a_tool_for_garden_planters/manage_lookups_table/manage_provenance_location_types/manage_provenance_location_types_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000';

  // get users
  static Future<List<dynamic>> getView_Users() async {
    final res = await http.get(Uri.parse('$baseUrl/users/View_users'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load users: ${res.statusCode}');
  }

static Future<List<Map<String, dynamic>>> getSpecies({String? search}) async {
  final url = search != null && search.isNotEmpty
      ? '$baseUrl/species/?search=$search'
      : '$baseUrl/species/';

  final res = await http.get(Uri.parse(url));

  if (res.statusCode == 200) {
    final data = jsonDecode(res.body) as List<dynamic>;
    return data.cast<Map<String, dynamic>>().toList();
  }
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
  final res = await http.get(Uri.parse('$baseUrl/species/View_Species'));
  
  if (res.statusCode == 200) {
    final List<dynamic> data = jsonDecode(res.body);
    return data.cast<Map<String, dynamic>>().toList();
  }
  
  throw Exception('Failed to load species with varieties: ${res.statusCode}');
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
  
  // GET Zones dropdown
  static Future<List<Map<String, dynamic>>> getZonesDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/planting/zones'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to load zones dropdown: ${res.statusCode}');
  }

  // GET Varieties with species names dropdown (with pagination and search)
  static Future<List<Map<String, dynamic>>> getPlantingVarietiesWithSpeciesDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/planting/varieties_with_species'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to load varieties with species dropdown: ${res.statusCode}');
  }



  // GET Containers dropdown
  static Future<List<Map<String, dynamic>>> getContainersDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/planting/containers'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to load containers dropdown: ${res.statusCode}');
  }

  // GET Users dropdown (for planted by)
  static Future<List<Map<String, dynamic>>> getUsersDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/planting/users'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to load users dropdown: ${res.statusCode}');
  }

  // GET Genetic Sources dropdown
  static Future<List<Map<String, dynamic>>> getGeneticSourcesDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/planting/genetic_sources'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to load genetic sources dropdown: ${res.statusCode}');
  }

  // GET Removal Causes dropdown
  static Future<List<Map<String, dynamic>>> getRemovalCausesDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/planting/removal_causes'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to load removal causes dropdown: ${res.statusCode}');
  }

  // POST Create planting
  static Future<Map<String, dynamic>> createPlanting({
    required String datePlanted,
    required int numberPlanted,
    required int zoneId,
    required int varietyId,
    required int containerTypeId,
    int? plantedBy,
    int? geneticSourceId,
    String? comments,
    String? removalDate,
    int? numberRemoved,
    int? removalCauseId,
  }) async {
    final body = {
      'date_planted': datePlanted,
      'number_planted': numberPlanted,
      'zone_id': zoneId,
      'variety_id': varietyId,
      'container_type_id': containerTypeId,
      if (plantedBy != null) 'planted_by': plantedBy,
      if (geneticSourceId != null) 'genetic_source_id': geneticSourceId,
      if (comments != null) 'comments': comments,
      if (removalDate != null) 'removal_date': removalDate,
      if (numberRemoved != null) 'number_removed': numberRemoved,
      if (removalCauseId != null) 'removal_cause_id': removalCauseId,
    };

    final res = await http.post(
      Uri.parse('$baseUrl/planting/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to create planting: ${res.statusCode} ${res.body}');
  }

  // Legacy methods for backward compatibility - these now call the new endpoints
  static Future<List<String>> getPlantedByDropdown() async {
    final users = await getUsersDropdown();
    return users.map((user) => user['full_name'] as String).toList();
  }
    
  static Future<List<String>> getZoneNumberDropdown() async {
    final zones = await getZonesDropdown();
    return zones.map((zone) => zone['zone_number'] as String).toList();
  }

  static Future<List<String>> getContainerTypeDropdown() async {
    final containers = await getContainersDropdown();
    return containers.map((container) => container['container_type'] as String).toList();
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

static Future<List<Map<String, dynamic>>> getPlantUtilities({String? search}) async {
  final url = search != null && search.isNotEmpty
      ? '$baseUrl/plant_utility/?search=$search&limit=50'
      : '$baseUrl/plant_utility/?limit=50';

  final res = await http.get(Uri.parse(url));

  if (res.statusCode == 200) {    final data = jsonDecode(res.body) as List<dynamic>;
    return data.cast<Map<String, dynamic>>().toList();
  }
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
  static Future<Map<String, dynamic>> createProvenanceM({
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

  /// Get all location types
  static Future<List<LocationTypeRow>> getLocationTypes() async {
    final res = await http.get(Uri.parse('$baseUrl/location_type'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((e) => LocationTypeRow.fromJson(e)).toList();
    }
    throw Exception('Failed to load location types: ${res.statusCode}');
  }

  /// Create a new location type
  static Future<LocationTypeRow> createLocationType({
    required String locationType,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/location_type'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"location_type": locationType}),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return LocationTypeRow.fromJson(jsonDecode(res.body));
    }
    throw Exception('Failed to create location type: ${res.statusCode}');
  }

  /// Update an existing location type
  static Future<LocationTypeRow> updateLocationType({
    required int id,
    required String locationType,
  }) async {
    final res = await http.put(
      Uri.parse('$baseUrl/location_type/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"location_type": locationType}),
    );
    if (res.statusCode == 200) {
      return LocationTypeRow.fromJson(jsonDecode(res.body));
    }
    throw Exception('Failed to update location type: ${res.statusCode}');
  }
static Future<List<P_LocationTypeRow>> getP_LocationTypes() async {
  final res = await http.get(Uri.parse('$baseUrl/location_type'));
  if (res.statusCode == 200) {
    final List<dynamic> data = jsonDecode(res.body);
    return data
        .map((e) => P_LocationTypeRow.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  throw Exception('Failed to load location types: ${res.statusCode}');
}

// ---------------- Propagation Type ----------------

// GET all
static Future<List<dynamic>> getPropagationTypes() async {
  final res = await http.get(Uri.parse('$baseUrl/propagation_type/'));
  if (res.statusCode == 200) return jsonDecode(res.body);
  throw Exception('Failed to load propagation types: ${res.statusCode}');
}

// CREATE
static Future<Map<String, dynamic>> createPropagationType({
  required String propagationType,
  bool needsTwoParents = false,
  bool canCrossGenera = false,
}) async {
  final res = await http.post(
    Uri.parse('$baseUrl/propagation_type/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'propagation_type': propagationType,
      'needs_two_parents': needsTwoParents,
      'can_cross_genera': canCrossGenera,
    }),
  );
  if (res.statusCode == 200) return jsonDecode(res.body);
  throw Exception('Failed to create propagation type: ${res.statusCode}');
}

// UPDATE
static Future<Map<String, dynamic>> updatePropagationType({
  required int id,
  required String propagationType,
  bool needsTwoParents = false,
  bool canCrossGenera = false,
}) async {
  final res = await http.put(
    Uri.parse('$baseUrl/propagation_type/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'propagation_type': propagationType,
      'needs_two_parents': needsTwoParents,
      'can_cross_genera': canCrossGenera,
    }),
  );
  if (res.statusCode == 200) return jsonDecode(res.body);
  throw Exception('Failed to update propagation type: ${res.statusCode}');
}

// ---------- Species Utility Link ----------
static Future<List<dynamic>> getSpeciesUtilityLinks() async {
  final res = await http.get(Uri.parse('$baseUrl/species_utility/'));
  if (res.statusCode == 200) return jsonDecode(res.body);
  throw Exception('Failed to load species-utility links: ${res.statusCode}');
}

static Future<Map<String, dynamic>> createSpeciesUtilityLink({
  required int speciesId,
  required int plantUtilityId,
}) async {
  final res = await http.post(
    Uri.parse('$baseUrl/species_utility/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'species_id': speciesId,
      'plant_utility_id': plantUtilityId,
    }),
  );
  if (res.statusCode == 200) return jsonDecode(res.body);
  throw Exception('Failed to create species-utility link: ${res.statusCode}');
}

static Future<Map<String, dynamic>> updateSpeciesUtilityLink({
  required int speciesId,
  required int plantUtilityId,
  int? newSpeciesId,
  int? newPlantUtilityId,
}) async {
  final res = await http.put(
    Uri.parse('$baseUrl/species_utility/$speciesId/$plantUtilityId'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'species_id': newSpeciesId ?? speciesId,
      'plant_utility_id': newPlantUtilityId ?? plantUtilityId,
    }),
  );
  if (res.statusCode == 200) return jsonDecode(res.body);
  throw Exception('Failed to update species-utility link: ${res.statusCode}');
}

static Future<List<Map<String, dynamic>>> getSpeciesForPreloading({int limit = 20}) async {
  final url = '$baseUrl/species/?limit=$limit'; 
  final res = await http.get(Uri.parse(url));

  if (res.statusCode == 200) {
    final data = jsonDecode(res.body) as List<dynamic>;
    return data.cast<Map<String, dynamic>>().toList();
  }
  throw Exception('Failed to preload species: ${res.statusCode}');
}

static Future<List<Map<String, dynamic>>> getPlantUtilitiesForPreloading({int limit = 20}) async {
  final url = '$baseUrl/plant_utility/?limit=$limit'; 
  final res = await http.get(Uri.parse(url));

  if (res.statusCode == 200) {
    final data = jsonDecode(res.body) as List<dynamic>;
    return data.cast<Map<String, dynamic>>().toList();
  }
  throw Exception('Failed to preload plant utilities: ${res.statusCode}');
}

// get all zone aspects
static Future<List<dynamic>> getZoneAspects() async {
  final res = await http.get(Uri.parse('$baseUrl/zone_aspect/'));
  if (res.statusCode == 200) return jsonDecode(res.body);
  throw Exception('Failed to load zone aspects: ${res.statusCode}');
}

// create a new zone aspect
static Future<Map<String, dynamic>> createZoneAspect(String aspect) async {
  final res = await http.post(
    Uri.parse('$baseUrl/zone_aspect/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'aspect': aspect}),
  );
  if (res.statusCode == 200 || res.statusCode == 201) return jsonDecode(res.body);
  throw Exception('Failed to create zone aspect: ${res.statusCode}');
}

// update zone aspect
static Future<Map<String, dynamic>> updateZoneAspect(int id, String aspect) async {
  final res = await http.put(
    Uri.parse('$baseUrl/zone_aspect/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'aspect': aspect}),
  );
  if (res.statusCode == 200) return jsonDecode(res.body);
  throw Exception('Failed to update zone aspect: ${res.statusCode}');
}

  // ------------------------------- Provenances --------------------------------
  static Future<List<String>> getProvenanceBioregionDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/provenances/bioregion'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((item) => item['bioregion_code'] as String).toList();
    }
    throw Exception('Failed to load bioregion name dropdown: ${res.statusCode}');
  }

  static Future<List<String>> getLocationTypeDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/provenances/location_type'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((item) => item['location_type'] as String).toList();
    }
    throw Exception('Failed to load location type dropdown: ${res.statusCode}');
  }

  static Future<List<Map<String, dynamic>>> getLocationTypeDropdownFull() async {
    final res = await http.get(Uri.parse('$baseUrl/provenances/location_type'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to load location type dropdown: ${res.statusCode}');
  }

  // POST create provenance
  static Future<Map<String, dynamic>> createProvenance({
    required String location,
    String? bioregionCode,
    int? locationTypeId,
    String? extraDetails,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/provenances/provenance/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'location': location,
        if (bioregionCode != null) 'bioregion_code': bioregionCode,
        if (locationTypeId != null) 'location_type_id': locationTypeId,
        if (extraDetails != null) 'extra_details': extraDetails,
      }),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to create provenance: ${res.statusCode}, error: ${res.body}');
  }
}
