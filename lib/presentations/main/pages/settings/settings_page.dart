import 'package:e_commerce_clean/app/app_prefs.dart';
import 'package:e_commerce_clean/app/di.dart';
import 'package:e_commerce_clean/data/data_source/local_data_source.dart';
import 'package:e_commerce_clean/presentations/resources/values_manager.dart';
import 'package:flutter/material.dart';

import '../../../resources/routes.dart';
import '../../../resources/strings_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final AppPreferences _appPreferences = instance<AppPreferences>();
  final LocalDataSource _localDataSource = instance<LocalDataSource>();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView(
      padding: const EdgeInsets.all(AppPadding.p8),
      children: [
        ListTile(
          leading: const Icon(
            Icons.language,
          ),
          title: Text(
            AppStrings.changeLanguage,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing: const Icon(
            Icons.arrow_back_outlined,
          ),
          onTap: () {
            _changLanguage();
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.contacts,
          ),
          title: Text(
            AppStrings.contactUs,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing: const Icon(
            Icons.arrow_back_outlined,
          ),
          onTap: () {
            _contactUs() ;
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.info,
          ),
          title: Text(
            AppStrings.inviteYourFriends,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing: const Icon(
            Icons.arrow_back_outlined,
          ),
          onTap: () {
            _inviteFriends();
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.logout_outlined,
          ),
          title: Text(
            AppStrings.logout,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing: const Icon(
            Icons.arrow_back_outlined,
          ),
          onTap: () {
            _logout() ;
          },
        ),
      ],
    ));
  }

  _changLanguage(){
    /// i will implement it later

  }
  _contactUs(){
    /// its a task for you to open any webpage using URL

  }
  _inviteFriends(){
    /// its a task for you to share app name to friends

  }
  _logout(){
    /// app pref make that user logged out
    _appPreferences.logout() ;
    /// clear cache of logged
    _localDataSource.clearCache() ;

    Navigator.pushReplacementNamed(context, Routes.loginRoute)    ;
  }
}
