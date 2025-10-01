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
  List<String> BioregionDropdown = []; // Holds list of genus to show in dropdown
  String? selectedBioregion; // Stores the current selected genus
  FormFieldController<String>? BioregionDropdownController; // Manage state of genus dropdown form field

  // Fetch Bioregion dropdown 
  Future<void> loadBioregionDropdown() async {
    final rawList = await ApiService.getProvenanceBioregionDropdown();
    BioregionDropdown = rawList.toSet().toList()..sort();
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
