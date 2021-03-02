import 'package:flutter/material.dart';
import 'package:task_solutelabs/bloc/UserListBloc.dart';
import 'package:task_solutelabs/model/UserListDataModel.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController _tabController;
  List<UserListDataModel> userDataList = [];
  List<UserListDataModel> userList = [];
  List<UserListDataModel> filteredUserList = [];
  List<UserListDataModel> bookMarkedUserList = [];
  List<UserListDataModel> filteredBookMarkedUserList = [];
  ScrollController scrollController = ScrollController();
  int page = 1, pageRatio = 30;
  static bool hitServiceOnce = false;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  List<Widget> tabs = [
    Tab(
      text: "Users",
    ),
    Tab(text: "Bookmarked Users"),
  ];

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (filteredUserList.length % pageRatio == 0 && !hitServiceOnce) {
          page = page + 1;
          userListService();
        }
      }
    });
    userListService();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 40),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Colors.blue, Colors.purple],
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              indicatorWeight: 4,
              unselectedLabelColor: Colors.white,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 5.0, color: Colors.white),
                  insets: EdgeInsets.symmetric(horizontal: 16.0)),
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: tabs,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 12, right: 12, top: 15, bottom: 15),
            padding: const EdgeInsets.only(left: 20, right: 8),
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(width: 0),
              color: Colors.white,
            ),
            child: TextField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                if(_tabController.index==1){
                  Future.delayed(const Duration(milliseconds: 300), () {
                    filteredBookMarkedUserList = bookMarkedUserList
                        .where((data) => data.login
                        .trim()
                        .toLowerCase()
                        .contains(value.trim().toLowerCase()))
                        .toList();
                    setState(() {});
                  });
                }
                else{
                  Future.delayed(const Duration(milliseconds: 300), () {
                    filteredUserList = userList
                        .where((data) => data.login
                        .trim()
                        .toLowerCase()
                        .contains(value.trim().toLowerCase()))
                        .toList();
                    setState(() {});
                  });
                }
              },
              onSubmitted: (value) {},
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintText: "Search User",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
          ),
          Expanded(
            flex: 2,
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                mounted
                    ? StreamBuilder(
                        stream: userListBloc.userData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.active && hitServiceOnce) {
                            hitServiceOnce = false;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              userDataList = snapshot.data.data;
                              userList.addAll(userDataList);
                              filteredUserList = userList;
                              setState(() {});
                            });
                          }
                          return RefreshIndicator(
                              key: refreshKey,
                              onRefresh: refreshList,
                              child: usersTabView());
                        })
                    : Center(
                        child: Text(
                          "No Record(s) Found",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                mounted
                    ? bookMarkedUsersTabView()
                    : null,
              ],
            ),
          ),
        ],
      ),
    );
  }

  void userListService() {
    String url = "";
    if (page > 1) {
      url = "https://api.github.com/users?per_page=$page";
    } else {
      url = "https://api.github.com/users";
    }
    userListBloc.fetchUserData(context, url);
  }

  Widget usersTabView() {
    return filteredUserList != null && filteredUserList.length > 0
        ? ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.zero,
            itemCount: filteredUserList.length,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 150,
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Card(
                  elevation: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Image.network(
                          filteredUserList[index].avatar_url,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext ctx, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.green),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Text(
                        filteredUserList[index].login.toUpperCase(),
                        style: TextStyle(fontSize: 16),
                      )),
                      IconButton(
                          icon: Icon(filteredUserList[index].status?Icons.bookmark:Icons.bookmark_border,size: 30,), onPressed: () {
                        if(!filteredUserList[index].status){
                          filteredUserList[index].status=true;
                          bookMarkedUserList.add(filteredUserList[index]);
                          filteredBookMarkedUserList=bookMarkedUserList;
                        }
                        else{
                          filteredUserList[index].status=false;
                          bookMarkedUserList.remove(filteredUserList[index]);
                          filteredBookMarkedUserList.remove(filteredUserList[index]);
                        }
                        setState(() {

                        });
                      })
                    ],
                  ),
                ),
              );
            })
        : Center(
            child: Text(
              "No Record(s) Found",
              style: TextStyle(fontSize: 16.0),
            ),
          );
  }

  Widget bookMarkedUsersTabView() {
    return filteredBookMarkedUserList != null && filteredBookMarkedUserList.length > 0
        ? ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: filteredBookMarkedUserList.length,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 150,
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Card(
                  elevation: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Image.network(
                          filteredBookMarkedUserList[index].avatar_url,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext ctx, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.green),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Text(
                            filteredBookMarkedUserList[index].login.toUpperCase(),
                        style: TextStyle(fontSize: 16),
                      )),
                      IconButton(
                          icon: Icon(filteredBookMarkedUserList[index].status?Icons.bookmark:Icons.bookmark_border,size: 30,), onPressed: () {
                        if(filteredBookMarkedUserList[index].status){
                          filteredBookMarkedUserList[index].status=false;
                          filteredBookMarkedUserList.remove(filteredBookMarkedUserList[index]);
                        }
                        else{
                          filteredBookMarkedUserList[index].status=true;
                        }
                        setState(() {

                        });
                      })
                    ],
                  ),
                ),
              );
            })
        : Center(
            child: Text(
              "No Record(s) Found",
              style: TextStyle(fontSize: 16.0),
            ),
          );
  }

  Future<void> refreshList() async {
    page = 1;
    userList.clear();
    filteredUserList.clear();
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2), () {
      userListService();
    });
  }
}
