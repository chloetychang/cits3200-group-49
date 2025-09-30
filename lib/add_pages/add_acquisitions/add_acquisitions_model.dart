import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import '/backend/api_service.dart'; // use our API service
import 'add_acquisitions_widget.dart' show AddAcquisitionsWidget;
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class AddAcquisitionsModel extends FlutterFlowModel<AddAcquisitionsWidget> {
  ///  Dropdown combo contoller state
  late final SingleValueDropDownController varietyWithSpeciesComboController;
  late final SingleValueDropDownController supplierComboController;
  late final SingleValueDropDownController locationComboController;
  late final SingleValueDropDownController bioregionComboController;
  late final SingleValueDropDownController generationNumberComboController;

  // State field for selected variety ID (from dropdown)
  int? selectedVarietyId;
  // State field for selected generation number (from dropdown)
  int? selectedGenerationNumber;
  ///  State fields for stateful widgets in this page.

  // 1) Acquisition Date widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  
  // 2) Variety with Species DropDown widget (replaces separate genus/species)
  List<Map<String, dynamic>> varietiesWithSpeciesDropdown = []; // Holds list of varieties with species to show in dropdown
  String? selectedVarietyWithSpecies; // Stores the current selected variety with species display text
  FormFieldController<String>? varietyWithSpeciesDropdownController; // Manage state of variety with species dropdown form field

  // Fetch Varieties with Species Dropdown 
  Future<void> loadVarietiesWithSpeciesDropdown() async {
    final rawList = await ApiService.getVarietiesWithSpeciesDropdown();
    varietiesWithSpeciesDropdown = rawList;
  }

  // 3) Supplier DropDown widget.
  List<Map<String, dynamic>> suppliersDropdown = [];
  int? selectedSupplierId;
  String? selectedSupplierName;
  FormFieldController<String>? dropDownSupplierController;

  // Fetch Suppliers Dropdown
  Future<void> loadSuppliersDropdown() async {
    final rawList = await ApiService.getSuppliersDropdown();
    suppliersDropdown = rawList;
  }

  // 4) Location DropDown widget
  List<Map<String, dynamic>> locationDropdown = [];
  int? selectedProvenanceId;
  String? selectedLocationName;
  FormFieldController<String>? dropDownLocationController;

  // Fetch Provenance Location Dropdown
  Future<void> loadLocationDropdown() async {
    final rawList = await ApiService.getLocationDropdown();
    locationDropdown = rawList;
  }

  List<String> bioregionDropdown = [];
  String? selectedBioregionCode;
  FormFieldController<String>? bioregionDropdownController;

  // Fetch Bioregion Dropdown
  Future<void> loadBioregionDropdown() async {
    // You need to implement this API call in ApiService
    final rawList = await ApiService.getBioregionDropdown();
    bioregionDropdown = rawList.toSet().toList()..sort();
  }

  // Generation Number DropDown widget
  List<int> generationNumberDropdown = [];
  FormFieldController<int>? generationNumberDropdownController;

  // Fetch Generation Number Dropdown
  Future<void> loadGenerationNumberDropdown() async {
    generationNumberDropdown = await ApiService.getGenerationNumberDropdown();
  }

  // 5) Save Button Widget
  Future<void> saveAcquisition() async {
    // Validate required fields
    if (selectedVarietyId == null) {
      throw Exception('Please select a species and variety');
    }
    if (selectedSupplierId == null) {
      throw Exception('Please select a supplier');
    }
    if (textController2?.text == null || textController2!.text.isEmpty) {
      throw Exception('Please enter a lot number');
    }
    if (textController1?.text == null || textController1!.text.isEmpty) {
      throw Exception('Please enter an acquisition date');
    }

    await ApiService.createAcquisition(
      acquisitionDate: textController1!.text,
      varietyId: selectedVarietyId!,
      supplierId: selectedSupplierId!,
      supplierLotNumber: textController2!.text,
      price: double.tryParse(textController3?.text ?? ''),
      gramWeight: int.tryParse(textController4?.text ?? ''),
      viability: int.tryParse(textController5?.text ?? ''),
      provenanceId: selectedProvenanceId, 
      generationNumber: selectedGenerationNumber ?? 0,
      landscapeOnly: checkboxValue ?? false,
    );
  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode5;
  TextEditingController? textController5;
  String? Function(BuildContext, String?)? textController5Validator;
  // State field(s) for Checkbox widget.
  bool? checkboxValue;
  // State field(s) for DropDown widget.
  String? dropDownValue4;
  FormFieldController<String>? dropDownValueController4;
  // State field(s) for DropDown widget.
  String? dropDownValue5;
  FormFieldController<String>? dropDownValueController5;


  @override
  void initState(BuildContext context) {
    varietyWithSpeciesComboController = SingleValueDropDownController();
    supplierComboController = SingleValueDropDownController();
    locationComboController = SingleValueDropDownController();
    bioregionComboController = SingleValueDropDownController();
    generationNumberComboController = SingleValueDropDownController();
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();

    textFieldFocusNode4?.dispose();
    textController4?.dispose();

    textFieldFocusNode5?.dispose();
    textController5?.dispose();

    supplierComboController.dispose();
    varietyWithSpeciesComboController.dispose();
    locationComboController.dispose();
    bioregionComboController.dispose();
    generationNumberComboController.dispose();

  }

  

}
