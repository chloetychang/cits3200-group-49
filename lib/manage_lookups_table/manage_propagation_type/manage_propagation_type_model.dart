import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'manage_propagation_type_widget.dart' show ManagePropagationTypeWidget;

class ManagePropagationTypeModel
    extends FlutterFlowModel<ManagePropagationTypeWidget> {
  /// State for propagation_type table
  final propagationTypeTableController =
      FlutterFlowDataTableController<PropagationTypeRow>();

  List<PropagationTypeRow> propagationTypeRows = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    propagationTypeTableController.dispose();
  }
}

// ---------- Data model for propagation_type ----------
class PropagationTypeRow {
  final int id;
  String propagationType;
  bool needsTwoParents;
  bool canCrossGenera;

  PropagationTypeRow({
    required this.id,
    required this.propagationType,
    this.needsTwoParents = false,
    this.canCrossGenera = false,
  });

  factory PropagationTypeRow.fromJson(Map<String, dynamic> json) {
    return PropagationTypeRow(
      id: json['propagation_type_id'] as int,
      propagationType: (json['propagation_type'] ?? '').toString(),
      needsTwoParents: json['needs_two_parents'] ?? false,
      canCrossGenera: json['can_cross_genera'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'propagation_type_id': id,
        'propagation_type': propagationType,
        'needs_two_parents': needsTwoParents,
        'can_cross_genera': canCrossGenera,
      };
}
