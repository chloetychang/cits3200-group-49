import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'manage_planting_removal_widget.dart'
    show ManagePlantingRemovalWidget;
import 'package:flutter/material.dart';

class ManagePlantingRemovalModel
    extends FlutterFlowModel<ManagePlantingRemovalWidget> {
  /// State fields for stateful widgets in this page.

  // Controller and data for Removal Cause table
  final removalCauseTableController =
      FlutterFlowDataTableController<RemovalCauseRow>();
  List<RemovalCauseRow> removalCauseRows = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    removalCauseTableController.dispose();
  }
}

/// ---------- Data model for one table row (Removal Cause) ----------
class RemovalCauseRow {
  final int id;        // removal_cause_id
  String cause;        // cause

  RemovalCauseRow({
    required this.id,
    required this.cause,
  });

  factory RemovalCauseRow.fromJson(Map<String, dynamic> json) {
    return RemovalCauseRow(
      id: json['removal_cause_id'] as int,
      cause: (json['cause'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'removal_cause_id': id,
        'cause': cause,
      };

  RemovalCauseRow copyWith({int? id, String? cause}) {
    return RemovalCauseRow(
      id: id ?? this.id,
      cause: cause ?? this.cause,
    );
  }
}
