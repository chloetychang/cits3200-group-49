import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'form_update_species_widget.dart' show FormUpdateSpeciesWidget;
import 'package:flutter/material.dart';
import '/backend/api_service.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class FormUpdateSpeciesModel extends FlutterFlowModel<FormUpdateSpeciesWidget> {
  ///  State fields for stateful widgets in this page.
  late final SingleValueDropDownController genusComboController;

  // Genus DropDown widget.
  List<String> genusDropdown = []; // Holds list of genus to show in dropdown
  String? selectedGenus; // Stores the current selected genus
  FormFieldController<String>? genusDropdownController; // Manage state of genus dropdown form field

  // Fetch Genus Dropdown 
  Future<void> loadGenusDropdown() async {
    final rawList = await ApiService.getGenusDropdown();
    genusDropdown = rawList.toSet().toList()..sort();
  }

  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController =
      FlutterFlowDataTableController<ZonesStruct>();

  @override
  void initState(BuildContext context) {
      genusComboController = SingleValueDropDownController();
  }

  @override
  void dispose() {
    genusComboController.dispose();
    paginatedDataTableController.dispose();
  }
}
