import 'package:evently_app_abbas/core/sources/assets_manager.dart';
import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/core/sources/routes_manager.dart';
import 'package:evently_app_abbas/firebase_service/firebase_services.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:evently_app_abbas/models/user_model.dart';
import 'package:evently_app_abbas/providers/lang_provider.dart';
import 'package:evently_app_abbas/providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    LangProvider langProvider = Provider.of<LangProvider>(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 38, horizontal: 8),
        child: Column(
          children: [
            Image.asset(ImageAssets.profilePic),
            SizedBox(height: 16),
            Text(
             UserModel.loggedInUser!.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
             UserModel.loggedInUser!.email,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      appLocalizations.dark_mode,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Spacer(),
                    Switch(
                      activeColor: ColorsManager.darkBlue,

                      value: themeProvider.isDark,
                      onChanged: (isDarkEnabled) {

                        if (isDarkEnabled) {

                        themeProvider.changeAppTheme(ThemeMode.dark);
                        }else{
                           themeProvider.changeAppTheme(ThemeMode.light);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      appLocalizations.language,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Spacer(),

                    DropdownButton(
                      icon: Icon(Icons.arrow_forward_ios_outlined),
                      underline: Container(),
                      items: ["English", "Arabic"]
                          .map(
                            (val) =>
                                DropdownMenuItem(value: val, child: Text(val, style: Theme.of(context).textTheme.bodyMedium,)),
                          )
                          .toList(),
                      onChanged: (newLang) {
                        if(newLang == "English"){
                          langProvider.changeAppLang('en');
                        }else{
                          langProvider.changeAppLang('ar');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: ()async{
               await FirebaseServices.logOut();
                Navigator.pushReplacementNamed(context, RoutesManager.login);
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        appLocalizations.logout,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Spacer(),

                      Icon(Icons.logout),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
