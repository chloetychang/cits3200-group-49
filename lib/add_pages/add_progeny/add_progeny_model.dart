import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'add_progeny_widget.dart' show AddProgenyWidget;
import 'package:flutter/material.dart';
import '/backend/api_service.dart'; 
import 'package:dropdown_textfield/dropdown_textfield.dart';

class AddProgenyModel extends FlutterFlowModel<AddProgenyWidget> {
  ///  Dropdown combo contoller state
  late final SingleValueDropDownController FamilyNameComboController;

  // Family Name 
  List<String> FamilyNameDropdown = []; // Holds list of family names to show in dropdown
  String? selectedFamilyName; // Stores currently selected family name
  FormFieldController<String>? FamilyNameDropdownController; // Manage state of family name dropdown

  // Fetch Family Name dropdown 
  Future<void> loadFamilyNameDropdown() async {
    final rawList = await ApiService.getFamilyNameDropdown();
    FamilyNameDropdown = rawList.toSet().toList()..sort();
  }

  // Date Germinated
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  
  // Sibling Number
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  // Child Name
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;

  // Research Notes
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;

  @override
  void initState(BuildContext context) {
    FamilyNameComboController = SingleValueDropDownController();
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
