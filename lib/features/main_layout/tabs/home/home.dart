import 'package:evently_app_abbas/core/sources/assets_manager.dart';
import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/core/widgets/custom_tab_bar.dart';
import 'package:evently_app_abbas/core/widgets/event_item.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:evently_app_abbas/models/category_model.dart';
import 'package:evently_app_abbas/models/event_mode.dart';
import 'package:evently_app_abbas/models/user_model.dart';
import 'package:evently_app_abbas/providers/lang_provider.dart';
import 'package:evently_app_abbas/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    LangProvider langProvider =Provider.of<LangProvider>(context);
    ThemeProvider themeProvider =Provider.of<ThemeProvider>(context);
    return Container(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        "${appLocalizations.welcome_back} ✨",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                       UserModel.loggedInUser!.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  Spacer(),
                 IconButton(onPressed: (){
                   themeProvider.changeAppTheme(themeProvider.isDark ? ThemeMode.light : ThemeMode.dark);
                 }, icon:  Icon(themeProvider.isDark ? Icons.light_mode_rounded : Icons.dark_mode_outlined)),
                  SizedBox(width: 8,),
                  InkWell(
                    onTap: (){

                        langProvider.changeAppLang(langProvider.isEnglish?'ar':'en');

                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 8,
                        ),
                        child: Text(
                         langProvider.isEnglish ?  "Ar" : "En",
                          style: Theme.of(context).textTheme.bodyLarge
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12,),
              CustomTabBar(
                categories:   [CategoryModel(id: "1", name: "All", icon: Icons.all_inclusive, image: ImageAssets.meeting),...CategoryModel.categories, ],


                selectedBgColor: ColorsManager.darkBlue,
                selectedFgColor: ColorsManager.white,
                unSelectedBgColor: ColorsManager.white,
                unSelectedFgColor: ColorsManager.black,
              ),
              // Expanded(child: ListView.separated(
              //   padding: EdgeInsets.only(top: 16),
              //     itemBuilder: (context,index)=>EventItem(event: EventModel(id: "", category: CategoryModel.categories[0], title: "Meeting for Updating The Development Method ", description: "Meeting for Updating The Development Method ", dateTime: DateTime.now(),),),
              //     separatorBuilder: (context, index)=>SizedBox(height: 8,),
              //     itemCount: 20))
            ],
          ),
        ),
      ),
    );
  }
}
