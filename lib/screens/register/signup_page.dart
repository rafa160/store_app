import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:storeapp/helpers/validators.dart';
import 'package:storeapp/models/user.dart';
import 'package:storeapp/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/screens/home/home.dart';

class SignUpPage extends StatelessWidget {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final User user = new User();

  final TextEditingController email = new TextEditingController();
  final TextEditingController password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('criar conta'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _key,
            child: Consumer<UserManager>(
              builder: (_, userManager, __) {
                return ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 40),
                      child: TextFormField(
                        decoration:
                            const InputDecoration(hintText: 'nome completo'),
                        enabled: !userManager.loading,
                        validator: (name) {
                          if (name.isEmpty)
                            return 'campo obrigatório';
                          else if (name.trim().split(' ').length <= 1)
                            return 'preencha seu nome completo';
                          return null;
                        },
                        onSaved: (name) => user.name = name,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 30),
                      child: TextFormField(
                        enabled: !userManager.loading,
                        decoration: const InputDecoration(hintText: 'e-mail'),
                        validator: (email) {
                          if (email.isEmpty)
                            return 'campo obrigatório';
                          else if (!emailValid(email)) return 'e-mail inválido';
                          return null;
                        },
                        onSaved: (email) => user.email = email,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 30),
                      child: TextFormField(
                        obscureText: true,
                        enabled: !userManager.loading,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'senha'),
                        buildCounter: (BuildContext context,
                                {int currentLength,
                                int maxLength,
                                bool isFocused}) =>
                            null,
                        maxLength: 6,
                        validator: (senha) {
                          if (senha.isEmpty)
                            return 'campo obrigatório';
                          else if (senha.length < 6) return 'senha muito curta';
                          return null;
                        },
                        onSaved: (senha) => user.password = senha,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 30),
                      child: TextFormField(
                        obscureText: true,
                        enabled: !userManager.loading,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: 'confirmação de senha'),
                        buildCounter: (BuildContext context,
                                {int currentLength,
                                int maxLength,
                                bool isFocused}) =>
                            null,
                        maxLength: 6,
                        validator: (senha) {
                          if (senha.isEmpty)
                            return 'campo obrigatório';
                          else if (senha.length < 6) return 'senha muito curta';
                          return null;
                        },
                        onSaved: (confirmPass) =>
                            user.confirmPassword = confirmPass,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 30),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 15,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          disabledColor:
                              Theme.of(context).primaryColor.withAlpha(100),
                          textColor: Colors.white,
                          child: userManager.loading
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                  strokeWidth: 5,
                                )
                              : Text(
                                  'criar conta',
                                  style: TextStyle(fontSize: 20),
                                ),
                          onPressed: userManager.loading
                              ? null
                              : () {
                                  if (_key.currentState.validate()) {
                                    _key.currentState.save();
                                    if (user.password != user.confirmPassword) {
                                      scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(Icons.error),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('senhas diferentes ')
                                          ],
                                        ),
                                        backgroundColor: Colors.red,
                                      ));
                                      return;
                                    }
                                    userManager.signUp(
                                        user: user,
                                        onSuccess: () {
                                          debugPrint('sucesso');
                                          Navigator.pushReplacement(context,MaterialPageRoute(builder: (_) => Home()));
                                        },
                                        onFail: (e) {
                                          scaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                            content: Row(
                                              children: [
                                                Icon(Icons.error),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text('$e')
                                              ],
                                            ),
                                            backgroundColor: Colors.red,
                                          ));
                                        });
                                  }
                                },
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
