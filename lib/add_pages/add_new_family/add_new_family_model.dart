import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'add_new_family_widget.dart' show AddNewFamilyWidget;
import 'package:flutter/material.dart';
import '/backend/api_service.dart'; 
import 'package:dropdown_textfield/dropdown_textfield.dart';

class AddNewFamilyModel extends FlutterFlowModel<AddNewFamilyWidget> {
  ///  Dropdown combo contoller state
  late final SingleValueDropDownController PropagationTypeComboController;
  /// late final SingleValueDropDownController BreedingTeamComboController; To be implemnted
  late final SingleValueDropDownController ProvenanceLocationComboController;

  // Creation Date
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  
  // Family ID 
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;

  // Propagation Type
  List<String> PropagationTypeDropdown = []; // Holds list of propagation types to show in dropdown
  String? selectedPropagationType; // Stores currently selected propagation type
  FormFieldController<String>? PropagationTypeDropdownController; // Manage state of propagation type dropdown

  // Fetch Propagation Type dropdown 
  Future<void> loadPropagationTypeDropdown() async {
    final rawList = await ApiService.getPropagationTypeDropdown();
    PropagationTypeDropdown = rawList.toSet().toList()..sort();
  }

  // Generation Number 
  String? dropDownValue3;
  FormFieldController<String>? dropDownValueController3;

  // Female Parent
  String? dropDownValue4;
  FormFieldController<String>? dropDownValueController4;

  // Male Parent
  String? dropDownValue5;
  FormFieldController<String>? dropDownValueController5;

  // Species + variety
  String? dropDownValue6;
  FormFieldController<String>? dropDownValueController6;

  // Breeding Team - Missing data (implementation unable to be implemented yet)
  String? dropDownValue7;
  FormFieldController<String>? dropDownValueController7;

  // Lot number
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  // Weight
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;

  // Viability
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;

  // Show research notes
  bool? checkboxValue1;

  // Provenances 
  List<String> ProvenanceLocationDropdown = []; // Holds list of provenances to show in dropdown
  String? selectedProvenanceLocation; // Stores currently selected provenance
  FormFieldController<String>? ProvenanceLocationDropdownController; // Manage state of provenance dropdown

  // Fetch Provenance Location dropdown 
  Future<void> loadProvenanceLocationDropdown() async {
    final rawList = await ApiService.getProvenanceLocationDropdown();
    ProvenanceLocationDropdown = rawList.toSet().toList()..sort();
  }

  // Landscape only
  bool? checkboxValue2;

  @override
  void initState(BuildContext context) {
    PropagationTypeComboController = SingleValueDropDownController();
    ProvenanceLocationComboController = SingleValueDropDownController();
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
  }
}
