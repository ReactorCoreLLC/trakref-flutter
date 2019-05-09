import 'package:flutter/material.dart';
import 'package:trakref_app/bloc/accounts_bloc.dart';
import 'package:trakref_app/bloc/bloc_provider.dart';
import 'package:trakref_app/bloc/login_bloc.dart';
import 'package:trakref_app/main.dart';
import 'package:trakref_app/models/info_user.dart';
import 'package:trakref_app/models/user.dart';
import 'package:trakref_app/repository/api/trakref_api_service.dart';
import 'package:trakref_app/screens/accounts/page_accounts_bloc.dart';
import 'package:trakref_app/screens/login/reset/page_reset_password_bloc.dart';
import 'package:trakref_app/widget/button_widget.dart';
import 'package:trakref_app/widget/loading_widget.dart';

class PageLoginBloc extends StatefulWidget {
  @override
  _PageLoginBlocState createState() => _PageLoginBlocState();
}

class _LoginData {
  String username = '';
  String password = '';
}

class _PageLoginBlocState extends State<PageLoginBloc> {
  final _formKey = GlobalKey<FormState>();
  _LoginData _data = new _LoginData();
  LoginBloc loginBloc;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    this.loginBloc = BlocProvider.of<LoginBloc>(context);
    this.loginBloc.nextScreen.listen((InfoUser user) {
      print("Push to a next screen");
      _formKey.currentState.reset();
      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) {
        return BlocProvider(bloc: AccountsBloc(), child: PageAccountsBloc(
          type: PageAccountsType.Home,
          currentInstanceID: 248,
        ));
      })).then((value){
        setState(() {
        });
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          body: new Container(
              padding: new EdgeInsets.all(20.0),
              child: new Center(
                child: new Form(
                    key: _formKey,
                    child: new ListView(
                      children: <Widget>[
                        new Container(
                          child: new Image.asset("assets/images/logo.png",
                              height: 50,
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.fitHeight),
                          margin: new EdgeInsets.only(top: 103, bottom: 30),
                        ),
                        new Container(
                          child: new Text("Welcome back.", style: Theme.of(context).textTheme.title
                          ),
                        ),
                        new Container(
                            margin: new EdgeInsets.only(top: 30, bottom: 30),
                            child: new TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter an username';
                                }
                              },
                              onSaved: (String value) {
                                this._data.username = value;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: new InputDecoration(
                                  hintText: 'Enter your email adress',
                                  labelText: 'Username'
                              ),
                            )
                        ),
                        new TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a password';
                            }
                          },
                          onSaved: (String value) {
                            this._data.password = value;
                          },
                          obscureText: (_showPassword == false),
                          textAlign: TextAlign.start,
                          decoration: new InputDecoration(
                              labelText: 'Password',
                              contentPadding: new EdgeInsets.all(0),
                              suffixIcon: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  //loginBloc
                                  child: IconButton(
                                      icon: const Icon(Icons.remove_red_eye),
                                      onPressed: () {
                                        setState(() {
                                          _showPassword = !_showPassword;
                                        });
                                      })
                              )
                          ),
                        ),
                        new Container(
                            margin: EdgeInsets.only(top: 30),
                            child: ButtonTheme(
                              height: 52.0,
                              child: new RaisedButton(
                                key: Key('SubmitButton'),
                                color: AppColors.blueTurquoise,
                                child: StreamBuilder(
                                    initialData: null,
                                    stream: this.loginBloc.resultLogin,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<InfoUser> snapshot) {
                                      print("------------------------");
                                      bool shouldShowCircular = (snapshot
                                          .connectionState ==
                                          ConnectionState.active &&
                                          !snapshot.hasError);
                                      print("shouldShowCircular? > $shouldShowCircular");
                                      print("Loading > ${snapshot.data
                                          .toString()}");
                                      print("connectionState > ${snapshot
                                          .connectionState}");
                                      print("hasError > ${snapshot.hasError}");
                                      print("------------------------");
                                      return (snapshot.connectionState ==
                                          ConnectionState.active &&
                                          !snapshot.hasError) ? Center(
                                        child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                            backgroundColor: Colors.white
                                        ),
                                      ) : Text("Login", style: TextStyle(color: Colors.white, fontSize: 16));
                                    }
                                ),
                                onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();

                                  String username = _data.username;
                                  String password = _data.password;

                                  InfoUser attemptedUser = InfoUser(
                                    user: User(
                                      username: username,
                                      password: password
                                    )
                                  );
//                                  attemptedUser.user.username = username;
//                                  attemptedUser.user.password = password;

                                  this.loginBloc.submitLogin.add(attemptedUser);
                                }
                                },
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(4),
                                ),
                              ),
                            )
                        ),
                        StreamBuilder(
                            initialData: null,
                            stream: this.loginBloc.resultLogin,
                            builder: (BuildContext context, AsyncSnapshot<InfoUser> snapshot) {
                              print("data > ${snapshot.data.toString()}");
                              if (snapshot.hasError) {
                                return new Text("${snapshot.error.toString()}", style: TextStyle(color: Colors.red, fontSize: 12, fontStyle: FontStyle.italic));
                              }
                              return Text("");
                            }
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            LinkAppButton(
                              onPressed: () {
                                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) {
                                  return PageResetPasswordBloc(
                                  );
                                }));
                              },
                              title: "Forgot your password?",
                              style: TextStyle(
                                color: AppColors.gray,
                                decoration: TextDecoration.underline
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                ),
              )
          )
      );
  }
}