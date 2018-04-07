import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

var url = 'https://shakeeb.xyz/thllpbonds/';
var username = '';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'THLLP FUNDS',
        theme: new ThemeData.dark(),
        routes: {
          "/": (_) => new Home(),
          "/webview": (_) => new Home(),
        }
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    var homeState = new HomeState();
    return homeState;
  }
}

class HomeState extends State<Home> {
  final webView = new FlutterWebviewPlugin();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController controller = new TextEditingController(text: username);

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<SharedPreferences>(
        future: _prefs,
        builder: (BuildContext context,
            AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Text('Loading...');
          controller.text = snapshot.requireData.getString('username');
          // ignore: prefer_const_constructors
          if (controller.text.length == 0)
            return new Scaffold(
                appBar: new AppBar(
                  title: new Text("THLLP BONDS"),
                  leading: null,
                ),
                body: new Center(
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        padding: new EdgeInsets.all(10.0),
                        child: new TextField(
                          controller: controller,
                        ),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new RaisedButton(
                            child: new Text('LOGIN'),
                            onPressed: () {
                              _putUserName(username);
                              Navigator.of(context).pushNamed("/webview");
                            },
                          ),
                          new RaisedButton(
                            child: new Text('NEW USER'),
                            onPressed: () {
                              controller.text = '';
                              _putUserName('');
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                )
            );
          else
            return new WebviewScaffold(
              url: url + username,
              withJavascript: true,
              withLocalStorage: true,
              appBar: new AppBar(
                  title: new Text("THLLP BONDS"),
                  automaticallyImplyLeading: false,
                  actions: <Widget>[new IconButton(icon: new ExpandIcon(), onPressed: () {
                    _putUserName('');
                    Navigator.of(context)
                        .pushReplacementNamed ('/');
                  }),]
              ),
            );
        });
  }

  @override
  void initState() {
    super.initState();

    webView.close();

    controller.addListener(() {
      username = controller.text;
    });
  }

  @override
  void dispose() {
    webView.dispose();
    controller.dispose();
    super.dispose();
  }
}

//Future<Null> _getUserName() async {
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//  username = prefs.getString('username');
//}

Future<Null> _putUserName(username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('username', username);
}