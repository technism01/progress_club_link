import 'dart:convert';

import 'package:progress_club_link/common/shared_preferences.dart';
import 'package:progress_club_link/model/member_model.dart';

saveUserInLocal(MemberModel user) {
  sharedPrefs.memberId = user.memberId;
  sharedPrefs.memberName = user.memberName;
  sharedPrefs.profile = user.profile ?? "";
  sharedPrefs.mobileNo = user.mobileNumber;
  sharedPrefs.companyName = user.companyName;
  sharedPrefs.email = user.email ?? "";
  sharedPrefs.pcGroup = user.pcGroup;
}
