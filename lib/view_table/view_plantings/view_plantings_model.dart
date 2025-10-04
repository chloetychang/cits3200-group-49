import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'view_plantings_widget.dart' show ViewPlantingsWidget;
import 'package:flutter/material.dart';

class ViewPlantingsModel extends FlutterFlowModel<ViewPlantingsWidget> {
  final paginatedDataTableController =
      FlutterFlowDataTableController<Map<String, dynamic>>();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    paginatedDataTableController.dispose();
  }
}
