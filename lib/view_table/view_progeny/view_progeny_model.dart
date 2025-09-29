import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/backend/api_service.dart';
import 'view_progeny_widget.dart' show ViewProgenyWidget;
import 'package:flutter/material.dart';

class ViewProgenyModel extends FlutterFlowModel<ViewProgenyWidget> {
  final paginatedDataTableController =
      FlutterFlowDataTableController<Map<String, dynamic>>();

  List<Map<String, dynamic>> rows = [];
  bool isLoading = false;
  String? error;

  Future<void> fetch() async {
    isLoading = true;
    error = null;
    try {
      rows = await ApiService.getView_Progeny();
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
