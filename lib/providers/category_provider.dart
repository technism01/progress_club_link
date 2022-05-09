import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:progress_club_link/common/string_constants.dart';
import 'package:progress_club_link/model/member_model.dart';
import 'package:progress_club_link/model/response_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

Dio dio = Dio();

class CategoryProvider extends ChangeNotifier {
  bool isLoading = false;

  /*Get Category SubCategory*/
  Future<ResponseClass<MemberModel>> loginUser(
      {required String mobileNo}) async {
    String _url = StringConstants.apiUrl + StringConstants.category;

    //body Data
   /* var data = {
      "mobileNumber": mobileNo,
    };*/

    //Response
    ResponseClass<MemberModel> responseClass =
    ResponseClass(success: false, message: "Something went wrong");
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.post(
        _url,
        //data: data,
        options: Options(validateStatus: (status) {
          return status == 404 || status == 200;
        }),
      );
      if (response.statusCode == 200) {
        responseClass.success = true;
        responseClass.message = response.data["msg"];
        responseClass.data =
            MemberModel.fromJson(response.data["data"], response.data["token"]);
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
