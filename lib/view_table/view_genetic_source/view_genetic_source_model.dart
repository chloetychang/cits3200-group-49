import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'view_genetic_source_widget.dart' show ViewGeneticSourceWidget;
import 'package:flutter/material.dart';

class ViewGeneticSourceModel extends FlutterFlowModel<ViewGeneticSourceWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController =
      FlutterFlowDataTableController<Map<String, dynamic>>();

  // State field(s) for Checkbox widget.
  Map<Map<String, dynamic>, bool> checkboxValueMap = {};
  List<Map<String, dynamic>> get checkboxCheckedItems =>
      checkboxValueMap.entries.where((e) => e.value).map((e) => e.key).toList();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    paginatedDataTableController.dispose();
  }
}
