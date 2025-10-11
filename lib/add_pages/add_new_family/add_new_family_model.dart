import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'add_new_family_widget.dart' show AddNewFamilyWidget;
import 'package:flutter/material.dart';
import '/backend/api_service.dart'; 
import 'package:dropdown_textfield/dropdown_textfield.dart';





class AddNewFamilyModel extends FlutterFlowModel<AddNewFamilyWidget> {
  
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
  bool? checkboxValue1;

  List<Map<String, dynamic>> speciesVarietyDropdown = [];
  int? selectedSpeciesVarietyId;
  String? selectedSpeciesVarietyName;
  FormFieldController<String>? speciesVarietyDropdownController;

  List<Map<String, dynamic>> propagationTypeDropdown = [];
  int? selectedPropagationTypeId;
  String? selectedPropagationTypeName;
  FormFieldController<String>? propagationTypeDropdownController;

  List<Map<String, dynamic>> generationNumberDropdown = [];
  int? selectedGenerationNumber;
  FormFieldController<String>? generationNumberDropdownController;

  List<Map<String, dynamic>> femaleParentDropdown = [];
  int? selectedFemaleParentId;
  String? selectedFemaleParentName;
  FormFieldController<String>? femaleParentDropdownController;

  List<Map<String, dynamic>> maleParentDropdown = [];
  int? selectedMaleParentId;
  String? selectedMaleParentName;
  FormFieldController<String>? maleParentDropdownController;

  List<Map<String, dynamic>> breedingTeamDropdown = [];
  int? selectedBreedingTeamId;
  String? selectedBreedingTeamName;
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
    propagationTypeDropdown = rawList;
  }

  Future<void> loadGenerationNumberDropdown() async {
    final rawList = await ApiService.getGenerationNumberDropdown();
    generationNumberDropdown = rawList;
  }

  Future<void> loadFemaleParentDropdown() async {
    final rawList = await ApiService.getFemaleParentDropdown();
    femaleParentDropdown = rawList;
  }

  Future<void> loadMaleParentDropdown() async {
    final rawList = await ApiService.getMaleParentDropdown();
    maleParentDropdown = rawList;
  }

  Future<void> loadBreedingTeamDropdown() async {
    final rawList = await ApiService.getBreedingTeamDropdown();
    breedingTeamDropdown = rawList;
  }
 
  // Save method for POST request
  Future<void> saveFamily() async {
    // Validate required fields
    if (selectedPropagationTypeId == null) {
      throw Exception('Please select a propagation type');
    }
    if (selectedFemaleParentId == null) {
      throw Exception('Please select a female parent');
    }
    if (selectedBreedingTeamId == null) {
      throw Exception('Please select a breeding team');
    }

    await ApiService.createFamily(
      creationDate: textController1!.text,
      familyId: textController2?.text,
      propagationTypeId: selectedPropagationTypeId,
      generationNumber: selectedGenerationNumber ?? 0,
      femaleParentId: selectedFemaleParentId,
      maleParentId: selectedMaleParentId,
      varietyId: selectedSpeciesVarietyId,
      breedingTeamId: selectedBreedingTeamId,
      lotNumber: textController3!.text,
      weight: int.tryParse(textController4?.text ?? ''),
      viability: int.tryParse(textController5?.text ?? ''),
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
  // provenanceLocationComboController removed
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
  // provenanceLocationComboController.dispose() removed
  }
}
