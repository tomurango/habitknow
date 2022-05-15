//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'login.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  //この２行を加える
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDr_SqOjl7wxar2Qzr8E79UihP-0uB3iHg",
      appId: "1:813734678252:web:96bb9ba5ffd83664541fc9",
      messagingSenderId: "813734678252",
      projectId: "habitknow-f8d11"
    ),
  );

  runApp(MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      //app name
      title: 'My To do App',
      theme: ThemeData(
        //theme color
        primarySwatch: Colors.blue,
      ),
      //display page for list
      home: TodoListPage(),
      //home: TodoListPage(key: PageStorageKey<String>("key_Page1")),
    );
  }
}

//widget for display list
class TodoListPage extends StatefulWidget{
  //pageStorage
  //TodoListPage({Key key}) : super(key: key);

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  //現在ログインしてるユーザ
  //User _user;
  //Todoリストのデータ
  List<String> todoList = [];
  //firebase auth
  final _auth = FirebaseAuth.instance;
  var user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user_init) {
      if (user_init == null) {
        print('User is currently signed out!');
        setState(() {
          user = null;
        });
      } else {
        print('User is signed in!');
        setState(() {
          user = user_init;
          //print(user);
        });
        //print(user_init.displayName);
        //PageStorage.of(context).writeState(context, _auth);
      }
    });
  }
  /*
  @override
  void didChangeDependencies() {
    var p = PageStorage.of(context).readState(context);
    if (p != null) {
      _auth = p;
    } else {
      _params = Page1Params();
    }
    super.didChangeDependencies();
  }
  */
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('リスト一覧'),
        actions: <Widget>[
          if (user == null) TextButton(
            onPressed: (){
              // （1） 指定した画面に遷移する
              Navigator.push(context, MaterialPageRoute(
                // （2） 実際に表示するページ(ウィジェット)を指定する
                builder: (context) => LoginPage()
              ));
            },
            child: Text('ログイン'),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
          ),
          /*
          if (user != null) GestureDetector(
            onTap: (){
              // （1） 指定した画面に遷移する
              Navigator.push(context, MaterialPageRoute(
                // （2） 実際に表示するページ(ウィジェット)を指定する
                builder: (context) => LoginPage()
              ));
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL),
            ),
          ),*/
          
          
          if (user != null) Padding( // 推奨
            padding: EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: (){
                // （1） 指定した画面に遷移する
                Navigator.push(context, MaterialPageRoute(
                  // （2） 実際に表示するページ(ウィジェット)を指定する
                  builder: (context) => LoginPage()
                ));
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.photoURL),
              ),
            ),
          ),


          
          /*
          ElevatedButton(
            onPressed: () {},
            child: Image(
              //width: buttonWidth,
              image: AssetImage(user.photoURL),
              fit: BoxFit.contain,
            ),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(24),
            ),
          )
          */
          /*
          ElevatedButton(
            shape: CircleBorder(),
            child: ClipOval(
              child: Image(
                width: buttonWidth,
                image: AssetImage('assets/image-name.png'),
                fit: BoxFit.contain,
              )
            ),
          )
          */
          /*
          TextButton(
            onPressed: (){
              // （1） 指定した画面に遷移する
              Navigator.push(context, MaterialPageRoute(
                // （2） 実際に表示するページ(ウィジェット)を指定する
                builder: (context) => LoginPage()
              ));
            },
            child: Text('ログインしてる'),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
          )
          */
          
        ],
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index){
          return Card(
            child: ListTile(
              title: Text(todoList[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          //push to new screen
          final newListText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context){
              //choise todo add page
              return TodoAddPage();
            }),
          );
          if(newListText != null){
            //キャンセル時はnull
            setState(() {
              todoList.add(newListText);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TodoAddPage extends StatefulWidget {
  @override
  _TodoAddPageState createState() => _TodoAddPageState();
}

//Widget todo add page
class _TodoAddPageState extends State<TodoAddPage> {
  // 入力されたテキストをデータとしてもつ
  String _text = '';

  //データを元に表示するwidget
  @override
  Widget build(BuildContext context){
    /*
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });*/
    return Scaffold(
      appBar: AppBar(
        title: Text('リスト追加'),
      ),
      body: Container(
        padding: EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //入力されたテキストを表示
            Text(_text, style :TextStyle(color: Colors.blue)),
            const SizedBox(height: 8),
            //text入力
            TextField(
              //入力されたテキストの値を受け取る
              onChanged: (String value) {
                //データが変更したことを知らせる
                setState(() {
                  _text = value;
                });
              },
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop(_text);
                },
                child: Text('リスト追加', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              child: TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text('キャンセル'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}