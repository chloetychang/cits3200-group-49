import '/flutter_flow/flutter_flow_util.dart';
import 'package:intl/intl.dart';
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

  // Generation Number DropDown widget
  List<int> generationNumberDropdown = [];
  int? selectedGenerationNumber;
  FormFieldController<int>? generationNumberDropdownController;

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
  TextEditingController? textController4; // Weight (optional, double)
  String? Function(BuildContext, String?)? textController4Validator;

  FocusNode? textFieldFocusNode5;
  TextEditingController? textController5; // Viability (optional, int)
  String? Function(BuildContext, String?)? textController5Validator;

  FocusNode? textFieldFocusNode6;
  TextEditingController? textController6; // Research Notes (optional, String)
  String? Function(BuildContext, String?)? textController6Validator;


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
    generationNumberDropdown = await ApiService.getGenerationNumberDropdown();
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
      acquisitionDate: textController1!.text,
      supplierLotNumber: textController2 != null ? textController2!.text : '',
      supplierId: 1, // TODO: Set to 1 for now; update to dynamic value when supplier selection is implemented
      femaleGeneticSource: selectedFemaleParentId!,
      propagationType: selectedPropagationTypeId!,
      generationNumber: selectedGenerationNumber ?? 0,
      maleGeneticSource: selectedMaleParentId,
      varietyId: selectedSpeciesVarietyId ?? 1,
      landscapeOnly: false,
      gramWeight: textController3 != null && textController3!.text.isNotEmpty ? int.tryParse(textController3!.text) : null,
      viability: textController4 != null && textController4!.text.isNotEmpty ? int.tryParse(textController4!.text) : null,
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

  final now = DateTime.now();
  final formatted = DateFormat('yyyy-MM-dd HH:mm').format(now);
  textController1 = TextEditingController(text: formatted);
  textController4 = TextEditingController();
  textController5 = TextEditingController();
  textController6 = TextEditingController();
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
    textFieldFocusNode6?.dispose();
    textController6?.dispose();
    speciesVarietyComboController.dispose();
    propagationTypeComboController.dispose();
    generationNumberComboController.dispose();
    femaleParentComboController.dispose();
    maleParentComboController.dispose();
    breedingTeamComboController.dispose();
  // provenanceLocationComboController.dispose() removed
  }
}
