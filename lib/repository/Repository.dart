import 'package:task_solutelabs/api/ApiRequest.dart';
import 'package:task_solutelabs/model/UserListMainModel.dart';

class Repository{

  final dataProvider = ApiRequest();

  Future<UserListMainModel> getUserListRepository(context, String url) async =>
      dataProvider.userListApiCall(context, url);
}