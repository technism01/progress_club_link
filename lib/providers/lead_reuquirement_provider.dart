import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:progress_club_link/common/string_constants.dart';
import 'package:progress_club_link/model/category_model.dart';
import 'package:progress_club_link/model/member_model.dart';
import 'package:progress_club_link/model/mylead_model.dart' as lead;
import 'package:progress_club_link/model/response_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

Dio dio = Dio();

class LeadRequirementProvider extends ChangeNotifier {
  bool isLoading = false;

  /*Get my Leads */
  Future<ResponseClass<List<lead.Category>>> getMyLeads(
      {required int memberID}) async {
    String _url = StringConstants.apiUrl + StringConstants.myLeads+"$memberID";

    ResponseClass<List<lead.Category>> responseClass =
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
        List<lead.Category> list =
            myLeadData.map((e) => lead.Category.fromJson(e)).toList();
        responseClass.data = list;
        isLoading = false;
        notifyListeners();
        return responseClass;
      }
      if (response.statusCode == 404) {
        responseClass.success = false;
        responseClass.message = response.data["msg"];
        Fluttertoast.showToast(msg: responseClass.message);
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
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
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
