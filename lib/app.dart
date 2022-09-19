import 'package:Reminder/src/bloc/main_bloc/main_bloc.dart';
import 'package:Reminder/src/bloc/set_reminder_bloc/set_reminder_bloc.dart';
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
          create: (context) => ObjectBoxHelper(),
          lazy: true,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MainBloc(),
            lazy: true,
          ),
          BlocProvider(
            create: (context) =>
                SetReminderBloc(
                    objectBoxHelper: RepositoryProvider.of<ObjectBoxHelper>(context)),
            lazy: true,
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('fa'),
          home: MainScreen(),
          initialRoute: kMainScreenRoute,
          onGenerateRoute: AppRoutes.generateRoute,
        ),
      ),
    );
  }
}
