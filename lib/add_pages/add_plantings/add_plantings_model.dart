import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'add_plantings_widget.dart' show AddPlantingsWidget;
import 'package:flutter/material.dart';
import '/backend/api_service.dart'; 
import 'package:dropdown_textfield/dropdown_textfield.dart';

class AddPlantingsModel extends FlutterFlowModel<AddPlantingsWidget> {
  ///  Dropdown combo controller state
  late final SingleValueDropDownController PlantedByComboController;
  late final SingleValueDropDownController ZoneComboController;
  late final SingleValueDropDownController ContainerTypeComboController;
  late final SingleValueDropDownController VarietiesComboController;
  late final SingleValueDropDownController GeneticSourcesComboController;
  late final SingleValueDropDownController RemovalCausesComboController;

  // Genetic Sources Checkbox
  bool? checkboxValue1;
  
  // Existing plantings checkbox
  bool? checkboxValue2;

  // All WA Species Checkbox
  bool? checkboxValue3;

  // Date Planted 
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;

  // Number Planted
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  // Genetic Sources
  List<String> GeneticSourcesDropdown = []; // Display names for dropdown
  List<Map<String, dynamic>> GeneticSourcesData = []; // Full data for ID lookup
  String? selectedGeneticSource;
  FormFieldController<String>? geneticSourcesDropdownController;

  // Fetch Genetic Sources dropdown 
  Future<void> loadGeneticSourcesDropdown() async {
    GeneticSourcesData = await ApiService.getGeneticSourcesDropdown();
    // Create display names with genetic_source_id for now (you can customize this format)
    GeneticSourcesDropdown = GeneticSourcesData.map((gs) => "Genetic Source #${gs['genetic_source_id']}").toList();
  }

  // Get genetic source ID by display name
  int? getGeneticSourceId(String? displayName) {
    if (displayName == null) return null;
    // Extract ID from display name format "Genetic Source #123"
    final match = RegExp(r'#(\d+)').firstMatch(displayName);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }

  // Varieties with Species
  List<String> VarietiesDropdown = []; // Display names for dropdown
  List<Map<String, dynamic>> VarietiesData = []; // Full data for ID lookup
  String? selectedVariety;
  FormFieldController<String>? varietiesDropdownController;
  
  // Pagination state for varieties
  int _varietiesSkip = 0;
  final int _varietiesLimit = 50; // Load 50 at a time for better performance
  bool _varietiesHasMore = true;
  bool _varietiesLoading = false;

  // Fetch Varieties with Species dropdown (with pagination)
  Future<void> loadVarietiesDropdown({bool reset = false}) async {
    if (_varietiesLoading) return;
    
    if (reset) {
      _varietiesSkip = 0;
      VarietiesData.clear();
      VarietiesDropdown.clear();
      _varietiesHasMore = true;
    }
    
    if (!_varietiesHasMore) return;
    
    _varietiesLoading = true;
    
    try {
      final rawList = await ApiService.getPlantingVarietiesWithSpeciesDropdown(
        skip: _varietiesSkip,
        limit: _varietiesLimit,
      );
      
      VarietiesData.addAll(rawList);
      // Create display names combining full species name and variety
      final newNames = rawList.map((variety) => 
        "${variety['full_species_name']} - ${variety['variety']}"
      ).toList();
      VarietiesDropdown.addAll(newNames);
      
      _varietiesSkip += rawList.length;
      _varietiesHasMore = rawList.length == _varietiesLimit;
      
      // Sort only the new additions to maintain performance
      if (reset) {
        VarietiesDropdown.sort();
      }
    } finally {
      _varietiesLoading = false;
    }
  }

  // Search varieties
  Future<void> searchVarieties(String search) async {
    if (search.isEmpty) {
      await loadVarietiesDropdown(reset: true);
      return;
    }
    
    _varietiesLoading = true;
    try {
      final rawList = await ApiService.getPlantingVarietiesWithSpeciesDropdown(
        skip: 0,
        limit: 100, // Show more results for search
        search: search,
      );
      
      VarietiesData = rawList;
      VarietiesDropdown = rawList.map((variety) => 
        "${variety['full_species_name']} - ${variety['variety']}"
      ).toList()..sort();
    } finally {
      _varietiesLoading = false;
    }
  }

  // Get variety ID by display name
  int? getVarietyId(String? displayName) {
    if (displayName == null) return null;
    final found = VarietiesData.firstWhere(
      (item) => "${item['full_species_name']} - ${item['variety']}" == displayName,
      orElse: () => <String, dynamic>{},
    );
    return found['variety_id'] as int?;
  }

  // Planted By
  List<String> PlantedByDropdown = []; // Display names for dropdown
  List<Map<String, dynamic>> PlantedByData = []; // Full data for ID lookup
  String? selectedPlantedBy;
  FormFieldController<String>? plantedByDropdownController;

  // Fetch Planted By dropdown 
  Future<void> loadPlantedByDropdown() async {
    PlantedByData = await ApiService.getUsersDropdown();
    PlantedByDropdown = PlantedByData.map((user) => user['full_name'] as String).toList()..sort();
  }

  // Get planted by user ID by name
  int? getPlantedByUserId(String? fullName) {
    if (fullName == null) return null;
    final found = PlantedByData.firstWhere(
      (item) => item['full_name'] == fullName,
      orElse: () => <String, dynamic>{},
    );
    return found['user_id'] as int?;
  }

  // Zone Number
  List<String> ZoneDropdown = []; // Display names for dropdown
  List<Map<String, dynamic>> ZoneData = []; // Full data for ID lookup
  String? selectedZone;
  FormFieldController<String>? ZoneDropdownController;

  // Fetch Zone Number dropdown 
  Future<void> loadZoneNumberDropdown() async {
    ZoneData = await ApiService.getZonesDropdown();
    ZoneDropdown = ZoneData.map((zone) => zone['zone_number'] as String).toList()..sort();
  }

  // Get zone ID by zone number
  int? getZoneId(String? zoneNumber) {
    if (zoneNumber == null) return null;
    final found = ZoneData.firstWhere(
      (item) => item['zone_number'] == zoneNumber,
      orElse: () => <String, dynamic>{},
    );
    return found['zone_id'] as int?;
  }

  // Container Type
  List<String> ContainerTypeDropdown = []; // Display names for dropdown
  List<Map<String, dynamic>> ContainerTypeData = []; // Full data for ID lookup
  String? selectedContainerType;
  FormFieldController<String>? ContainerTypeDropdownController;

  // Fetch Container Type dropdown 
  Future<void> loadContainerTypeDropdown() async {
    ContainerTypeData = await ApiService.getContainersDropdown();
    ContainerTypeDropdown = ContainerTypeData.map((container) => container['container_type'] as String).toList()..sort();
  }

  // Get container type ID by container type name
  int? getContainerTypeId(String? containerType) {
    if (containerType == null) return null;
    final found = ContainerTypeData.firstWhere(
      (item) => item['container_type'] == containerType,
      orElse: () => <String, dynamic>{},
    );
    return found['container_type_id'] as int?;
  }

  // Removal Causes
  List<String> RemovalCausesDropdown = []; // Display names for dropdown
  List<Map<String, dynamic>> RemovalCausesData = []; // Full data for ID lookup
  String? selectedRemovalCause;
  FormFieldController<String>? removalCausesDropdownController;

  // Fetch Removal Causes dropdown 
  Future<void> loadRemovalCausesDropdown() async {
    RemovalCausesData = await ApiService.getRemovalCausesDropdown();
    RemovalCausesDropdown = RemovalCausesData.map((cause) => cause['cause'] as String).toList()..sort();
  }

  // Get removal cause ID by cause name
  int? getRemovalCauseId(String? causeName) {
    if (causeName == null) return null;
    final found = RemovalCausesData.firstWhere(
      (item) => item['cause'] == causeName,
      orElse: () => <String, dynamic>{},
    );
    return found['removal_cause_id'] as int?;
  }

  // Legacy properties for backward compatibility with existing UI
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;
  String? dropDownValue2;  
  FormFieldController<String>? dropDownValueController2;

  // Comments
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;

  @override
  void initState(BuildContext context) {
    PlantedByComboController = SingleValueDropDownController();
    ZoneComboController = SingleValueDropDownController();
    ContainerTypeComboController = SingleValueDropDownController();
    VarietiesComboController = SingleValueDropDownController();
    GeneticSourcesComboController = SingleValueDropDownController();
    RemovalCausesComboController = SingleValueDropDownController();
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();
  }
}
