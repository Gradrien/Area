import 'package:client_mobile/models/button.dart';
import 'package:client_mobile/models/input_field.dart';
import 'package:client_mobile/models/show_dialog.dart';
import 'package:client_mobile/router/route_utils.dart';
import 'package:client_mobile/services/auth_services.dart';
import 'package:client_mobile/styles/glassmorphism_style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Login form widget for the app.
class LoginForm extends StatefulWidget {
  /// Constructor for the `LoginForm` widget.
  /// 
  const LoginForm({Key? key}) : super(key: key);
  @override
  _LoginFormState createState() => _LoginFormState();
}

/// State class for the `LoginForm` widget.
class _LoginFormState extends State<LoginForm> {
  /// Global key for the `Form` widget.
  final _formKey = GlobalKey<FormState>();
  /// Check if email is valid or not.
  bool shrinkEmail = false;
  /// Check if password is valid or not.
  bool shrinkPwd = false;

  /// Email input field.
  final TextEditingController _emailController = TextEditingController();
  /// Password input field.
  final TextEditingController _passwordController = TextEditingController();

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
                        SvgPicture.asset("assets/authHeader.svg",
                            width: 231, height: 155),
                        _title(),
                        _emailField(),
                        _passwordField(),
                        _loginButton(context),
                        _registerField(context),
                        _divider(),
                        _connectWithGoogle(context),
                        const SizedBox(height: 18),
                        _showDialogIp(context),
                      ]),
                ),
              ),
            ))));
  }

  Widget _title() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 21.0),
      child: Text("Mingle", style: TextStyle(fontSize: 24)),
    );
  }

  Widget _passwordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 21.0),
      child: GlassContainerRounded(
        colorOpacity: 0.5,
        width: 310,
        height: shrinkPwd == true ? 70 : 50,
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

  Widget _emailField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 21.0),
      child: GlassContainerRounded(
        width: 310,
        height: shrinkEmail == true ? 70 : 50,
        borderRadius: 15,
        borderColor: Colors.white,
        colorOpacity: 0.5,
        child: InputField(
          controller: _emailController,
          hintText: "Adresse email",
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

  Widget _loginButton(context) {
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
              authService.login(
                  _emailController.text, _passwordController.text, context);
            }
          },
          text: 'Continuer',
        ),
      ),
    );
  }

  Widget _registerField(context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 21.0),
      child: RichText(
          text: TextSpan(
        text: "Vous n'avez pas de compte ? ",
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'Créer un compte',
            style: const TextStyle(
              color: Color.fromARGB(255, 76, 90, 246),
              fontSize: 15,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async =>
                  GoRouter.of(context).goNamed(AppPage.register.toName),
          ),
        ],
      )),
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

  // Widget _connectWithGoogle(context) {
  //   return GlassContainerRounded(
  //     width: 310,
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

  Widget _buildConnectButton(BuildContext context, String serviceIcon,
      void Function()? func, String service) {
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
        onPressed: func,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
                "assets/$serviceIcon.svg"), // Utilisez le nom du service pour l'icône
            const SizedBox(width: 12),
            Text(
              'Se connecter avec $service', // Utilisez le nom du service pour le libellé
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _connectWithGoogle(context) {
    return _buildConnectButton(context, 'googleIcon', () async {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.loginWithGoogle();
    }, "Google");
  }
}