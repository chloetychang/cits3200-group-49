import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'm_provenance_location_types_widget.dart'
    show MProvenanceLocationTypesWidget;
import 'package:flutter/material.dart';

class MProvenanceLocationTypesModel
    extends FlutterFlowModel<MProvenanceLocationTypesWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController =
      FlutterFlowDataTableController<ZonesStruct>();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    paginatedDataTableController.dispose();
  }
}
