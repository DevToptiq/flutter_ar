import 'package:flutter/material.dart';
import 'package:user_app/auth/auth_service.dart';
import 'package:user_app/db/db_helper.dart';
import 'package:user_app/models/notification_model.dart';
import 'package:user_app/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;
  Future<void> addUser(UserModel userModel) =>
      DbHelper.addUser(userModel);

  Future<bool> doesUserExist(String uid) =>
      DbHelper.doesUserExist(uid);

  getUserInfo(){
    DbHelper.getUserInfo(AuthService.currentUser!.uid).listen((snapshot) {
      if(snapshot.exists){
        userModel = UserModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  Future<void> updateUserProfileField(String field, dynamic value){
    return DbHelper.updateUserProfileField(AuthService.currentUser!.uid, {field : value});
  }

  addNotification(NotificationModel notification) {
    return DbHelper.addNotification(notification);
  }
}