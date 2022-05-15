
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'main.dart';

class LoginPage extends StatefulWidget{
  //pageStorage
  //TodoListPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
//class LoginPage extends StatelessWidget {
  // Googleを使ってサインイン
  

  var user;
  final _googleSignIn = new GoogleSignIn();
  final _auth = FirebaseAuth.instance;

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
        });
        //PageStorage.of(context).writeState(context, _auth);
      }
    });
  }



  Future<UserCredential> signInWithGoogle() async {
    // 認証フローのトリガー
    final googleUser = await GoogleSignIn(scopes: [
      'email',
    ]).signIn();
    //errorが出るのでnull check
    if(googleUser != null){
      // リクエストから、認証情報を取得
      final googleAuth = await googleUser.authentication;
      // クレデンシャルを新しく作成
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // サインインしたら、UserCredentialを返す
      return FirebaseAuth.instance.signInWithCredential(credential);
    }else{
      //とりあえず匿名でログインする感じにした
      return FirebaseAuth.instance.signInAnonymously();
    }
  }
  /*
  Future<User> _handleGoogleSignIn() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;
    User user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print("signed in " + user.displayName);
    return user;
  }*/

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            child: IconButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.clear),
              iconSize: 24,
            ),
          ),
          Positioned(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SignInButton(
                    Buttons.Google,
                    onPressed: () async {
                      //ここでgoogle login
                      /*
                      try {
                        final userCredential = await signInWithGoogle();
                      } on FirebaseAuthException catch (e) {
                        print('FirebaseAuthException');
                        print('${e.code}');
                      } on Exception catch (e) {
                        print('Other Exception');
                        print('${e.toString()}');
                      }*/
                      signInWithGoogle().then((usercredential) {
                        setState(() {
                          //print(usercredential);
                          //print(usercredential.user);
                          user = usercredential.user;
                          if(user != null){
                            print(user.displayName);
                          }else{
                            print("user is null");
                          }
                        });
                      }).catchError((error) {
                        print(error);
                      });
                    }, 
                  ),
                  if (user != null) TextButton(onPressed: () async {
                    // ログアウト処理
                    // 内部で保持しているログイン情報等が初期化される
                    // （現時点ではログアウト時はこの処理を呼び出せばOKと、思うぐらいで大丈夫です）
                    await FirebaseAuth.instance.signOut();
                    // ログイン画面に遷移＋チャット画面を破棄
                    //Navigator.of(context).pop();
                    /*await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        //return TodoListPage();//LoginPage();
                        Navigator.of(context).pop();
                      }),
                    );},*/
                  },
                    child: Text('ログアウト')
                  )
                ],
              )
            ),
          )
        ],
      )
    );
  }
}

class SignInDemo extends StatefulWidget {
  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}