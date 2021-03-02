import 'package:task_solutelabs/model/UserListDataModel.dart';

class UserListMainModel{
  List<UserListDataModel> data;

  UserListMainModel({this.data});
  factory UserListMainModel.fromJson(List<dynamic> json) {
    return UserListMainModel(
      data: json != null ? (json).map((i) => UserListDataModel.fromJson(i)).toList() : null,
    );
  }
}