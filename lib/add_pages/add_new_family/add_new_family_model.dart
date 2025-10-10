import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'add_new_family_widget.dart' show AddNewFamilyWidget;
import 'package:flutter/material.dart';
import '/backend/api_service.dart'; 
import 'package:dropdown_textfield/dropdown_textfield.dart';





class AddNewFamilyModel extends FlutterFlowModel<AddNewFamilyWidget> {
  // Additional dropdowns and checkboxes for error fixes
  FormFieldController<String>? dropDownValueController3;
  String? dropDownValue3;
  FormFieldController<String>? dropDownValueController4;
  String? dropDownValue4;
  FormFieldController<String>? dropDownValueController5;
  String? dropDownValue5;
  FormFieldController<String>? dropDownValueController6;
  String? dropDownValue6;
  FormFieldController<String>? dropDownValueController7;
  String? dropDownValue7;
  bool? checkboxValue1;
  bool? checkboxValue2;
  // Provenance Location Dropdown
  late final SingleValueDropDownController provenanceLocationComboController;
  List<Map<String, dynamic>> provenanceLocationDropdown = [];
  Map<String, dynamic>? selectedProvenanceLocation;
  // Dropdown controllers
  late final SingleValueDropDownController speciesVarietyComboController;
  late final SingleValueDropDownController propagationTypeComboController;
  late final SingleValueDropDownController generationNumberComboController;
  late final SingleValueDropDownController femaleParentComboController;
  late final SingleValueDropDownController maleParentComboController;
  late final SingleValueDropDownController breedingTeamComboController;

  // Dropdown data

  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;

  List<Map<String, dynamic>> speciesVarietyDropdown = [];
  Map<String, dynamic>? selectedSpeciesVariety;
  String? selectedSpeciesVarietyDisplay;
  FormFieldController<String>? speciesVarietyDropdownController;

  List<Map<String, dynamic>> propagationTypeDropdown = [];
  Map<String, dynamic>? selectedPropagationType;
  String? selectedPropagationTypeDisplay;
  FormFieldController<String>? propagationTypeDropdownController;

  List<Map<String, dynamic>> generationNumberDropdown = [];
  Map<String, dynamic>? selectedGenerationNumber;
  String? selectedGenerationNumberDisplay;
  FormFieldController<String>? generationNumberDropdownController;

  List<Map<String, dynamic>> femaleParentDropdown = [];
  Map<String, dynamic>? selectedFemaleParent;
  String? selectedFemaleParentDisplay;
  FormFieldController<String>? femaleParentDropdownController;

  List<Map<String, dynamic>> maleParentDropdown = [];
  Map<String, dynamic>? selectedMaleParent;
  String? selectedMaleParentDisplay;
  FormFieldController<String>? maleParentDropdownController;

  List<Map<String, dynamic>> breedingTeamDropdown = [];
  Map<String, dynamic>? selectedBreedingTeam;
  String? selectedBreedingTeamDisplay;
  FormFieldController<String>? breedingTeamDropdownController;

  // Text fields
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1; // Creation date
  String? Function(BuildContext, String?)? textController1Validator;

  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2; // Family ID (optional)
  String? Function(BuildContext, String?)? textController2Validator;

  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3; // Lot number
  String? Function(BuildContext, String?)? textController3Validator;

  // Optional fields
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController4; // Weight (optional)
  String? Function(BuildContext, String?)? textController4Validator;

  FocusNode? textFieldFocusNode5;
  TextEditingController? textController5; // Viability (optional)
  String? Function(BuildContext, String?)? textController5Validator;


  // Loaders for dropdowns (all dynamic)
  Future<void> loadSpeciesVarietyDropdown() async {
    final rawList = await ApiService.getVarietiesWithSpeciesDropdown();
    speciesVarietyDropdown = rawList;
  }

  Future<void> loadPropagationTypeDropdown() async {
    final rawList = await ApiService.getPropagationTypeDropdown();
    propagationTypeDropdown = rawList.map((e) => {'propagation_type': e}).toList();
  }

  Future<void> loadGenerationNumberDropdown() async {
    final rawList = await ApiService.getGenerationNumberDropdown();
    generationNumberDropdown = rawList.map((e) => {'generation_number': e}).toList();
  }

  Future<void> loadFemaleParentDropdown() async {
    final rawList = await ApiService.getFemaleParentDropdown();
    femaleParentDropdown = rawList.map((e) => {'female_parent': e}).toList();
  }

  Future<void> loadMaleParentDropdown() async {
    final rawList = await ApiService.getMaleParentDropdown();
    maleParentDropdown = rawList.map((e) => {'male_parent': e}).toList();
  }

  Future<void> loadBreedingTeamDropdown() async {
    final rawList = await ApiService.getBreedingTeamDropdown();
    breedingTeamDropdown = rawList.map((e) => {'breeding_team': e}).toList();
  }

  // Save method for POST request
  Future<void> saveFamily() async {
    // Validate required fields
    if (textController1?.text == null || textController1!.text.isEmpty) {
      throw Exception('Please enter a creation date');
    }
    if (selectedPropagationType == null) {
      throw Exception('Please select a propagation type');
    }
    if (selectedFemaleParent == null) {
      throw Exception('Please select a female parent');
    }
    if (selectedBreedingTeam == null) {
      throw Exception('Please select a breeding team');
    }
    if (textController3?.text == null || textController3!.text.isEmpty) {
      throw Exception('Please enter a lot number');
    }

    await ApiService.createFamily(
      creationDate: textController1!.text,
      familyId: textController2?.text,
      propagationType: selectedPropagationType?['propagation_type'],
      generationNumber: selectedGenerationNumber?['generation_number'],
      femaleParent: selectedFemaleParent?['female_parent'],
      maleParent: selectedMaleParent?['male_parent'],
      speciesVariety: selectedSpeciesVariety != null ? selectedSpeciesVariety!['variety_id']?.toString() : null,
      breedingTeam: selectedBreedingTeam?['breeding_team'],
      lotNumber: textController3!.text,
      weight: textController4?.text,
      viability: textController5?.text,
    );
  }


  @override
  void initState(BuildContext context) {
    speciesVarietyComboController = SingleValueDropDownController();
    propagationTypeComboController = SingleValueDropDownController();
    generationNumberComboController = SingleValueDropDownController();
    femaleParentComboController = SingleValueDropDownController();
    maleParentComboController = SingleValueDropDownController();
    breedingTeamComboController = SingleValueDropDownController();
  provenanceLocationComboController = SingleValueDropDownController();
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();
    textFieldFocusNode2?.dispose();
    textController2?.dispose();
    textFieldFocusNode3?.dispose();
    textController3?.dispose();
    textFieldFocusNode4?.dispose();
    textController4?.dispose();
    textFieldFocusNode5?.dispose();
    textController5?.dispose();
    speciesVarietyComboController.dispose();
    propagationTypeComboController.dispose();
    generationNumberComboController.dispose();
    femaleParentComboController.dispose();
    maleParentComboController.dispose();
    breedingTeamComboController.dispose();
  provenanceLocationComboController.dispose();
  }
}
