import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'add_provenances_widget.dart' show AddProvenancesWidget;
import 'package:flutter/material.dart';

import '/backend/api_service.dart'; // use our API service 
import 'package:dropdown_textfield/dropdown_textfield.dart';

class AddProvenancesModel extends FlutterFlowModel<AddProvenancesWidget> {

  ///  Dropdown combo contoller state
  late final SingleValueDropDownController BioregionComboController;

  // 1) Bioregion element
  List<String> BioregionDropdown = []; // Holds list of bioregion to show in dropdown
  String? selectedBioregion; // Stores the current selected bioregion
  FormFieldController<String>? BioregionDropdownController; // Manage state of bioregion dropdown form field

  // Fetch Bioregion dropdown 
  Future<void> loadBioregionDropdown() async {
    final rawList = await ApiService.getProvenanceBioregionDropdown();
    BioregionDropdown = rawList.toSet().toList()..sort();
  }

  // 1a) Location Type element
  List<String> LocationTypeDropdown = []; // Holds list of location types to show in dropdown
  List<Map<String, dynamic>> LocationTypeData = []; // Holds full location type data for ID lookup
  String? selectedLocationType; // Stores the current selected location type
  FormFieldController<String>? LocationTypeDropdownController; // Manage state of location type dropdown form field

  // Fetch Location Type dropdown 
  Future<void> loadLocationTypeDropdown() async {
    final rawList = await ApiService.getLocationTypeDropdown();
    LocationTypeDropdown = rawList.toSet().toList()..sort();
    
    // Also load full data for ID lookup
    LocationTypeData = await ApiService.getLocationTypeDropdownFull();
  }

  // Get location type ID by name
  int? getLocationTypeId(String? locationTypeName) {
    if (locationTypeName == null) return null;
    final found = LocationTypeData.firstWhere(
      (item) => item['location_type'] == locationTypeName,
      orElse: () => <String, dynamic>{},
    );
    return found['location_type_id'] as int?;
  }

  // Validate form
  String? validateForm() {
    final locationName = textController1?.text?.trim();
    if (locationName == null || locationName.isEmpty) {
      return 'Location name is required';
    }
    return null; // Form is valid
  }

  // Save provenance
  Future<Map<String, dynamic>?> saveProvenance() async {
    try {
      final validationError = validateForm();
      if (validationError != null) {
        throw Exception(validationError);
      }

      final locationName = textController1!.text.trim();
      final locationTypeId = getLocationTypeId(selectedLocationType);
      final extraDetails = textController2?.text?.trim();
      
      final result = await ApiService.createProvenance(
        location: locationName,
        bioregionCode: selectedBioregion,
        locationTypeId: locationTypeId,
        extraDetails: extraDetails?.isNotEmpty == true ? extraDetails : null,
      );
      
      return result;
    } catch (e) {
      print('Error saving provenance: $e');
      rethrow;
    }
  }

  // Load all dropdowns
  Future<void> loadAllDropdowns() async {
    await Future.wait([
      loadBioregionDropdown(),
      loadLocationTypeDropdown(),
    ]);
  }

  // 2) Location Name
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;

  // 3) Location Type
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;

  // 4) Extra Details
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  @override
  void initState(BuildContext context) {
    BioregionComboController = SingleValueDropDownController();
  }

  @override
  void dispose() {

    BioregionComboController.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
