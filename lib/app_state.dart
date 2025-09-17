import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  List<ZonesStruct> _mockZones = [];
  List<ZonesStruct> get mockZones => _mockZones;
  set mockZones(List<ZonesStruct> value) {
    _mockZones = value;
  }

  void addToMockZones(ZonesStruct value) {
    mockZones.add(value);
  }

  void removeFromMockZones(ZonesStruct value) {
    mockZones.remove(value);
  }

  void removeAtIndexFromMockZones(int index) {
    mockZones.removeAt(index);
  }

  void updateMockZonesAtIndex(
    int index,
    ZonesStruct Function(ZonesStruct) updateFn,
  ) {
    mockZones[index] = updateFn(_mockZones[index]);
  }

  void insertAtIndexInMockZones(int index, ZonesStruct value) {
    mockZones.insert(index, value);
  }

  List<SubZonesStruct> _mockSubZones = [];
  List<SubZonesStruct> get mockSubZones => _mockSubZones;
  set mockSubZones(List<SubZonesStruct> value) {
    _mockSubZones = value;
  }

  void addToMockSubZones(SubZonesStruct value) {
    mockSubZones.add(value);
  }

  void removeFromMockSubZones(SubZonesStruct value) {
    mockSubZones.remove(value);
  }

  void removeAtIndexFromMockSubZones(int index) {
    mockSubZones.removeAt(index);
  }

  void updateMockSubZonesAtIndex(
    int index,
    SubZonesStruct Function(SubZonesStruct) updateFn,
  ) {
    mockSubZones[index] = updateFn(_mockSubZones[index]);
  }

  void insertAtIndexInMockSubZones(int index, SubZonesStruct value) {
    mockSubZones.insert(index, value);
  }

  DateTime? _selectedDate = DateTime.fromMillisecondsSinceEpoch(1758038400000);
  DateTime? get selectedDate => _selectedDate;
  set selectedDate(DateTime? value) {
    _selectedDate = value;
  }
}
