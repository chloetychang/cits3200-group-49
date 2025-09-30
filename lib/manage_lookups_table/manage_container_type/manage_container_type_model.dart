import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'manage_container_type_widget.dart'
    show ManageContainerTypeWidget;
import 'package:flutter/material.dart';

class ManageContainerTypeModel
    extends FlutterFlowModel<ManageContainerTypeWidget> {
  ///  State fields for stateful widgets in this page.

  // Controller and data for Container Type table (added)
  final containerTypeTableController = FlutterFlowDataTableController<ContainerTypeRow>();
  List<ContainerTypeRow> containerTypeRows = [];
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

// ---------- Data model for one table row (Container Type) ----------
// This model maps backend fields to UI-friendly names.
class ContainerTypeRow {
  final int id;               // container_type_id
  String containerType;       // container_type

  ContainerTypeRow({
    required this.id,
    required this.containerType,
  });

  factory ContainerTypeRow.fromJson(Map<String, dynamic> json) {
    return ContainerTypeRow(
      id: json['container_type_id'] as int,
      containerType: (json['container_type'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'container_type_id': id,
    'container_type': containerType,
  };

  ContainerTypeRow copyWith({int? id, String? containerType}) {
    return ContainerTypeRow(
      id: id ?? this.id,
      containerType: containerType ?? this.containerType,
    );
  }
}
