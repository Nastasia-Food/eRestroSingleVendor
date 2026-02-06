import 'package:erestro_single_vender_rider/app/routes.dart';
import 'package:erestro_single_vender_rider/cubit/auth/authCubit.dart';
import 'package:erestro_single_vender_rider/ui/screen/settings/maintenance_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

const String appName = "eRestro Singlevendor Rider";
const String packageName = "com.wrteam.erestroSingleVenderRider";
const String androidLink = 'https://play.google.com/store/apps/details?id=';
const String iosPackage = 'com.wrteam.erestroSingleVenderRider';
const String iosLink = 'https://apps.apple.com/id';
const String iosAppId = '6459792950';

//Database related constants

//Add your database url
const String databaseUrl = 'PLACE_BASE_URL';
const String perPage = "10";
String defaulIsoCountryCode = 'IN';
const String defaulCountryCode = '+91';

const String googleAPiKeyAndroid = "PLACE_ANDROID_MAP_KEY";
const String googleAPiKeyIos = "PLACE_IOS_MAP_KEY";

const String defaultErrorMessage = "Something went wrong!!";
const String connectivityCheck = "ConnectivityResult.none";
const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
const String tockenExpireCode = "102";

//by default language of the app
const String defaultLanguageCode = "en";

getUserLocation() async {
  LocationPermission permission;

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.deniedForever) {
    await Geolocator.openLocationSettings();

    getUserLocation();
  } else if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
      await Geolocator.openLocationSettings();

      getUserLocation();
    } else {
      getUserLocation();
    }
  } else {}
}

isMaintenance(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => const MaintenanceScreen(),
    ),
  );
}

//When jwt key expire reLogin
reLogin(BuildContext context) {
  context.read<AuthCubit>().signOut();
  Navigator.of(context).pushNamedAndRemoveUntil(Routes.login, (Route<dynamic> route) => false, arguments: {'from': 'logout'});
}
