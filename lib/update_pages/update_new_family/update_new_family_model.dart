
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
  late final SingleValueDropDownController provenanceComboController;

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

  List<Map<String, dynamic>> provenanceDropdown = [];
  int? selectedProvenanceId;
  String? selectedProvenanceName;
  FormFieldController<String>? provenanceDropdownController;

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

  Future<void> loadProvenanceDropdown() async {
    final rawList = await ApiService.getProvenancesDropdown();
    provenanceDropdown = rawList;
  }
  // Dropdown for selecting existing genetic source (family) to update
  List<Map<String, dynamic>> geneticSourceDropdown = [];
  int? selectedGeneticSourceId;
  String? selectedGeneticSourceName;
  FormFieldController<String>? geneticSourceDropdownController;

  // Loader for genetic sources dropdown (uses new endpoint for update flow)
  Future<void> loadGeneticSourceDropdown() async {
    final rawList = await ApiService.getGeneticSourcesDropdown();
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

    await ApiService.updateFamily(
      geneticSourceId: selectedGeneticSourceId!,
      acquisitionDate: textController1!.text,
      supplierId: 1, // TODO: Set to 1 for now; update to dynamic value when supplier selection is implemented
      femaleGeneticSource: selectedFemaleParentId!,
      propagationType: selectedPropagationTypeId!,
      generationNumber: selectedGenerationNumber ?? 0,
      maleGeneticSource: selectedMaleParentId,
      varietyId: selectedSpeciesVarietyId ?? 1,
      landscapeOnly: false,
      gramWeight: textController2 != null && textController2!.text.isNotEmpty ? int.tryParse(textController2!.text) : null,
      viability: textController3 != null && textController3!.text.isNotEmpty ? int.tryParse(textController3!.text) : null,
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
    provenanceComboController = SingleValueDropDownController();

    final now = DateTime.now();
    final formatted = DateFormat('yyyy-MM-dd HH:mm').format(now);
    textController1 = TextEditingController(text: formatted);
    textController2 = TextEditingController();
    textController3 = TextEditingController();
    // Add more controllers if needed for other fields (e.g., textController4, etc.)
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();
    textFieldFocusNode2?.dispose();
    textController2?.dispose();
    textFieldFocusNode3?.dispose();
    textController3?.dispose();
    // Dispose additional focus nodes and controllers if added
    speciesVarietyComboController.dispose();
    propagationTypeComboController.dispose();
    generationNumberComboController.dispose();
    femaleParentComboController.dispose();
    maleParentComboController.dispose();
    breedingTeamComboController.dispose();
    provenanceComboController.dispose();
  }
}
