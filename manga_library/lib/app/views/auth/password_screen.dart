
import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/services/auth_service.dart';

class PasswordScreen extends StatefulWidget {
  final AuthService authService;
  const PasswordScreen({super.key, required this.authService});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final String authType = GlobalData.settings['Tipo de Autenticação'];
  String _password = "";
  ConfigSystemController configSystemController = ConfigSystemController();

  // validation method
  void validatePassword(BuildContext context) {
    bool testAuth = widget.authService.login(_password);
    if (!testAuth) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Senha incorreta!'),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/imgs/new-icon-manga-mini.png'),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 80),
                child: TextField(
                  autofocus: true,
                  keyboardType: authType == "text"
                      ? TextInputType.text
                      : TextInputType.number,
                  cursorColor: configSystemController.colorManagement(),
                  decoration: InputDecoration(
                      fillColor: configSystemController.colorManagement()),
                  obscureText: true,
                  enableSuggestions: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) => validatePassword(context),
                  onChanged: (value) => _password = value,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 80),
                child: ElevatedButton(
                    style: ButtonStyle(
                      // configSystemController.colorManagement()
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          configSystemController.colorManagement()),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(8.0)),
                    ),
                    onPressed: () => validatePassword(context),
                    child: const Text("Entrar")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
