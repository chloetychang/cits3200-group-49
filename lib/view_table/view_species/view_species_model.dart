import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/backend/api_service.dart'; // use our API service
import 'view_species_widget.dart' show ViewSpeciesWidget;
import 'package:flutter/material.dart';

class ViewSpeciesModel extends FlutterFlowModel<ViewSpeciesWidget> {
  /// DataTable controller (rows are simple maps: {'species': ..., 'variety': ...})
  final paginatedDataTableController =
      FlutterFlowDataTableController<Map<String, dynamic>>();

  /// Page data & state
  List<Map<String, dynamic>> rows = [];
  bool isLoading = false;
  String? error;

  /// Fetch species + varieties from FastAPI
  Future<void> fetch() async {
    isLoading = true;
    error = null;
    try {
      rows = await ApiService.getView_Species();
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
