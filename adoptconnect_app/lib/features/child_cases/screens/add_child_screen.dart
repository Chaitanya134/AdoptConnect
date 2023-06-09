import 'dart:io';
import 'package:adoptconnect_app/constants/global_variables.dart';
import 'package:adoptconnect_app/features/child_cases/services/child_service.dart';
import 'package:adoptconnect_app/features/child_cases/widgets/child_avatar.dart';
import 'package:adoptconnect_app/widgets/dropdown.dart';
import 'package:adoptconnect_app/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../constants/utils.dart';

class AddChildScreen extends StatefulWidget {
  static const routeName = "/add-child";
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _childService = ChildService();
  File? avatarImage;
  List<File> documents = [];

  final _childIdController = TextEditingController();
  final _fullNameController = TextEditingController();
  String _genderValue = "Male";
  final _ageController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _shelterHomeController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  String _linkedWithSAAValue = "Yes";
  String _childClassificationValue = "Abandoned";
  final _inquiryDateOfAdmissionController = TextEditingController();
  String _caseStatusValue = "Active";
  final _reasonForAdmissionController = TextEditingController();
  final _caseHistoryController = TextEditingController();
  final _lastVisitController = TextEditingController();
  final _lastCallController = TextEditingController();
  final _guardianListedController = TextEditingController();
  final _familyPhoneCallController = TextEditingController();
  final _noOfSiblingsController = TextEditingController();
  final _lastDateOfCWCOrderController = TextEditingController();
  final _lastCWCOrderController = TextEditingController();
  final _lengthOfStayInShelterController = TextEditingController();
  final _regNoCARINGSController = TextEditingController();
  final _uploadDateFACSRMERController = TextEditingController();
  final _contactNumberController = TextEditingController();

  void _updateGender(String value) {
    setState(() => _genderValue = value);
  }

  void _updateLinkedWithSAA(String value) {
    setState(() => _linkedWithSAAValue = value);
  }

  void _updateChildClassification(String value) {
    setState(() => _childClassificationValue = value);
  }

  void _updateCaseStatus(String value) {
    setState(() => _caseStatusValue = value);
  }

  @override
  void dispose() {
    _childIdController.dispose();
    _fullNameController.dispose();
    _ageController.dispose();
    _dateOfBirthController.dispose();
    _shelterHomeController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _inquiryDateOfAdmissionController.dispose();
    _reasonForAdmissionController.dispose();
    _caseHistoryController.dispose();
    _lastVisitController.dispose();
    _lastCallController.dispose();
    _guardianListedController.dispose();
    _familyPhoneCallController.dispose();
    _noOfSiblingsController.dispose();
    _lastDateOfCWCOrderController.dispose();
    _lastCWCOrderController.dispose();
    _lengthOfStayInShelterController.dispose();
    _regNoCARINGSController.dispose();
    _uploadDateFACSRMERController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  void selectImage() async {
    var res = await pickImage();
    setState(() {
      if (res != null) {
        avatarImage = res;
      }
    });
  }

  void selectDocuments() async {
    var res = await pickDocuments();
    // print(res);
    setState(() => documents.addAll(res));
  }

  void submitForm() {
    // if (avatarImage == null) return;
    if (documents.isEmpty) return;
    // _childService.uploadAvatar(
    //     childId: '', image: avatarImage!, context: context);
    _childService.uploadDocument(childId: 'CLD_123', document: documents[0], context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add Child"),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(35),
            child: Form(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChildAvatar(
                        avatar: avatarImage == null
                            ? {}
                            : {"data": avatarImage?.readAsBytesSync()},
                        isProfile: true,
                      ),
                      const SizedBox(width: 15),
                      ElevatedButton(
                        onPressed: selectImage,
                        child: const Text("Upload Image"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  InputText(
                    labelText: "Child Id",
                    controller: _childIdController,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    labelText: "Full Name",
                    controller: _fullNameController,
                  ),
                  const SizedBox(height: 15),
                  Dropdown(
                    labelText: "Gender",
                    items: const ["Male", "Female"],
                    dropdownValue: _genderValue,
                    updateDropdownValue: _updateGender,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    labelText: "Age",
                    controller: _ageController,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    labelText: "Date of Birth",
                    controller: _dateOfBirthController,
                    isDate: true,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    labelText: "Shelter Home",
                    controller: _shelterHomeController,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    labelText: "Address / Street",
                    controller: _streetController,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    labelText: "City",
                    controller: _cityController,
                  ),
                  const SizedBox(height: 15),
                  Dropdown(
                    labelText: "Linked with SAA",
                    items: const ["Yes", "No"],
                    dropdownValue: _linkedWithSAAValue,
                    updateDropdownValue: _updateLinkedWithSAA,
                  ),
                  const SizedBox(height: 15),
                  Dropdown(
                    labelText: "Child Classification",
                    items: const [
                      "Abandoned",
                      "Orphanded",
                      "Surrendered",
                      "Untraceable"
                    ],
                    dropdownValue: _childClassificationValue,
                    updateDropdownValue: _updateChildClassification,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    labelText: "Inquiry Date of Admission",
                    controller: _inquiryDateOfAdmissionController,
                    isDate: true,
                  ),
                  const SizedBox(height: 15),
                  Dropdown(
                    labelText: "Case Status",
                    items: const ["Active", "On Hold", "Adopted"],
                    dropdownValue: _caseStatusValue,
                    updateDropdownValue: _updateCaseStatus,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    labelText: "Reason For Admission",
                    controller: _reasonForAdmissionController,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    labelText: "Case History",
                    controller: _caseHistoryController,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    labelText: "Last Visit",
                    controller: _lastVisitController,
                    isDate: true,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    labelText: "Last Call",
                    controller: _lastCallController,
                    isDate: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InputText(
                    labelText: "Guardian Listed",
                    controller: _guardianListedController,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    labelText: "Family Phone Call",
                    controller: _familyPhoneCallController,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    labelText: "Number of Siblings",
                    controller: _noOfSiblingsController,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    labelText: "Last Date of CWC Order",
                    controller: _lastDateOfCWCOrderController,
                    isDate: true,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    labelText: "Last CWC Order",
                    controller: _lastCWCOrderController,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    labelText: "Length of Stay in Shelter",
                    controller: _lengthOfStayInShelterController,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    labelText: "CARINGS Registration Number",
                    controller: _regNoCARINGSController,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    labelText: "FA CSR MER Upload Date",
                    controller: _uploadDateFACSRMERController,
                    isDate: true,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    labelText: "Contact Number",
                    controller: _contactNumberController,
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: selectDocuments,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(10),
                      dashPattern: const [10, 4],
                      strokeCap: StrokeCap.round,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.folder_open,
                              size: 40,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Add Documents',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: submitForm,
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 40),
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}