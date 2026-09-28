import 'package:evently_app_abbas/config/theme/theme_manager.dart';
import 'package:evently_app_abbas/core/prefs_manager/prefs_manager.dart';
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



void main()async {
WidgetsFlutterBinding.ensureInitialized();
 await  PrefsManager.init();
await  Firebase.initializeApp();
if(FirebaseAuth.instance.currentUser != null){
  UserModel.loggedInUser = await FirebaseServices.getUserFromFireStore(FirebaseAuth.instance.currentUser!.uid);
}
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LangProvider()),
      ],
      child: const Evently(),
    ),);
}

class Evently extends StatelessWidget {
  const Evently({super.key});

  @override
  Widget build(BuildContext context) {

    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    LangProvider langProvider = Provider.of<LangProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: FirebaseAuth.instance.currentUser == null? RoutesManager.login: RoutesManager.mainLayout,
      onGenerateRoute: RoutesManager.getRoute,
      theme: ThemeManager.light,
      darkTheme: ThemeManager.dark,
      themeMode:themeProvider.currentTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: [Locale('en'), Locale('ar')],
      locale: Locale(langProvider.currentLanguage),
    );
  }
}
