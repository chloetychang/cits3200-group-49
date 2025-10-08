import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'manage_zone_aspect_widget.dart'
    show ManageZoneAspectWidget;
import 'package:flutter/material.dart';

class ManageZoneAspectModel
    extends FlutterFlowModel<ManageZoneAspectWidget> {
  ///  State fields for stateful widgets in this page.

  // Controller and data for Zone Aspect table (added)
  final zoneAspectTableController = FlutterFlowDataTableController<ZoneAspectRow>();
  List<ZoneAspectRow> zoneAspectRows = [];
  bool isLoading = false;
  String? errorMessage;

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

// ---------- Data model for one table row (Zone Aspect) ----------
// This model maps backend fields to UI-friendly names.
class ZoneAspectRow {
  final int id;      // aspect_id
  String aspect;     // aspect

  ZoneAspectRow({
    required this.id,
    required this.aspect,
  });

  factory ZoneAspectRow.fromJson(Map<String, dynamic> json) {
    return ZoneAspectRow(
      id: json['aspect_id'] as int,
      aspect: (json['aspect'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'aspect_id': id,
        'aspect': aspect,
      };

  ZoneAspectRow copyWith({int? id, String? aspect}) {
    return ZoneAspectRow(
      id: id ?? this.id,
      aspect: aspect ?? this.aspect,
    );
  }
}
