import 'package:evently_app_abbas/core/extensions/date_time_ex.dart';
import 'package:evently_app_abbas/core/sources/assets_manager.dart';
import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/core/utils/dialog_utils.dart';
import 'package:evently_app_abbas/core/widgets/custom_elevted_button.dart';
import 'package:evently_app_abbas/core/widgets/custom_tab_bar.dart';
import 'package:evently_app_abbas/core/widgets/custom_text_form_field.dart';
import 'package:evently_app_abbas/core/widgets/cutom_text_button.dart';
import 'package:evently_app_abbas/firebase_service/firebase_services.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:evently_app_abbas/models/category_model.dart';
import 'package:evently_app_abbas/models/event_mode.dart';
import 'package:evently_app_abbas/models/user_model.dart';
import 'package:flutter/material.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  DateTime currentDateTime = DateTime.now(); /// 14-9-2026 - 6:012

  /// 14-9-2026 , 6:01:00:000
  TimeOfDay currentTime = TimeOfDay.now();
  late TextEditingController titleController;
  late TextEditingController desController;
  CategoryModel selectedCategory = CategoryModel.categories[0];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController = TextEditingController();
    desController = TextEditingController();
  }
  @override
  void dispose() {
   titleController.dispose();
   desController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
     // resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(appLocalizations.add_event)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ColorsManager.grey, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(ImageAssets.meeting),
              ),
            ),
            SizedBox(height: 16),
            CustomTabBar(
              onSelectedCategoryClicked: (category){

                setState(() {
                  selectedCategory = category;
                });

              },
              categories: CategoryModel.categories,
              selectedBgColor: ColorsManager.darkBlue,
              selectedFgColor: ColorsManager.white,
              unSelectedBgColor: ColorsManager.white,
              unSelectedFgColor: ColorsManager.black,
            ),
            SizedBox(height: 16),
            Text(appLocalizations.event_title, style: Theme.of(context).textTheme.displaySmall),
            SizedBox(height: 8),
            CustomTextFormField(
                controller: titleController,
                hintText: appLocalizations.event_title),
            SizedBox(height: 16),
            Text(
              appLocalizations.description,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            SizedBox(height: 8),
            CustomTextFormField(
                controller: desController,
                hintText: appLocalizations.event_description, lines: 4),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.date_range_outlined),
                SizedBox(width: 8),
                Text(
                  currentDateTime.toFormattedDate,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Spacer(),
                CustomTextButton(text: appLocalizations.choose_date, onTap: _chooseEventDate),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.date_range_outlined),
                SizedBox(width: 8),
                Text(
                  currentDateTime.toFormattedTime,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Spacer(),
                CustomTextButton(text: appLocalizations.choose_time, onTap: _chooseEventTime),
              ],
            ),

            Spacer(),
            CustomElevatedButton(title: appLocalizations.add_event, onPress:_addEVent),
          ],
        ),
      ),
    );
  }

  void _addEVent()async{
    EventModel event = EventModel(ownerId: UserModel.loggedInUser!.id,id: "", category: selectedCategory, title: titleController.text, description: desController.text, dateTime: currentDateTime);
  DialogUtils.showLoading(context, dismissible: false);
    await FirebaseServices.addEventToFireStore(event);
    DialogUtils.hideDialog(context);
    DialogUtils.showToast("Event Created", Colors.green);
    Navigator.pop(context);

  }

  void _chooseEventDate() async {
    currentDateTime =
        await showDatePicker(
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
          initialDate: DateTime.now(),
        ) ??
        currentDateTime;

    currentDateTime = currentDateTime.copyWith(
      hour: currentTime.hour,
      minute: currentTime.minute,
    );
    setState(() {});
  }

  void _chooseEventTime() async {
    currentTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now()) ??
        currentTime;

    currentDateTime = currentDateTime.copyWith(
      hour: currentTime.hour,
      minute: currentTime.minute,
    );
    setState(() {});
  }
}
