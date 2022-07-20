import 'package:Reminder/src/configs/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../bloc/main_bloc/main_bloc.dart';
import '../../configs/app_routes.dart';
import '../../core/constants/general_constant.dart';
import '../../core/constants/route_constant.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    localization = localization ?? AppLocalizations.of(context);
    return BlocProvider(
      create: (context) => RepositoryProvider.of<MainBloc>(context),
      child: BlocConsumer<MainBloc, MainState>(
        buildWhen: (previous,current){
          if(current is MainInitial) {
            return true;
          } else {
            return false;
          }
        },
        listener: (context,state){
          _navigateToSetNotifyScreen(context);
        },
        builder: (context, state) {
          return Scaffold(
            body: _MainWidget(),
            floatingActionButton: _MainFab(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }

  _navigateToSetNotifyScreen(BuildContext context) {
    Navigator.of(context).push(
        AppRoutes.generateRoute(const RouteSettings(name: kSetNotifScreenRoute)));
  }
}

class _MainWidget extends StatelessWidget {
  const _MainWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            ColorName.secondaryColor,
            ColorName.darkPrimaryColor,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Assets.images.notificationBell
              .svg(width: 150, height: 150, color: ColorName.white),
        ],
      ),
    );
  }
}

class _MainFab extends StatelessWidget {
  _MainFab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: OutlinedButton.icon(
        onPressed: () {
          context.read<MainBloc>().add(MainNavigatedToSetNotifyScreen());
        },
        label: Text(
          localization!.add,
          style: lightTheme.textTheme.bodyText1!
              .apply(color: lightTheme.colorScheme.onPrimary),
        ),
        icon: Icon(
          Icons.notification_add_outlined,
          color: lightTheme.colorScheme.onPrimary,
        ),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          side: BorderSide(color: lightTheme.colorScheme.onPrimary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }


}
