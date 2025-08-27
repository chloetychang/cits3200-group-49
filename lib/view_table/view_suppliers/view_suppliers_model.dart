import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'view_suppliers_widget.dart' show ViewSuppliersWidget;
import 'package:flutter/material.dart';

class ViewSuppliersModel extends FlutterFlowModel<ViewSuppliersWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController =
      FlutterFlowDataTableController<ZonesStruct>();
  // State field(s) for Checkbox widget.
  Map<ZonesStruct, bool> checkboxValueMap = {};
  List<ZonesStruct> get checkboxCheckedItems =>
      checkboxValueMap.entries.where((e) => e.value).map((e) => e.key).toList();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    paginatedDataTableController.dispose();
  }
}
