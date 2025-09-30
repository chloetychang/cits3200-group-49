import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'manage_plant_utility_widget.dart'
    show ManagePlantUtilityWidget;
import 'package:flutter/material.dart';

class ManagePlantUtilityModel
    extends FlutterFlowModel<ManagePlantUtilityWidget> {
  ///  State fields for stateful widgets in this page.

  // Controller and data for Plant Utility table
  final plantUtilityTableController =
      FlutterFlowDataTableController<PlantUtilityRow>();
  List<PlantUtilityRow> plantUtilityRows = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    plantUtilityTableController.dispose();
  }
}

// ---------- Data model for one Plant Utility row ----------
class PlantUtilityRow {
  final int id;          // plant_utility_id
  String utility;        // utility

  PlantUtilityRow({
    required this.id,
    required this.utility,
  });

  factory PlantUtilityRow.fromJson(Map<String, dynamic> json) {
    return PlantUtilityRow(
      id: json['plant_utility_id'] as int,
      utility: (json['utility'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'plant_utility_id': id,
        'utility': utility,
      };

  PlantUtilityRow copyWith({int? id, String? utility}) {
    return PlantUtilityRow(
      id: id ?? this.id,
      utility: utility ?? this.utility,
    );
  }
}

