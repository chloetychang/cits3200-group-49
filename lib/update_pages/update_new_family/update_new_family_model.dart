
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'update_new_family_widget.dart' show UpdateNewFamilyWidget;
import 'package:flutter/material.dart';
import '/backend/api_service.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class UpdateNewFamilyModel extends FlutterFlowModel<UpdateNewFamilyWidget> {
  late final SingleValueDropDownController geneticSourceComboController = SingleValueDropDownController();
  late final SingleValueDropDownController speciesVarietyComboController;
  late final SingleValueDropDownController propagationTypeComboController;
  late final SingleValueDropDownController generationNumberComboController;
  late final SingleValueDropDownController femaleParentComboController;
  late final SingleValueDropDownController maleParentComboController;
  late final SingleValueDropDownController breedingTeamComboController;

  // Dropdown data
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
  // Dropdown for selecting existing genetic source (family) to update
  List<Map<String, dynamic>> geneticSourceDropdown = [];
  int? selectedGeneticSourceId;
  String? selectedGeneticSourceName;
  FormFieldController<String>? geneticSourceDropdownController;

  // Loader for genetic sources dropdown
  Future<void> loadGeneticSourceDropdown() async {
    final rawList = await ApiService.getView_GeneticSources();
    geneticSourceDropdown = rawList;
  }
  ///  State fields for stateful widgets in this page.

  // State field(s) for DropDown widget.
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for DropDown widget.
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;
  // State field(s) for DropDown widget.
  String? dropDownValue3;
  FormFieldController<String>? dropDownValueController3;
  // State field(s) for DropDown widget.
  String? dropDownValue4;
  FormFieldController<String>? dropDownValueController4;
  // State field(s) for DropDown widget.
  String? dropDownValue5;
  FormFieldController<String>? dropDownValueController5;
  // State field(s) for DropDown widget.
  String? dropDownValue6;
  FormFieldController<String>? dropDownValueController6;
  // State field(s) for DropDown widget.
  String? dropDownValue7;
  FormFieldController<String>? dropDownValueController7;
  // State field(s) for DropDown widget.
  String? dropDownValue8;
  FormFieldController<String>? dropDownValueController8;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // State field(s) for Checkbox widget.
  bool? checkboxValue1;
  // State field(s) for DropDown widget.
  String? dropDownValue9;
  FormFieldController<String>? dropDownValueController9;
  // State field(s) for Checkbox widget.
  bool? checkboxValue2;

  @override
  void initState(BuildContext context) {}

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
