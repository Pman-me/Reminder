
import 'package:Reminder/src/bloc/main_bloc/main_bloc.dart';
import 'package:Reminder/src/bloc/set_notif_bloc/set_notify_bloc.dart';
import 'package:Reminder/src/configs/app_routes.dart';
import 'package:Reminder/src/configs/app_theme.dart';
import 'package:Reminder/src/core/constants/route_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import 'src/data/local/object_box_helper.dart';
import 'src/view/main_screen/main_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotifyMeApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => MainBloc(),
          lazy: true,
        ),
        RepositoryProvider(
          create: (context) => ObjectBoxHelper(),
          lazy: true,
        ),
        RepositoryProvider(
          create: (context) => SetNotifyBloc(objectBoxHelper: RepositoryProvider.of<ObjectBoxHelper>(context)),
          lazy: true,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('fa'),
        home:  MainScreen(),
        initialRoute: kMainScreenRoute,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
