import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'manage_conservation_status_widget.dart'
    show ManageConservationStatusWidget;
import 'package:flutter/material.dart';

class ManageConservationStatusModel
    extends FlutterFlowModel<ManageConservationStatusWidget> {
  ///  State fields for stateful widgets in this page.

  // Controller and data for Conservation Status table (added)
  final statusTableController = FlutterFlowDataTableController<ConservationStatusRow>();
  List<ConservationStatusRow> statusRows = [];
  bool isLoading = false;
  String? errorMessage;


  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController =
      FlutterFlowDataTableController<SubZonesStruct>();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    paginatedDataTableController.dispose();
  }
}


// ---------- Data model for one table row (Conservation Status) ----------
// This model maps backend fields to UI-friendly names.
class ConservationStatusRow {
  final int id;               // conservation_status_id
  String status;              // status
  String shortName;           // status_short_name

  ConservationStatusRow({
    required this.id,
    required this.status,
    required this.shortName,
  });

  factory ConservationStatusRow.fromJson(Map<String, dynamic> json) {
    return ConservationStatusRow(
      id: json['conservation_status_id'] as int,
      status: (json['status'] ?? '').toString(),
      shortName: (json['status_short_name'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'conservation_status_id': id,
    'status': status,
    'status_short_name': shortName,
  };

  ConservationStatusRow copyWith({int? id, String? status, String? shortName}) {
    return ConservationStatusRow(
      id: id ?? this.id,
      status: status ?? this.status,
      shortName: shortName ?? this.shortName,
    );
  }
}

