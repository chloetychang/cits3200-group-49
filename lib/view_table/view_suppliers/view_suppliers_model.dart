import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'view_suppliers_widget.dart' show ViewSuppliersWidget;
import 'package:flutter/material.dart';

class ViewSuppliersModel extends FlutterFlowModel<ViewSuppliersWidget> {
  /// State fields for stateful widgets in this page.

  // 用 dynamic 保持和 JSON 兼容
  final paginatedDataTableController =
      FlutterFlowDataTableController<dynamic>();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    paginatedDataTableController.dispose();
  }
}
