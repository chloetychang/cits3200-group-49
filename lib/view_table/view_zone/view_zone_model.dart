import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/backend/api_service.dart';
import 'view_zone_widget.dart' show ViewZoneWidget;
import 'package:flutter/material.dart';

class ViewZoneModel extends FlutterFlowModel<ViewZoneWidget> {
  final paginatedDataTableController =
      FlutterFlowDataTableController<Map<String, dynamic>>();

  List<Map<String, dynamic>> rows = [];
  bool isLoading = false;
  String? error;

  Future<void> fetch() async {
    isLoading = true;
    error = null;
    try {
      final data = await ApiService.getView_Zones(); 
      rows = data.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
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
