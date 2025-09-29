import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/backend/api_service.dart';
import 'view_provenances_widget.dart' show ViewProvenancesWidget;
import 'package:flutter/material.dart';

class ViewProvenancesModel extends FlutterFlowModel<ViewProvenancesWidget> {
  final paginatedDataTableController =
      FlutterFlowDataTableController<Map<String, dynamic>>();

  List<Map<String, dynamic>> rows = [];
  bool isLoading = false;
  String? error;

  Future<void> fetch() async {
    isLoading = true;
    error = null;
    try {
      rows = (await ApiService.getView_Provenances()).cast<Map<String, dynamic>>();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    paginatedDataTableController.dispose();
  }
}
