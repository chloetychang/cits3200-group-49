import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'manage_propagation_type_widget.dart' show ManagePropagationTypeWidget;
import 'package:flutter/material.dart';

class ManagePropagationTypeModel
    extends FlutterFlowModel<ManagePropagationTypeWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController =
      FlutterFlowDataTableController<ZonesStruct>();
  // State field(s) for Checkbox widget.
  Map<ZonesStruct, bool> checkboxValueMap1 = {};
  List<ZonesStruct> get checkboxCheckedItems1 => checkboxValueMap1.entries
      .where((e) => e.value)
      .map((e) => e.key)
      .toList();

  // State field(s) for Checkbox widget.
  Map<ZonesStruct, bool> checkboxValueMap2 = {};
  List<ZonesStruct> get checkboxCheckedItems2 => checkboxValueMap2.entries
      .where((e) => e.value)
      .map((e) => e.key)
      .toList();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    paginatedDataTableController.dispose();
  }
}
