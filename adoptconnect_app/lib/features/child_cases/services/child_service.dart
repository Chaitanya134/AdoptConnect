import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:adoptconnect_app/constants/error_handling.dart';
import 'package:adoptconnect_app/constants/global_variables.dart';
import 'package:adoptconnect_app/constants/utils.dart';
import 'package:adoptconnect_app/providers/cases_provider.dart';
import 'package:adoptconnect_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../models/child.dart';

class ChildService {
  void getAllCasesofWorker({required context}) async {
    try {
      String userId =
          Provider.of<UserProvider>(context, listen: false).user.userId;
      http.Response res = await http
          .post(Uri.parse('$uri/users/getworker'), body: {"user_id": userId});

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            var allotedChildren =
                jsonDecode(res.body)["response"]["alloted_children"];
            Provider.of<CasesProvider>(context, listen: false)
                .setCases(jsonEncode(allotedChildren));
          },
          errorText: "Error in getting worker's child cases");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<Child?> getChild({required String childId, required context}) async {
    Child? child;
    try {
      http.Response res = await http.post(
        Uri.parse("$uri/child/getchild"),
        body: {"child_id": childId},
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            child = Child.fromJson(res.body);
          },
          errorText: "Error in getting child");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return child;
  }

  void addChild({required Child child, required context}) async {
    try {
      Map<String, dynamic> body = {
        "child_id": child.childId,
        "childName": child.childName,
        "age": child.age.toString(),
        "gender": child.gender,
        "dateOfBirth": child.dateOfBirth,
        "state": child.state,
        "district": child.district,
        "shelterHome": child.shelterHome,
        "linkedWithSAA": child.linkedWithSAA,
        "childClassification": child.childClassification,
        "inquiryDateOfAdmission": child.inquiryDateOfAdmission,
        "reasonForAdmission": child.reasonForAdmission,
        "lastVisit": child.lastVisit,
        "lastCall": child.lastCall,
        "caseHistory": child.caseHistory,
        "caseStatus": child.caseStatus,
        "guardianListed": child.guardianListed,
        "familyVisitPhoneCall": child.familyVisitsPhoneCall,
        "siblings": child.siblings,
        "lastDateOfCWCOrder":
            child.lastDateOfCWCOrder.toIso8601String().substring(0, 10),
        "Lastcwcorder": child.lastCWCOrder,
        "lengthOfStayInShelter": child.lengthOfStayInShelter,
        "caringsRegistrationNumber": child.caringsRegistrationNumber,
        "dateLFA_CSR_MERUploadedINCARINGS":
            child.dateLFACSRMERUploadedInCARINGS,
        "contact_no": child.contactNo.toString(),
        "createdByUser": child.createdByUser,
        "createdDate": child.createdDate
      };

      http.Response childRes =
          await http.post(Uri.parse("$uri/child/create_child"), body: body);

      var childObj = jsonDecode(childRes.body)["response"];
      childObj["avatar"] = {"data": child.avatar["data"].readAsBytesSync()};
      childObj["uploaded_documents"] = [];
      Child newChild = Child.fromJson(jsonEncode(childObj));

      httpErrorHandle(
          response: childRes,
          context: context,
          onSuccess: () async {
            await uploadAvatar(
                childId: child.childId,
                image: child.avatar["data"],
                context: context);

            List<Future<void>> uploadTasks = [];
            for (File document in child.uploadedDocuments) {
              uploadTasks.add(uploadDocument(
                childId: child.childId,
                document: document,
                context: context,
              ));
            }

            await Future.wait(uploadTasks);
            Provider.of<CasesProvider>(context, listen: false)
                .addChild(newChild);
            Navigator.pop(context);
          },
          errorText: "Error in Adding Child");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void editChild(
      {required Child child, required context}) async {
    try {
      Map<String, dynamic> body = {
        "child_id": child.childId,
        "childName": child.childName,
        "age": child.age.toString(),
        "gender": child.gender,
        "dateOfBirth": child.dateOfBirth,
        "state": child.state,
        "district": child.district,
        "shelterHome": child.shelterHome,
        "linkedWithSAA": child.linkedWithSAA,
        "childClassification": child.childClassification,
        "inquiryDateOfAdmission": child.inquiryDateOfAdmission,
        "reasonForAdmission": child.reasonForAdmission,
        "lastVisit": child.lastVisit,
        "lastCall": child.lastCall,
        "caseHistory": child.caseHistory,
        "caseStatus": child.caseStatus,
        "guardianListed": child.guardianListed,
        "familyVisitPhoneCall": child.familyVisitsPhoneCall,
        "siblings": child.siblings,
        "lastDateOfCWCOrder": child.lastDateOfCWCOrder.toIso8601String(),
        "Lastcwcorder": child.lastCWCOrder,
        "lengthOfStayInShelter": child.lengthOfStayInShelter,
        "caringsRegistrationNumber": child.caringsRegistrationNumber,
        "dateLFA_CSR_MERUploadedINCARINGS":
            child.dateLFACSRMERUploadedInCARINGS,
        "contact_no": child.contactNo.toString(),
        "createdByUser": child.createdByUser,
        "createdDate": child.createdDate
      };

      http.Response childRes =
          await http.post(Uri.parse("$uri/child/update_child"), body: body);

      var childObj = jsonDecode(childRes.body)["response"];
      print(child.avatar["data"].runtimeType);
      if (child.avatar["data"] != null) {
        try {
          childObj["avatar"] = {"data": child.avatar["data"].readAsBytesSync()};
        } catch(e) {
          childObj["avatar"] = child.avatar;

        }
        // if (child.avatar["data"].runtimeType == File) {
        //   childObj["avatar"] = {"data": child.avatar["data"].readAsBytesSync()};
        // } else {
        //   childObj["avatar"] = child.avatar;
        // }
      }
      childObj["uploaded_documents"] = [];
      Child newChild = Child.fromJson(jsonEncode(childObj));

      httpErrorHandle(
          response: childRes,
          context: context,
          onSuccess: () async {
            if (child.avatar["data"] != null && child.avatar["data"] is File) {
              await uploadAvatar(
                  childId: child.childId,
                  image: child.avatar["data"],
                  context: context);
            }

            List<Future<void>> uploadTasks = [];
            for (File document in child.uploadedDocuments) {
              uploadTasks.add(uploadDocument(
                childId: child.childId,
                document: document,
                context: context,
              ));
            }

            await Future.wait(uploadTasks);
            Provider.of<CasesProvider>(context, listen: false)
                .editChild(child.childId, newChild);
            Navigator.pop(context);
          },
          errorText: "Error in Editing Child");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> uploadAvatar({
    required String childId,
    required File image,
    required context,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$uri/child/image_upload"),
      );

      request.fields['child_id'] = childId;
      request.files.add(http.MultipartFile(
        'file',
        image.readAsBytes().asStream(),
        image.lengthSync(),
        filename: image.path.split('/').last,
      ));

      await request.send();
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> uploadDocument({
    required String childId,
    required File document,
    required context,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$uri/child/document/upload"),
      );

      request.fields['child_id'] = childId;
      request.files.add(http.MultipartFile(
        'file',
        document.readAsBytes().asStream(),
        document.lengthSync(),
        filename: document.path.split('/').last,
      ));

      await request.send();
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  File convertBufferToFile(String fileName, dynamic fileData) {
    List<dynamic> bufferDynamic = fileData['data'];
    List<int> buffer = bufferDynamic.map((e) => e as int).toList();
    Uint8List bytes = Uint8List.fromList(buffer);
    File file = File('${Directory.systemTemp.path}/$fileName');
    file.writeAsBytesSync(bytes);
    return file;
  }

  Future<File?> getDocument({
    required String childId,
    required String docId,
    required context,
  }) async {
    File? document;
    try {
      http.Response res = await http.post(
        Uri.parse("$uri/child/document/download"),
        body: {"child_id": childId, "docId": docId},
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            var apiRes = jsonDecode(res.body);
            document = convertBufferToFile(apiRes["name"], apiRes["data"]);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return document;
  }

  Future<List<File>> getDocuments({
    required String childId,
    required context,
  }) async {
    List<File> documents = [];
    try {
      http.Response res = await http.post(
        Uri.parse("$uri/child/document/files"),
        body: {"child_id": childId},
      );
      await httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          List<dynamic> documentMetadata = jsonDecode(res.body)["response"];
          List<Future<File?>> downloadTasks = [];
          for (dynamic document in documentMetadata) {
            downloadTasks.add(
              getDocument(
                childId: childId,
                docId: document["docId"],
                context: context,
              ),
            );
          }

          List<File?> docs = await Future.wait(downloadTasks);
          for (File? doc in docs) {
            if (doc != null) documents.add(doc);
          }
        },
        errorText: "Error in getting child's documents",
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return documents;
  }
}
