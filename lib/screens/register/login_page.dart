import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:storeapp/helpers/validators.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/user.dart';
import 'package:storeapp/models/user_manager.dart';
import 'package:storeapp/screens/register/signup_page.dart';



class LoginPage extends StatelessWidget {

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  
  final TextEditingController email = new TextEditingController();
  final TextEditingController password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('entrar'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Image(
                // fit: BoxFit.cover,
                image: AssetImage('assets/logo1.jpg'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
              child: Center(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Form(
                    key: _key,
                    child: Consumer<UserManager>(
                      builder: (_, userManager, child){
                        return ListView(
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 1,left: 10,right: 10),
                          shrinkWrap: true,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 30),
                              child: TextFormField(
                                controller: email,
                                enabled: !userManager.loading,
                                decoration: InputDecoration(hintText: 'e-mail'),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                validator: (email){
                                  if(!emailValid(email))
                                    return 'e-mail inválido';
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 30),
                              child: TextFormField(
                                enabled: !userManager.loading,
                                controller: password,
                                decoration: InputDecoration(hintText: 'senha'),
                                keyboardType: TextInputType.number,
                                autocorrect: false,
                                obscureText: true,
                                buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                                maxLength: 6,
                                validator: (senha){
                                  if(senha.isEmpty)
                                    return 'campo obrigatório';
                                  else if (senha.length < 6)
                                    return 'senha muito curta';
                                  return null;
                                },
                              ),
                            ),
                            child,
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 15,
                              child: RaisedButton(
                                disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                                onPressed: userManager.loading ? null : (){
                                  if(_key.currentState.validate()) {
                                    userManager.signIn(
                                        user:User(
                                            email: email.text,
                                            password: password.text
                                        ),
                                        onFail: (e) {
                                          scaffoldKey.currentState.showSnackBar(
                                              SnackBar(
                                                content: Row(
                                                  children: [
                                                    Icon(Icons.error),
                                                    SizedBox(width: 10,),
                                                    Text('$e')
                                                  ],
                                                ),
                                                backgroundColor: Colors.red,
                                              )
                                          );
                                        },
                                        onSucess: () {
                                          Navigator.of(context).pop();
                                        }
                                    );
                                  }
                                },
                                color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                child:userManager.loading ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                      Colors.white
                                  ),
                                  strokeWidth: 5,
                                ) : Text('entrar', style: TextStyle(fontSize: 20),),
                              ),
                            ),
                            SizedBox(height: 15,),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 15,
                              child: SignInButton(
                                Buttons.Facebook,
                                onPressed: () {
                                  userManager.facebookLogin(
                                      onFail: (e) {
                                        scaffoldKey.currentState.showSnackBar(
                                            SnackBar(
                                              content: Row(
                                                children: [
                                                  Icon(Icons.error),
                                                  SizedBox(width: 10,),
                                                  Text('$e')
                                                ],
                                              ),
                                              backgroundColor: Colors.red,
                                            )
                                        );
                                      },
                                      onSuccess: () {
                                        Navigator.of(context).pop();
                                      }
                                  );
                                },
                                text: userManager.loadingFb ? 'carregando...' : 'entrar com facebook',
                                elevation: 5,
                              ),
                            ),
                            // SizedBox(height: 15,),
                            // SizedBox(
                            //   height: MediaQuery.of(context).size.height / 15,
                            //   child: SignInButton(
                            //     Buttons.Google,
                            //     onPressed: (){
                            //
                            //     },
                            //     text: 'entrar com Google',
                            //   ),
                            // ),
                          ],
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 30),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            onPressed: (){

                            },
                            padding: EdgeInsets.zero,
                            child: const Text('esqueci minha senha.'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.width / 10),
              child: FlatButton(
                onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder: (_) => SignUpPage()));
                },
                child: Text('não tem conta?', style: TextStyle(color: Colors.black, fontSize: 15),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
