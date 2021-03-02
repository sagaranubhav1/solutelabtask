import 'package:rxdart/rxdart.dart';
import 'package:task_solutelabs/model/UserListMainModel.dart';
import 'package:task_solutelabs/repository/Repository.dart';
import 'package:task_solutelabs/ui/HomeScreen.dart';

class UserListBloc {

  final _repository = Repository();

  final _userDataFetch = PublishSubject<UserListMainModel>();

  Stream<UserListMainModel> get userData => _userDataFetch.stream;

  fetchUserData(context,String url) async {
    HomeScreenState.hitServiceOnce=true;
    UserListMainModel model = await _repository.getUserListRepository(context, url);
    _userDataFetch.sink.add(model);
  }

  dispose() {
    _userDataFetch.close();
  }
}

final userListBloc = UserListBloc();
