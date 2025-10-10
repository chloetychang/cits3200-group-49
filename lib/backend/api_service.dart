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

  // GET female parent dropdown
  static Future<List<String>> getFemaleParentDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/family/female_parents'));
    if (res.statusCode == 200) return List<String>.from(jsonDecode(res.body));
    throw Exception('Failed to load female parent dropdown: ${res.statusCode}');
  }

  // GET male parent dropdown
  static Future<List<String>> getMaleParentDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/family/male_parents'));
    if (res.statusCode == 200) return List<String>.from(jsonDecode(res.body));
    throw Exception('Failed to load male parent dropdown: ${res.statusCode}');
  }

  // GET breeding team dropdown
  static Future<List<String>> getBreedingTeamDropdown() async {
    final res = await http.get(Uri.parse('$baseUrl/family/breeding_teams'));
    if (res.statusCode == 200) return List<String>.from(jsonDecode(res.body));
    throw Exception('Failed to load breeding team dropdown: ${res.statusCode}');
  }

  // POST Save button - Create new family
  static Future<Map<String, dynamic>> createFamily({
    required String creationDate,
    String? familyId,
    required String propagationType,
    int? generationNumber,
    required String femaleParent,
    String? maleParent,
    String? speciesVariety,
    required String breedingTeam,
    required String lotNumber,
    String? weight,
    String? viability,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/family/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'creation_date': creationDate,
        if (familyId != null) 'family_id': familyId,
        'propagation_type': propagationType,
        if (generationNumber != null) 'generation_number': generationNumber,
        'female_parent': femaleParent,
        if (maleParent != null) 'male_parent': maleParent,
        if (speciesVariety != null) 'species_variety': speciesVariety,
        'breeding_team': breedingTeam,
        'lot_number': lotNumber,
        if (weight != null) 'weight': weight,
        if (viability != null) 'viability': viability,
      }),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to create family: ${res.statusCode} ${res.body}');
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
