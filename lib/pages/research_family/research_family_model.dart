import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'research_family_widget.dart' show ResearchFamilyWidget;
import 'package:flutter/material.dart';

class ResearchFamilyModel extends FlutterFlowModel<ResearchFamilyWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
