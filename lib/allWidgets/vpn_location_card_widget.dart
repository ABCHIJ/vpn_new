import 'dart:math'; // Importing for `log` and `pow`

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpnapp/allModels/vpn_info.dart';
import 'package:vpnapp/appPreferences/appPreferences.dart';
import 'package:vpnapp/vpnEngine/vpn_engine.dart';

import '../allControllers/controller_home.dart';

class VpnLocationCardWidget extends StatelessWidget {
  final VpnInfo vpnInfo;

  VpnLocationCardWidget({super.key, required this.vpnInfo});

  // Formatting speed from bytes to readable format
  String formatSpeedBytes(int speedBytes, int decimals) {
    if (speedBytes <= 0) {
      return '0 B/s';
    }
    const suffixesTitle = ['B/s', 'KB/s', 'MB/s', 'GB/s', 'TB/s'];
    var speedTitleIndex = (log(speedBytes) / log(1024)).floor();
    return '${(speedBytes / pow(1024, speedTitleIndex)).toStringAsFixed(decimals)} ${suffixesTitle[speedTitleIndex]}';
  }

  @override
  Widget build(BuildContext context) {
    final sizeScreen =
        MediaQuery.of(context).size; // Declared as local variable
    final homeController = Get.find<ControllerHome>();

    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: sizeScreen.height * 0.01),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          homeController.vpnInfo.value = vpnInfo;
          AppPreferences.vpnInfoObj = vpnInfo;
          Get.back();

          if (homeController.vpnConnectionStage.value ==
              VpnEngine.vpnConnectedNow) {
            VpnEngine.stopVpnNow();
            Future.delayed(const Duration(seconds: 3),
                () => homeController.connectToVpnNow());
          } else {
            homeController.connectToVpnNow();
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // country flag
          leading: SizedBox(
            width: sizeScreen.width *
                0.15, // Fixed width to prevent it from consuming the entire width
            height: 40, // Fixed height
            child: Container(
              padding: const EdgeInsets.all(0.5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Image.asset(
                'project/countryFlags/countryFlags/${vpnInfo.countryShortName}.png', // Corrected `countryShortName`
                fit: BoxFit.cover,
              ),
            ),
          ),

          // country name
          title: Text(vpnInfo.countryLongName),

          // vpn speed
          subtitle: Row(
            children: [
              const Icon(
                Icons.shutter_speed,
                color: Colors.redAccent,
                size: 20,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                formatSpeedBytes(vpnInfo.speed, 2),
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),

          // number of sessions
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                vpnInfo.vpnSessionsNum.toString(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color, // Changed from `bodyText1` to `bodyMedium`
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              const Icon(
                CupertinoIcons.person_2_alt,
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
