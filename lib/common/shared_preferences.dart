import 'package:progress_club_link/common/string_constants.dart';
import 'package:progress_club_link/model/selected_category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  Future<bool> logout() async {
    _sharedPrefs!.clear();
    return false;
  }

  init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  //getters
  int get memberId => _sharedPrefs!.getInt(StringConstants.memberId) ?? 0;

  String get mobileNo =>
      _sharedPrefs!.getString(StringConstants.mobileNo) ?? "";

  String get memberName =>
      _sharedPrefs!.getString(StringConstants.memberName) ?? "";

  String get pcGroup => _sharedPrefs!.getString(StringConstants.pcGroup) ?? "";

  String get email => _sharedPrefs!.getString(StringConstants.email) ?? "";

  String get companyName =>
      _sharedPrefs?.getString(StringConstants.companyName) ?? "";

  String get profile => _sharedPrefs!.getString(StringConstants.profile) ?? "";

  List<SelectedCategoryModel> get selected => SelectedCategoryModel.decode(
      _sharedPrefs?.getString(StringConstants.selected) ?? "");

  //setters
  set memberId(int value) {
    _sharedPrefs!.setInt(StringConstants.memberId, value);
  }

  set memberName(String value) {
    _sharedPrefs!.setString(StringConstants.memberName, value);
  }

  set pcGroup(String value) {
    _sharedPrefs!.setString(StringConstants.pcGroup, value);
  }

  set mobileNo(String value) {
    _sharedPrefs!.setString(StringConstants.mobileNo, value);
  }

  set email(String value) {
    _sharedPrefs!.setString(StringConstants.email, value);
  }

  set profile(String value) {
    _sharedPrefs!.setString(StringConstants.profile, value);
  }

  set companyName(String value) {
    _sharedPrefs!.setString(StringConstants.companyName, value);
  }

  set selected(List<SelectedCategoryModel> lis) {
    _sharedPrefs!
        .setString(StringConstants.selected, SelectedCategoryModel.encode(lis));
  }

/*--------------- Check Is Login or Not --------------------*/
  Future<bool> isLogin() async {
    int guestId = sharedPrefs.memberId;
    if (guestId == 0) {
      return false;
    } else {
      return true;
    }
  }
}

final sharedPrefs = SharedPrefs();
