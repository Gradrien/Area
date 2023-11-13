import 'package:client_mobile/models/show_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../router/route_utils.dart';
import 'package:client_mobile/models/button.dart';
import 'package:client_mobile/models/input_field.dart';
import 'package:client_mobile/services/auth_services.dart';
import 'package:client_mobile/styles/glassmorphism_style.dart';

/// Register form widget
class RegisterForm extends StatefulWidget {
  /// Constructor for the `RegisterForm` widget.
  /// 
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

/// State for the `RegisterForm` widget.
class _RegisterFormState extends State<RegisterForm> {
  /// Global key for the `Form` widget.
  final _formKey = GlobalKey<FormState>();
  /// Check if email is valid or not.
  bool shrinkEmail = false;
  /// Check if name is valid or not.
  bool shrinkName = false;
  /// Check if password is valid or not.
  bool shrinkPwd = false;
  /// Check if password confirmation is valid or not.
  bool shrinkPwdConf = false;

  /// Controller for the `Name` input field.
  final TextEditingController _nameController = TextEditingController();
  /// Controller for the `Email` input field.
  final TextEditingController _emailController = TextEditingController();
  /// Controller for the `Password` input field.
  final TextEditingController _passwordController = TextEditingController();
  /// Controller for the `Password confirmation` input field.
  final TextEditingController _passwordConfController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(42.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/authHeader.svg",
                      width: 231,
                      height: 155,
                    ),
                    _title(),
                    _nameField(),
                    _emailField(),
                    _passwordField(),
                    _confirmPasswordField(),
                    _submitButton(context),
                    _returnBtn(context),
                    _divider(),
                    _registerWithGoogle(context),
                    const SizedBox(height: 18),
                    _showDialogIp(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 21.0),
      child: Text("Créer un compte", style: TextStyle(fontSize: 24)),
    );
  }

  Widget _emailField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 21.0),
      child: GlassContainerRounded(
        colorOpacity: 0.5,
        width: 310,
        height: shrinkEmail ? 70 : 50,
        borderRadius: 15,
        borderColor: Colors.white,
        child: InputField(
          controller: _emailController,
          hintText: "Email",
          validator: (value) {
            if (value == null || value.isEmpty || !value.contains("@")) {
              setState(() {
                shrinkEmail = true;
              });
              return "Veuillez entrer un email valide";
            }
            setState(() {
              shrinkEmail = false;
            });
            return null;
          },
        ),
      ),
    );
  }

  Widget _nameField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 21.0),
      child: GlassContainerRounded(
        colorOpacity: 0.5,
        width: 310,
        height: shrinkName ? 70 : 50,
        borderRadius: 15,
        borderColor: Colors.white,
        child: InputField(
          controller: _nameController,
          hintText: "Nom d'utilisateur",
          validator: (value) {
            if (value == null || value.isEmpty) {
              setState(() {
                shrinkName = true;
              });
              return "Veuillez entrer votre nom d'utilisateur";
            }
            setState(() {
              shrinkName = false;
            });
            return null;
          },
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 21.0),
      child: GlassContainerRounded(
        colorOpacity: 0.5,
        width: 310,
        height: shrinkPwd ? 70 : 50,
        borderRadius: 15,
        borderColor: Colors.white,
        child: InputField(
          controller: _passwordController,
          hintText: "Mot de passe",
          validator: (value) {
            if (value == null || value.isEmpty) {
              setState(() {
                shrinkPwd = true;
              });
              return "Veuillez entrer votre mot de passe";
            }
            setState(() {
              shrinkPwd = false;
            });
            return null;
          },
          obscureText: true,
        ),
      ),
    );
  }

  Widget _confirmPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 21.0),
      child: GlassContainerRounded(
        colorOpacity: 0.5,
        width: 310,
        height: shrinkPwdConf ? 70 : 50,
        borderRadius: 15,
        borderColor: Colors.white,
        child: InputField(
          controller: _passwordConfController,
          hintText: "Confirmation Mot de passe",
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              setState(() {
                shrinkPwdConf = true;
              });
              return "Veuillez confirmer votre mot de passe";
            }
            if (value != _passwordController.text) {
              setState(() {
                shrinkPwdConf = true;
              });
              return "Les mots de passe ne correspondent pas";
            }
            setState(() {
              shrinkPwdConf = false;
            });
            return null;
          },
        ),
      ),
    );
  }

  Widget _submitButton(context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 21.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromARGB(
            255,
            76,
            90,
            246,
          ),
        ),
        width: 310,
        height: 50,
        child: Button(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color.fromARGB(
              255,
              76,
              90,
              246,
            )),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final authService =
                  Provider.of<AuthService>(context, listen: false);
              final isRegistered = await authService.register(
                _emailController.text,
                _nameController.text,
                _passwordController.text,
                _passwordConfController.text,
                context
              );
              if (isRegistered) {
                GoRouter.of(context).goNamed(AppPage.login.toName);
              }
            }
          },
          text: "Continuer",
        ),
      ),
    );
  }
  
  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 21.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
          ),
          Text("OU",
              style: TextStyle(
                  color: Color.fromARGB(255, 76, 90, 246),
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          Expanded(
            child: Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _registerWithGoogle(context) {
    return GlassContainerRounded(
      width: 310,
      height: 50,
      borderRadius: 15,
      borderColor: Colors.white,
      colorOpacity: 0.5,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: () async {
            final authService =
                Provider.of<AuthService>(context, listen: false);
            final isRegistered = await authService.registerWithGoogle();
            if (isRegistered) {
              GoRouter.of(context).goNamed(AppPage.login.toName);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/googleIcon.svg"),
              const SizedBox(width: 12),
              const Text(
                'Se connecter avec Google',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          )),
    );
  }

  Widget _returnBtn(context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 21.0),
        child: RichText(
            text: TextSpan(
                text: "Vous avez déjà un compte ? ",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                children: <TextSpan>[
              TextSpan(
                text: 'Se connecter',
                style: const TextStyle(
                  color: Color.fromARGB(255, 76, 90, 246),
                  fontSize: 15,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async =>
                      GoRouter.of(context).goNamed(AppPage.login.toName),
              ),
            ])));
  }

  Widget _showDialogIp(context) {
    return GlassContainerRounded(
      width: 165,
      height: 50,
      borderRadius: 15,
      borderColor: Colors.white,
      colorOpacity: 0.5,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          showConfigDialog(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/settings.svg"),
            const Text("Configurer", style: TextStyle(color: Colors.black, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

