import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/api_service.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'manage_species_utility_model.dart';
export 'manage_species_utility_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class ManageSpeciesUtilityWidget extends StatefulWidget {
  const ManageSpeciesUtilityWidget({super.key});

  static String routeName = 'ManageSpeciesUtility';
  static String routePath = '/manageSpeciesUtility';

  @override
  State<ManageSpeciesUtilityWidget> createState() =>
      _ManageSpeciesUtilityWidgetState();
}

class _ManageSpeciesUtilityWidgetState
    extends State<ManageSpeciesUtilityWidget> {
  late ManageSpeciesUtilityModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// 行 ID -> 选中的 speciesId / utilityId
  final Map<int, int?> _speciesIds = {};
  final Map<int, int?> _utilityIds = {};

  /// 下拉选项缓存（key: "species_<localKey>" / "utility_<localKey>"）
  final Map<String, List<Map<String, dynamic>>> _dropdownOptions = {};

  final Set<int> _dirtyIds = <int>{};
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ManageSpeciesUtilityModel());
    _loadLinks(); // 初始化加载表格数据
  }

  /// 加载 species_utility_link 表格数据
  Future<void> _loadLinks() async {
    setState(() => _loading = true);
    try {
      final list = await ApiService.getSpeciesUtilityLinks();
      _model.rows = list
          .map((e) => SpeciesUtilityLinkRow.fromJson(e as Map<String, dynamic>))
          .toList();

      for (final r in _model.rows) {
        _speciesIds[r.speciesId] = r.speciesId;
        _utilityIds[r.speciesId] = r.plantUtilityId;
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// 输入即搜：去后端查 species / utility
  Future<void> _searchDropdownItems(String key, String query, bool isSpecies) async {
    List<Map<String, dynamic>> results;
    if (isSpecies) {
      results = await ApiService.getSpecies(search: query);
    } else {
      results = await ApiService.getPlantUtilities(search: query);
    }
    if (!mounted) return;
    setState(() {
      _dropdownOptions[key] = results;
    });
  }

  /// 标记行被修改
  void _markDirty(int id) {
    _dirtyIds.add(id);
  }

  /// 取消修改
  Future<void> _onCancel() async {
    await _loadLinks();
    _dirtyIds.clear();
  }

  /// 保存修改（逐条创建/覆盖 link）
  Future<void> _onSave() async {
    try {
      for (final id in _dirtyIds) {
        final speciesId = _speciesIds[id];
        final utilityId = _utilityIds[id];
        if (speciesId != null && utilityId != null) {
          await ApiService.createSpeciesUtilityLink(
            speciesId: speciesId,
            plantUtilityId: utilityId,
          );
        }
      }
      _dirtyIds.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved')),
      );
      await _loadLinks();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primary,
      body: SafeArea(
        top: true,
        child: Container(
          decoration: const BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              /// 顶部菜单按钮行
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 7,
                      child: FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed(LandingASuperuserWidget.routeName);
                        },
                        text: 'Menu',
                        options: FFButtonOptions(
                          width: 100.0,
                          height: 50.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                          color: const Color(0xF0B2DDB2),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: () {
                                  final w = MediaQuery.sizeOf(context).width;
                                  if (w < kBreakpointSmall) return 12.0;
                                  if (w < kBreakpointMedium) return 14.0;
                                  if (w < kBreakpointLarge) return 14.0;
                                  return 16.0;
                                }(),
                                letterSpacing: 0.0,
                                useGoogleFonts:
                                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 10,
                      child: FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed(
                            ManageConservationStatusWidget.routeName,
                            extra: <String, dynamic>{
                              kTransitionInfoKey: const TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.fade,
                                duration: Duration(milliseconds: 0),
                              ),
                            },
                          );
                        },
                        text: 'Conservation Status',
                        options: FFButtonOptions(
                          width: 160.0,
                          height: 50.0,
                          color: const Color(0xFFF0F0F0),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                color: Colors.black,
                                fontSize: () {
                                  final w = MediaQuery.sizeOf(context).width;
                                  if (w < kBreakpointSmall) return 12.0;
                                  if (w < kBreakpointMedium) return 14.0;
                                  if (w < kBreakpointLarge) return 14.0;
                                  return 16.0;
                                }(),
                                letterSpacing: 0.0,
                                useGoogleFonts:
                                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 10,
                      child: FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed(ManageContainerTypeWidget.routeName);
                        },
                        text: 'Container types',
                        options: FFButtonOptions(
                          width: 160.0,
                          height: 50.0,
                          color: const Color(0xFFF0F0F0),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: () {
                                  final w = MediaQuery.sizeOf(context).width;
                                  if (w < kBreakpointSmall) return 12.0;
                                  if (w < kBreakpointMedium) return 14.0;
                                  if (w < kBreakpointLarge) return 14.0;
                                  return 16.0;
                                }(),
                                letterSpacing: 0.0,
                                useGoogleFonts:
                                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 10,
                      child: FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed(
                            ManagePlantUtilityWidget.routeName,
                            extra: <String, dynamic>{
                              kTransitionInfoKey: const TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.fade,
                                duration: Duration(milliseconds: 0),
                              ),
                            },
                          );
                        },
                        text: 'Plant utility',
                        options: FFButtonOptions(
                          width: 160.0,
                          height: 50.0,
                          color: const Color(0xFFF0F0F0),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                color: Colors.black,
                                fontSize: () {
                                  final w = MediaQuery.sizeOf(context).width;
                                  if (w < kBreakpointSmall) return 12.0;
                                  if (w < kBreakpointMedium) return 14.0;
                                  if (w < kBreakpointLarge) return 14.0;
                                  return 16.0;
                                }(),
                                letterSpacing: 0.0,
                                useGoogleFonts:
                                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 10,
                      child: FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed(
                            ManagePlantingRemovalWidget.routeName,
                            extra: <String, dynamic>{
                              kTransitionInfoKey: const TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.fade,
                                duration: Duration(milliseconds: 0),
                              ),
                            },
                          );
                        },
                        text: 'Planting removal causes',
                        options: FFButtonOptions(
                          width: 160.0,
                          height: 50.0,
                          color: const Color(0xFFF0F0F0),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                color: Colors.black,
                                fontSize: () {
                                  final w = MediaQuery.sizeOf(context).width;
                                  if (w < kBreakpointSmall) return 12.0;
                                  if (w < kBreakpointMedium) return 14.0;
                                  if (w < kBreakpointLarge) return 14.0;
                                  return 16.0;
                                }(),
                                letterSpacing: 0.0,
                                useGoogleFonts:
                                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 10,
                      child: FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed(
                            ManageProvenanceWidget.routeName,
                            extra: <String, dynamic>{
                              kTransitionInfoKey: const TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.fade,
                                duration: Duration(milliseconds: 0),
                              ),
                            },
                          );
                        },
                        text: 'Provenance',
                        options: FFButtonOptions(
                          width: 160.0,
                          height: 50.0,
                          color: const Color(0xFFF0F0F0),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                color: Colors.black,
                                fontSize: () {
                                  final w = MediaQuery.sizeOf(context).width;
                                  if (w < kBreakpointSmall) return 12.0;
                                  if (w < kBreakpointMedium) return 14.0;
                                  if (w < kBreakpointLarge) return 14.0;
                                  return 16.0;
                                }(),
                                letterSpacing: 0.0,
                                useGoogleFonts:
                                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 10,
                      child: FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed(
                            ManageProvenanceLocationTypesWidget.routeName,
                            extra: <String, dynamic>{
                              kTransitionInfoKey: const TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.fade,
                                duration: Duration(milliseconds: 0),
                              ),
                            },
                          );
                        },
                        text: 'Provenance location type',
                        options: FFButtonOptions(
                          width: 160.0,
                          height: 50.0,
                          color: const Color(0xFFF0F0F0),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                color: Colors.black,
                                fontSize: () {
                                  final w = MediaQuery.sizeOf(context).width;
                                  if (w < kBreakpointSmall) return 12.0;
                                  if (w < kBreakpointMedium) return 14.0;
                                  if (w < kBreakpointLarge) return 14.0;
                                  return 16.0;
                                }(),
                                letterSpacing: 0.0,
                                useGoogleFonts:
                                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 10,
                      child: FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed(
                            ManagePropagationTypeWidget.routeName,
                            extra: <String, dynamic>{
                              kTransitionInfoKey: const TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.fade,
                                duration: Duration(milliseconds: 0),
                              ),
                            },
                          );
                        },
                        text: 'Propagation type',
                        options: FFButtonOptions(
                          width: 160.0,
                          height: 50.0,
                          color: const Color(0xFFF0F0F0),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                color: Colors.black,
                                fontSize: () {
                                  final w = MediaQuery.sizeOf(context).width;
                                  if (w < kBreakpointSmall) return 12.0;
                                  if (w < kBreakpointMedium) return 14.0;
                                  if (w < kBreakpointLarge) return 14.0;
                                  return 16.0;
                                }(),
                                letterSpacing: 0.0,
                                useGoogleFonts:
                                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 10,
                      child: FFButtonWidget(
                        onPressed: () {
                          // 当前页
                        },
                        text: 'Species/Utility',
                        options: FFButtonOptions(
                          width: 160.0,
                          height: 50.0,
                          color: const Color(0xFFF0F0F0),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                color: const Color(0xFFFF0000),
                                fontSize: () {
                                  final w = MediaQuery.sizeOf(context).width;
                                  if (w < kBreakpointSmall) return 12.0;
                                  if (w < kBreakpointMedium) return 14.0;
                                  if (w < kBreakpointLarge) return 14.0;
                                  return 16.0;
                                }(),
                                letterSpacing: 0.0,
                                useGoogleFonts:
                                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 10,
                      child: FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed(
                            ManageZoneAspectWidget.routeName,
                            extra: <String, dynamic>{
                              kTransitionInfoKey: const TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.fade,
                                duration: Duration(milliseconds: 0),
                              ),
                            },
                          );
                        },
                        text: 'Zone aspect',
                        options: FFButtonOptions(
                          width: 160.0,
                          height: 50.0,
                          color: const Color(0xFFF0F0F0),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                color: Colors.black,
                                fontSize: () {
                                  final w = MediaQuery.sizeOf(context).width;
                                  if (w < kBreakpointSmall) return 12.0;
                                  if (w < kBreakpointMedium) return 14.0;
                                  if (w < kBreakpointLarge) return 14.0;
                                  return 16.0;
                                }(),
                                letterSpacing: 0.0,
                                useGoogleFonts:
                                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ].addToStart(const SizedBox(width: 16.0)).addToEnd(const SizedBox(width: 16.0)),
                ),
              ),

              /// 内容区：表格 + 操作按钮
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: FlutterFlowDataTable<SpeciesUtilityLinkRow>(
                            controller: _model.speciesUtilityTableController,
                            data: [
                              ..._model.rows,
                              SpeciesUtilityLinkRow(
                                localKey: DateTime.now().millisecondsSinceEpoch.toString(),
                                speciesId: -1,
                                plantUtilityId: -1,
                              ), // new row
                            ],
                            columnsBuilder: (onSortChanged) => const [
                              DataColumn2(label: Text('Species')),
                              DataColumn2(label: Text('Utility')),
                            ],
                            dataRowBuilder: (row, rowIndex, selected, onSelectChanged) {
                              final speciesKey = 'species_${row.localKey}';
                              final utilityKey = 'utility_${row.localKey}';

                              _dropdownOptions.putIfAbsent(speciesKey, () => []);
                              _dropdownOptions.putIfAbsent(utilityKey, () => []);

                              return DataRow(
                                color: WidgetStateProperty.all(
                                  rowIndex % 2 == 0
                                      ? FlutterFlowTheme.of(context).secondaryBackground
                                      : FlutterFlowTheme.of(context).primaryBackground,
                                ),
                                cells: [
                                  /// Species 下拉
                                  DataCell(
                                    DropdownButton2<int>(
                                      isExpanded: true,
                                      value: (_dropdownOptions[speciesKey] ?? [])
                                              .any((item) => item['id'] == _speciesIds[row.speciesId])
                                          ? _speciesIds[row.speciesId]
                                          : null,
                                      hint: const Text('Select species'),
                                      items: (_dropdownOptions[speciesKey] ?? [])
                                          .map(
                                            (item) => DropdownMenuItem<int>(
                                              value: item['id'],
                                              child: Text(item['name']),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          _speciesIds[row.speciesId] = val;
                                          _markDirty(row.speciesId);
                                        });
                                      },
                                      onMenuStateChange: (isOpen) {
                                        if (isOpen && (_dropdownOptions[speciesKey]?.isEmpty ?? true)) {
                                          _searchDropdownItems(speciesKey, '', true); // 首次打开拉一批
                                        }
                                      },
                                      dropdownStyleData: const DropdownStyleData(
                                        maxHeight: 300,
                                      ),
                                      dropdownSearchData: DropdownSearchData(
                                        searchController: TextEditingController(),
                                        searchInnerWidgetHeight: 50,
                                        searchInnerWidget: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            decoration: const InputDecoration(
                                              hintText: 'Search species...',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (query) async {
                                              await _searchDropdownItems(speciesKey, query, true);
                                            },
                                          ),
                                        ),
                                        // 后端已过滤，前端始终匹配
                                        searchMatchFn: (item, searchValue) => true,
                                      ),
                                    ),
                                  ),

                                  /// Utility 下拉
                                  DataCell(
                                    DropdownButton2<int>(
                                      isExpanded: true,
                                      value: (_dropdownOptions[utilityKey] ?? [])
                                              .any((item) => item['id'] == _utilityIds[row.speciesId])
                                          ? _utilityIds[row.speciesId]
                                          : null,
                                      hint: const Text('Select utility'),
                                      items: (_dropdownOptions[utilityKey] ?? [])
                                          .map(
                                            (item) => DropdownMenuItem<int>(
                                              value: item['id'],
                                              child: Text(item['utility']),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          _utilityIds[row.speciesId] = val;
                                          _markDirty(row.speciesId);
                                        });
                                      },
                                      onMenuStateChange: (isOpen) {
                                        if (isOpen && (_dropdownOptions[utilityKey]?.isEmpty ?? true)) {
                                          _searchDropdownItems(utilityKey, '', false);
                                        }
                                      },
                                      dropdownStyleData: const DropdownStyleData(
                                        maxHeight: 300,
                                      ),
                                      dropdownSearchData: DropdownSearchData(
                                        searchController: TextEditingController(),
                                        searchInnerWidgetHeight: 50,
                                        searchInnerWidget: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            decoration: const InputDecoration(
                                              hintText: 'Search utilities...',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (query) async {
                                              await _searchDropdownItems(utilityKey, query, false);
                                            },
                                          ),
                                        ),
                                        searchMatchFn: (item, searchValue) => true,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            paginated: true,
                            selectable: false,
                            headingRowHeight: 56.0,
                            dataRowHeight: 48.0,
                            columnSpacing: 20.0,
                            headingRowColor: FlutterFlowTheme.of(context).secondary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),

                        const SizedBox(height: 12.0),

                        /// 操作按钮
                        Row(
                          children: [
                            const Spacer(),
                            FFButtonWidget(
                              onPressed: _loading ? null : _onCancel,
                              text: 'Cancel',
                              options: FFButtonOptions(
                                width: 100.0,
                                height: 48.0,
                                color: Colors.white,
                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                      fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                      color: FlutterFlowTheme.of(context).primaryText,
                                    ),
                                borderSide: const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            FFButtonWidget(
                              onPressed: _loading ? null : _onSave,
                              text: 'Save',
                              options: FFButtonOptions(
                                width: 100.0,
                                height: 48.0,
                                color: Colors.white,
                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                      fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                      color: FlutterFlowTheme.of(context).primaryText,
                                    ),
                                borderSide: const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
