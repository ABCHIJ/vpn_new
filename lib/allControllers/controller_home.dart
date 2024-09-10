import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpnapp/allModels/vpn_configuration.dart';
import 'package:vpnapp/allModels/vpn_info.dart';
import 'package:vpnapp/appPreferences/appPreferences.dart';

import '../vpnEngine/vpn_engine.dart';

class ControllerHome extends GetxController {
  // Correct static access to vpnInfoObj
  final Rx<VpnInfo> vpnInfo = AppPreferences.vpnInfoObj.obs;
  final vpnConnectionStage = VpnEngine.vpnDisconnectedNow.obs;

  void connectToVpnNow() async {
    try {
      if (vpnInfo.value.base64OpenVPNConfiguration.isEmpty) {
        Get.snackbar(
            'Country / Location', 'Please select Country / Location first');
        return;
      }
      // disconnected
      if (vpnConnectionStage.value == VpnEngine.vpnDisconnectedNow) {
        // Decode the base64 configuration data
        final dataConfigVpn =
            base64Decode(vpnInfo.value.base64OpenVPNConfiguration);
        final configuration = utf8.decode(dataConfigVpn);

        // Create VPN configuration
        final vpnConfiguration = VpnConfiguration(
          username: 'vpn',
          password: 'vpn',
          countryName: vpnInfo.value.countryLongName,
          config: configuration,
        );

        // Start VPN connection
        await VpnEngine.startVpnNow(vpnConfiguration);
      } else {
        // If already connected, stop VPN
        await VpnEngine.stopVpnNow();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to VPN: $e');
    }
  }

  Color get getRoundVpnButtonColor {
    switch (vpnConnectionStage.value) {
      case VpnEngine.vpnConnectingNow:
        return Colors.yellowAccent[
            700]!; // Yellow for the connecting state (matches the image).
      case VpnEngine.vpnConnectedNow:
        return Colors.greenAccent; // Bright green for when connected.
      case VpnEngine.vpnDisconnectedNow:
        return Colors.redAccent; // Red for disconnected state.
      default:
        return Colors.grey; // Neutral grey for other states.
    }
  }

  String get getRoundVpnButtonText {
    switch (vpnConnectionStage.value) {
      case VpnEngine.vpnConnectingNow:
        return 'Connecting';
      case VpnEngine.vpnConnectedNow:
        return 'Connected'; // Fixed typo here
      case VpnEngine.vpnDisconnectedNow:
        return 'Tap to Connect';
      default:
        return 'Connecting...';
    }
  }
}
