import 'dart:async';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

import 'package:rail_lens/validator.dart';
import 'consta.dart';
import 'bloc_provider.dart';
import 'models/model.dart';
import 'network.dart';

class ApplicationBloc extends BaseBloc {
  //TODO: Replace Object with appropriate type
  final _databaseStreamController = StreamController<Object>();
  final RailApi _railApi = RailApi();

  //WorkAround until db integration
  String _cachedUsername;
  String _cachedPassword;
  List<String> _cachedStationList;

  //TODO: Replace with actual database call
  Stream<Credentials> get credentialStream =>
//      Observable.fromFuture(getCredentials());
      Observable.timer(Credentials(_cachedUsername, _cachedPassword),
          Duration(milliseconds: 10));

  Stream<bool> get isLoggedIn =>
      Observable.timer(false, Duration(milliseconds: 200));

  Future<void> storeCredentials(String username, String password) async {
    _cachedUsername = username;
    _cachedPassword = password;
    //TODO: Save credentials in base64(use plain text until login and change password are converted)
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    await prefs.setString(consta.userKey, username);
//    await prefs.setString(consta.passKey, password);
  }

//  Future<Credentials> getCredentials() async{
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String user =  prefs.getString(consta.userKey);
//    String pass = prefs.getString(consta.passKey);
//    return Future<Credentials>(()=>Credentials(user, pass));
//  }

  void storeStationList(List<String> list) {
    _cachedStationList = list;
  }

  void storeUsername(String username) {
    _cachedUsername = username;
  }

  void storePassword(String password) {
    _cachedPassword = password;
  }

  ApplicationBloc() {
    //Setup the database stream, so that isLoggedIn can return actual credentials
  }

  @override
  void dispose() {
    print('Disposing Application Bloc');
    _databaseStreamController.close();
  }
}

class LoginBloc extends BaseBloc with Validator {
  final _usernameController = PublishSubject<String>();
  final _passwordController = PublishSubject<String>();
  String _lastUsername = '';
  String _lastPassword = '';

  final RailApi api = RailApi();

  Stream<String> get username =>
      _usernameController.stream.transform(usernameValidator);
  Stream<String> get password =>
      _passwordController.stream.transform(passwordValidator);

  //TODO: Yes this is ugly, please change
  Stream<List<Object>> get _userPassStream =>
      Observable.zip2(_usernameController.stream, _passwordController.stream,
          (u, p) {
        print('$u and $p were submitted');
        return [
          u,
          p,
          Validator.usernameConditionChecker(u) &&
              Validator.passwordConditionChecker(p)
        ];
      });

  Stream<bool> get submitCheck => _userPassStream.map((data) => data[2]);

  Stream<AuthorizationModel> get authorizationStream =>
      Observable(_userPassStream.where((list) => list[2])).doOnData((dataList) {
        _lastPassword = dataList[1];
        _lastUsername = dataList[0];
      })
//      .asyncMap((pair)=>api.login(pair[0], pair[1]));
          .map((dummy) {
        //TODO: Remove dummy data from here
        return new AuthorizationModel(true, true, ['DEL']);
      });

  String get lastUsername => _lastUsername;
  String get lastPassword => _lastPassword;

  Function(String) get usernameChanged => _usernameController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;

  @override
  void dispose() {
    _usernameController.close();
    _passwordController.close();
  }
}

class ChangePasswordBloc extends BaseBloc with Validator {
  final _newPasswordController = PublishSubject<String>();
  final _confirmPasswordController = PublishSubject<String>();
  final _oldPasswordController = PublishSubject<String>();

  String _lastPassword;
  final RailApi _api = RailApi();

  Stream<String> get newPassword =>
      _newPasswordController.stream.transform(passwordValidator);
  Stream<List<Object>> get confirmPassword => Observable.zip3(
          _newPasswordController.stream,
          _confirmPasswordController.stream,
          _oldPasswordController.stream, (newPass, confPass, oldPass) {
        print('given passes are $oldPass, $newPass, $confPass');
        return [oldPass, newPass, confPass];
      }).transform(confPassValidator);

  //TODO: Change so that it accesses username saved from the database
  Stream<String> get usernameStream => Observable.just('abc');
  Stream<bool> get validEntries =>
      confirmPassword.map((list) => list[list.length - 1]);

  Stream<AuthorizationModel> get authorizationStream =>
      Observable.combineLatest2(
              confirmPassword.where((list) => list[list.length - 1]),
              usernameStream, (passList, username) {
        passList = passList as List<Object>;
        passList[passList.length - 1] = username;
        print('Sending this parameter list -> $passList');
        return passList;
      })
          //      .asyncMap((pair)=>api.login(pair[0], pair[1]));
          .map((dummy) {
        //TODO: Remove dummy data from here
        return new AuthorizationModel(true, false, ['DEL']);
      });

  String get lastPassword => _lastPassword;

  Function(String) get oldPassChanged => _oldPasswordController.sink.add;
  Function(String) get newPassChanged => _newPasswordController.sink.add;
  Function(String) get confirmPassChanged =>
      _confirmPasswordController.sink.add;

  @override
  void dispose() {
    print('Disposing ChangePassword Bloc');
    _oldPasswordController.close();
    _newPasswordController.close();
    _confirmPasswordController.close();
  }
}