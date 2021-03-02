import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:task_solutelabs/model/UserListDataModel.dart';
import 'package:task_solutelabs/model/UserListMainModel.dart';
import 'package:task_solutelabs/utils/CommonMethods.dart';
import 'package:task_solutelabs/utils/LoadingIndicator.dart';

class ApiRequest {
  BuildContext mContextLoader;

  Future<dynamic> apiRequestByGet(context, url, {showLoader = true}) async {
    http.Response response;
    LoadingIndicator dialog;
    var isConnected = await CommonMethods.checkInternetConnectivity();
    if (isConnected) {
      Map<String, String> headers = new Map();
      headers["accept"] = "application/vnd.github.v3+json";
      if (context != null && showLoader) {
        dialog = new LoadingIndicator(context, isDismissible: true);
        await dialog.show();
      }

      response = await http.get(url, headers: headers);
      print("UrlCheck===" + url);
      print("ResponseCheck===" + response.body);

      if (dialog != null && dialog.isShowing()) {
        dialog.dismiss();
      }

      if (response.statusCode == 401) {

      } else {
        return response;
      }
    } else {
      showNetworkDialog(context);
    }
  }

  showNetworkDialog(context) {
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.signal_cellular_connected_no_internet_4_bar_sharp,
                    size: 44,
                  ),
                ),
                Text(
                  "No Internet",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Please check your internet",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

//  ***************************Web Service Response*********************************

  Future<UserListMainModel> userListApiCall(context, String url) async {
    dynamic response = await apiRequestByGet(context, url, showLoader: true);
    return UserListMainModel.fromJson(json.decode(response.body));
  }

}
