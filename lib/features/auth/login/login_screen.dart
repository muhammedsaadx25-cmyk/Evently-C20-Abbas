import 'package:evently_app_abbas/core/sources/colors_manager.dart';
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
import 'package:flutter/material.dart';

import '../../../core/sources/assets_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
     AppLocalizations? appLocalization = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(ImageAssets.eventlyLogo, color: Theme.of(context).primaryColor),
                Text(
                  appLocalization?.login_to_your_account ?? "",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  validator: Validator.validateEmail,
                  controller: emailController,
                  hintText: appLocalization?.enter_your_email ?? "",
                  prefixIcon: Icon(Icons.email),
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  validator: Validator.validatePassword,
                  controller: passwordController,
                  hintText: appLocalization?.enter_your_password ?? '',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility),
                ),
                SizedBox(height: 8,),
                CustomTextButton(text: "${appLocalization?.forget_password}? ", textAlign: TextAlign.end,onTap: () {}),
                SizedBox(height: 52),
                CustomElevatedButton(title: appLocalization?.login ?? "", onPress: login),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${appLocalization?.already_have_an_account}? ",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                    CustomTextButton(text: appLocalization?.sing_up ?? "", onTap: () {
                      Navigator.pushReplacementNamed(context, RoutesManager.register);
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void login()async{
    if(formKey.currentState!.validate() == false) return;
    try{
      DialogUtils.showLoading(context, dismissible: false);
      UserCredential userCredential = await FirebaseServices.login(email: emailController.text, password: passwordController.text);

     UserModel user = await  FirebaseServices.getUserFromFireStore(userCredential.user!.uid);
UserModel.loggedInUser = user;
      DialogUtils.hideDialog(context);
      DialogUtils.showToast("User Logged-In Successfully", Colors.green);
      Navigator.pushReplacementNamed(context, RoutesManager.mainLayout);
    }on FirebaseAuthException catch(exception){
      DialogUtils.hideDialog(context);
      DialogUtils.showDialogMessage(context, message: "Wrong email or password.",posTitle: "Try again",);
    }catch(exception){
      DialogUtils.hideDialog(context);
      DialogUtils.showDialogMessage(context, message: exception.toString(),posTitle: "Try again",);
    }


  }

}
