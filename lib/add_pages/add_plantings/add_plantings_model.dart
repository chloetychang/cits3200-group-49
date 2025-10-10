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

  // Species Selection Radio Button Group
  String? speciesSelectionRadioValue;

  // Date Planted
  DateTime? selectedDatePlanted;
  
  // Initialize date to today
  void initializeDatePlanted() {
    selectedDatePlanted = DateTime.now();
  }

  // Number Planted
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  // Genetic Sources
  List<String> GeneticSourcesDropdown = []; // Display names for dropdown
  List<Map<String, dynamic>> GeneticSourcesData = []; // Full data for ID lookup
  String? selectedGeneticSource;
  FormFieldController<String>? geneticSourcesDropdownController;

  // Fetch Genetic Sources dropdown (simplified - no pagination)
  Future<void> loadGeneticSourcesDropdown() async {
    GeneticSourcesData = await ApiService.getGeneticSourcesDropdown();
    // Use the pre-formatted display text from the API
    GeneticSourcesDropdown = GeneticSourcesData.map((gs) {
      return gs['display_text']?.toString() ?? 'Unknown Genetic Source';
    }).toList()..sort();
  }

  // Get genetic source ID by display name
  int? getGeneticSourceId(String? displayName) {
    if (displayName == null) return null;
    // Find the genetic source data that matches the display text
    final found = GeneticSourcesData.firstWhere(
      (gs) => gs['display_text']?.toString() == displayName,
      orElse: () => <String, dynamic>{},
    );
    return found['genetic_source_id'] as int?;
  }

  // Varieties with Species
  List<String> VarietiesDropdown = []; // Display names for dropdown
  List<Map<String, dynamic>> VarietiesData = []; // Full data for ID lookup
  String? selectedVariety;
  FormFieldController<String>? varietiesDropdownController;

  // Fetch Varieties with Species dropdown (simplified - no pagination)
  Future<void> loadVarietiesDropdown() async {
    final rawList = await ApiService.getPlantingVarietiesWithSpeciesDropdown();
    VarietiesData = rawList;
    // Create display names combining full species name and variety
    VarietiesDropdown = rawList.map((variety) => 
      "${variety['full_species_name']} - ${variety['variety']}"
    ).toList()..sort();
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

  // Helper methods for controlling dropdown visibility and behavior
  bool get isGeneticSourcesSelected => speciesSelectionRadioValue == 'genetic_sources';
  bool get isExistingPlantingsSelected => speciesSelectionRadioValue == 'existing_plantings';
  bool get isAllSpeciesSelected => speciesSelectionRadioValue == 'all_species';

  // Method to auto-fill species+variety from selected genetic source
  void autoFillSpeciesVarietyFromGeneticSource(String? geneticSourceDisplayName) {
    if (geneticSourceDisplayName == null) {
      selectedVariety = null;
      return;
    }

    // Find the genetic source data
    final geneticSourceData = GeneticSourcesData.firstWhere(
      (gs) => gs['display_text']?.toString() == geneticSourceDisplayName,
      orElse: () => <String, dynamic>{},
    );

    if (geneticSourceData.isNotEmpty) {
      final speciesName = geneticSourceData['species_name']?.toString() ?? '';
      final varietyName = geneticSourceData['variety_name']?.toString() ?? '';
      
      if (speciesName.isNotEmpty && varietyName.isNotEmpty) {
        // Set the species+variety dropdown to match the genetic source
        final combinedName = '$speciesName - $varietyName';
        selectedVariety = combinedName;
        
        // Make sure this value exists in the varieties dropdown
        if (!VarietiesDropdown.contains(combinedName)) {
          VarietiesDropdown.insert(0, combinedName);
        }
      }
    }
  }

  @override
  void initState(BuildContext context) {
    PlantedByComboController = SingleValueDropDownController();
    ZoneComboController = SingleValueDropDownController();
    ContainerTypeComboController = SingleValueDropDownController();
    VarietiesComboController = SingleValueDropDownController();
    GeneticSourcesComboController = SingleValueDropDownController();
    RemovalCausesComboController = SingleValueDropDownController();
    
    // Initialize radio button selection to genetic sources by default
    speciesSelectionRadioValue = 'genetic_sources';
    
    // Initialize date to today
    initializeDatePlanted();
  }

  @override
  void dispose() {
    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();
  }
}
