import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'add_plantings_widget.dart' show AddPlantingsWidget;
import 'package:flutter/material.dart';
import '/backend/api_service.dart'; 
import 'package:dropdown_textfield/dropdown_textfield.dart';

class AddPlantingsModel extends FlutterFlowModel<AddPlantingsWidget> {
  ///  Dropdown combo contoller state
  late final SingleValueDropDownController PlantedByComboController;
  late final SingleValueDropDownController ZoneComboController;
  late final SingleValueDropDownController ContainerTypeComboController;

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

  // Genetic Source - TBC currently not implemented due to missing data
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;

  // Species + Variety
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;

  // Planted By
  List<String> PlantedByDropdown = []; // Holds list of planted by to show in dropdown
  String? selectedPlantedBy; // Stores currently planted by selection
  FormFieldController<String>? plantedByDropdownController; // Manage state of planted by dropdown

  // Fetch Planted By dropdown 
  Future<void> loadPlantedByDropdown() async {
    final rawList = await ApiService.getPlantedByDropdown();
    PlantedByDropdown = rawList.toSet().toList()..sort();
  }

  // Zone Number
  List<String> ZoneDropdown = []; // Holds list of zones to show in dropdown
  String? selectedZone; // Stores currently selected zone
  FormFieldController<String>? ZoneDropdownController; // Manage state of zone dropdown

  // Fetch Zone Number dropdown 
  Future<void> loadZoneNumberDropdown() async {
    final rawList = await ApiService.getZoneNumberDropdown();
    ZoneDropdown = rawList.toSet().toList()..sort();
  }

  // Container Type
  List<String> ContainerTypeDropdown = []; // Holds list of container types to show in dropdown
  String? selectedContainerType; // Stores currently selected container type
  FormFieldController<String>? ContainerTypeDropdownController; // Manage state of container type dropdown

  // Fetch Container Type dropdown 
  Future<void> loadContainerTypeDropdown() async {
    final rawList = await ApiService.getContainerTypeDropdown();
    ContainerTypeDropdown = rawList.toSet().toList()..sort();
  }

  // Comments
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;

  @override
  void initState(BuildContext context) {
    PlantedByComboController = SingleValueDropDownController();
    ZoneComboController = SingleValueDropDownController();
    ContainerTypeComboController = SingleValueDropDownController();
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
