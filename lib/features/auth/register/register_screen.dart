import 'package:evently_app_abbas/core/sources/assets_manager.dart';
import 'package:evently_app_abbas/core/sources/routes_manager.dart';
import 'package:evently_app_abbas/core/sources/validator.dart';
import 'package:evently_app_abbas/core/utils/dialog_utils.dart';
import 'package:evently_app_abbas/core/widgets/custom_elevted_button.dart';
import 'package:evently_app_abbas/core/widgets/custom_text_form_field.dart';
import 'package:evently_app_abbas/core/widgets/cutom_text_button.dart';
import 'package:evently_app_abbas/firebase_service/firebase_services.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:evently_app_abbas/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController nameController;

  late TextEditingController emailController;

  late TextEditingController passwordController;

  late TextEditingController passwordConfirmationController;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmationController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  ImageAssets.eventlyLogo,
                  color: Theme.of(context).primaryColor,
                ),
                Text(
                  appLocalizations.create_your_account,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  validator: Validator.validateName,
                  controller: nameController,
                  hintText: appLocalizations.enter_your_name,
                  prefixIcon: Icon(Icons.person),
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  validator: Validator.validateEmail,
                  controller: emailController,
                  hintText: appLocalizations.enter_your_email,
                  prefixIcon: Icon(Icons.email),
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  validator: Validator.validatePassword,
                  controller: passwordController,
                  hintText: appLocalizations.enter_your_password,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility),
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  validator: (input) {
                    if (input != passwordController.text) {
                      return "Password dose not match";
                    }
                    return null;
                  },
                  controller: passwordConfirmationController,
                  hintText: appLocalizations.confirm_your_password,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility),
                ),

                SizedBox(height: 52),
                CustomElevatedButton(
                  title: appLocalizations.sing_up,
                  onPress: _createAccount,
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${appLocalizations.already_have_an_account}? ",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                    CustomTextButton(
                      text: appLocalizations.login,
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          RoutesManager.login,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createAccount() async {
    if (_formKey.currentState!.validate() == false) return;
    try {
      DialogUtils.showLoading(context, dismissible: false);
      UserCredential userCredential = await FirebaseServices.createAccount(email: emailController.text, password: passwordController.text);
      UserModel user = UserModel(id: userCredential.user!.uid, name: nameController.text, email: emailController.text);
      await FirebaseServices.addUserToFireStore(user);
      DialogUtils.hideDialog(context);
      DialogUtils.showToast("User Registered Successfully", Colors.green);
    Navigator.pushReplacementNamed(context, RoutesManager.login);
    } on FirebaseAuthException catch (exception) {
      DialogUtils.hideDialog(context);
      if (exception.code == 'weak-password') {
        DialogUtils.showDialogMessage(context, message: "The password provided is too weak.", posTitle: "Try again", posAction: (){
          Navigator.pop(context);
        });

      } else if (exception.code == "email-already-in-use") {
        DialogUtils.showDialogMessage(context, message: "The account already exists for that email.", posTitle: "Try again", posAction: (){
          Navigator.pop(context);
        });

      }
    } catch (exception) {
      DialogUtils.hideDialog(context);
      DialogUtils.showDialogMessage(context, message: exception.toString(), posTitle: "Try again", posAction: (){
        Navigator.pop(context);
      });

    }
  }
}
