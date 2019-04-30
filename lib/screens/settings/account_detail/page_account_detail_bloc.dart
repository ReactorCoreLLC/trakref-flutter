import 'package:flutter/material.dart';
import 'package:trakref_app/main.dart';
import 'package:trakref_app/models/account.dart';
import 'package:trakref_app/widget/dropdown_widget.dart';

class PageAccountDetailBloc extends StatefulWidget {
  Account account;

  PageAccountDetailBloc({this.account});

  @override
  _PageAccountDetailBlocState createState() => _PageAccountDetailBlocState();
}

class _PageAccountDetailBlocState extends State<PageAccountDetailBloc> {

  @override
  void initState() {
    super.initState();

    setState(() {

    });
  }

  Widget buildTextfieldRow(String key, String label, String initialValue) {
    if (initialValue == null) {
      return Row(mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FormBuild.buildTextField(key: Key(key), label: label)
          ]
      );
    }
    return Row(mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          FormBuild.buildTextField(key: Key(key), label: label, initialValue: initialValue)
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            FlatButton(
              onPressed: () {

              },
              child: Text("Switch Account", style: TextStyle(
                  color: AppColors.blueTurquoise
              )),
            )
          ],
          leading: IconButton(
            icon: new Icon(Icons.arrow_back, color: AppColors.gray),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          elevation: 0.0,
          backgroundColor: Colors.white.withOpacity(0.0),
        ),
        body: SafeArea(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Text("Account Details",
                          style: Theme.of(context).textTheme.title,
                        )
                    )
                  ],
                ),
                buildTextfieldRow("AccountNameKey", "Account Name", widget.account.name),
                buildTextfieldRow("IndustryTypeKey", "Industry Type", widget.account.industryType),
                buildTextfieldRow("StatusKey", "Status", widget.account.statusName),
                buildTextfieldRow("ContactNumberKey", "Contact Number", widget.account.contactPhone),
                buildTextfieldRow("ContactEmailKey", "Contact Email", widget.account.contactEmail),
              ],
            )
        )
    );
  }
}