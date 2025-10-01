import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'manage_species_utility_widget.dart'
    show ManageSpeciesUtilityWidget;

class ManageSpeciesUtilityModel
    extends FlutterFlowModel<ManageSpeciesUtilityWidget> {
  /// State for species_utility_link table
  final speciesUtilityTableController =
      FlutterFlowDataTableController<SpeciesUtilityLinkRow>();

  List<SpeciesUtilityLinkRow> rows = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    speciesUtilityTableController.dispose();
  }
}

// ---------- Data model for species_utility_link ----------
class SpeciesUtilityLinkRow {
  final String localKey; // 本地唯一 key
  int speciesId;
  int plantUtilityId;

  SpeciesUtilityLinkRow({
    required this.localKey,
    required this.speciesId,
    required this.plantUtilityId,
  });

  factory SpeciesUtilityLinkRow.fromJson(Map<String, dynamic> json) {
    return SpeciesUtilityLinkRow(
      localKey: "${json['species_id']}_${json['plant_utility_id']}", // 组合 key
      speciesId: json['species_id'] as int,
      plantUtilityId: json['plant_utility_id'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'species_id': speciesId,
        'plant_utility_id': plantUtilityId,
      };
}

