import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'manage_provenance_location_types_widget.dart'
    show ManageProvenanceLocationTypesWidget;

class ManageProvenanceLocationTypesModel
    extends FlutterFlowModel<ManageProvenanceLocationTypesWidget> {
  /// State for location_type table
  final locationTypeTableController =
      FlutterFlowDataTableController<P_LocationTypeRow>();

  List<P_LocationTypeRow> locationTypeRows = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    locationTypeTableController.dispose();
  }
}

// ---------- Data model for location_type ----------
class P_LocationTypeRow {
  final int id;
  String locationType;

  P_LocationTypeRow({
    required this.id,
    required this.locationType,
  });

  factory P_LocationTypeRow.fromJson(Map<String, dynamic> json) {
    return P_LocationTypeRow(
      id: json['location_type_id'] as int,
      locationType: (json['location_type'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'location_type_id': id,
        'location_type': locationType,
      };
}
