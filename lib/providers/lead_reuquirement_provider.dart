import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_club_link/common/string_constants.dart';
import 'package:progress_club_link/model/myneed_model.dart';
import 'package:progress_club_link/model/response_model.dart';

import '../model/mylead_model.dart';

Dio dio = Dio();

class LeadRequirementProvider extends ChangeNotifier {
  bool isLoading = true;

  /*Get my Leads */
  Future<ResponseClass<List<LeadCategoryModel>>> getMyLeads(
      {required int memberID}) async {
    String _url = StringConstants.apiUrl + "request/myLead?memberId=$memberID";

    ResponseClass<List<LeadCategoryModel>> responseClass =
        ResponseClass(success: false, message: "Something went wrong");
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.get(
        _url,
        options: Options(validateStatus: (status) {
          return status == 404 || status == 200;
        }),
      );
      if (response.statusCode == 200) {
        responseClass.success = true;
        responseClass.message = response.data["msg"];
        List myLeadData = response.data["data"];
        List<LeadCategoryModel> list =
            myLeadData.map((e) => LeadCategoryModel.fromJson(e)).toList();
        responseClass.data = list;
        isLoading = false;
        notifyListeners();
        return responseClass;
      }
      if (response.statusCode == 404) {
        responseClass.success = false;
        responseClass.message = response.data["msg"];
        Fluttertoast.showToast(msg: responseClass.message,webBgColor:
        "linear-gradient(to right, #5A5A5A, #5A5A5A)");
        isLoading = false;
        notifyListeners();
      }
      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage,webBgColor:
      "linear-gradient(to right, #5A5A5A, #5A5A5A)");
      return responseClass;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        log("login error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass<List<NeedCategoryModel>>> getMyNeeds(
      {required int memberID}) async {
    String _url =
        StringConstants.apiUrl + "request/viewRequirement?memberId=$memberID";

    ResponseClass<List<NeedCategoryModel>> responseClass =
        ResponseClass(success: false, message: "Something went wrong");
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.get(
        _url,
        options: Options(validateStatus: (status) {
          return status == 404 || status == 200;
        }),
      );
      if (response.statusCode == 200) {
        responseClass.success = true;
        responseClass.message = response.data["msg"];
        List myNeedData = response.data["data"];
        List<NeedCategoryModel> list =
            myNeedData.map((e) => NeedCategoryModel.fromJson(e)).toList();
        responseClass.data = list;
        isLoading = false;
        notifyListeners();
        return responseClass;
      }
      if (response.statusCode == 404) {
        responseClass.success = false;
        responseClass.message = response.data["msg"];
        Fluttertoast.showToast(msg: responseClass.message,webBgColor:
        "linear-gradient(to right, #5A5A5A, #5A5A5A)");
        isLoading = false;
        notifyListeners();
      }
      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage,webBgColor:
      "linear-gradient(to right, #5A5A5A, #5A5A5A)");
      return responseClass;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        log("login error ->" + e.toString());
      }
      return responseClass;
    }
  }
}
