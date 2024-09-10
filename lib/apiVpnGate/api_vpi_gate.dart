import 'dart:convert'; // Import for JSON decoding
import 'package:get/get.dart';
import 'package:vpnapp/allModels/vpn_info.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:vpnapp/appPreferences/appPreferences.dart';
import 'package:vpnapp/allModels/ip_info.dart';
import 'package:flutter/material.dart'; // Import for Colors

class ApiVpnGate {
  static const String vpnGateApiUrl = 'http://www.vpngate.net/api/iphone/';
  static const String ipApiUrl = 'http://ip-api.com/json/';

  // Fetch and parse available VPN servers
  static Future<List<VpnInfo>> retrieveAllAvailableVpnServers() async {
    final List<VpnInfo> vpnServersList = [];

    try {
      // Fetch the VPN server data from the API with a 10-second timeout
      final responseFromApi = await http
          .get(Uri.parse(vpnGateApiUrl))
          .timeout(Duration(seconds: 10));

      if (responseFromApi.statusCode == 200) {
        // Clean up the response body and parse the CSV
        final commaSeparatedValueString =
            responseFromApi.body.split('#')[1].replaceAll('*', '');

        List<List<dynamic>> listData =
            const CsvToListConverter().convert(commaSeparatedValueString);

        if (listData.isNotEmpty) {
          final header = listData[0];
          for (int counter = 1; counter < listData.length - 1; counter++) {
            Map<String, dynamic> jsonData = {};

            for (int innerCounter = 0;
                innerCounter < header.length;
                innerCounter++) {
              jsonData[header[innerCounter].toString()] =
                  listData[counter][innerCounter];
            }

            vpnServersList.add(VpnInfo.fromJson(jsonData));
          }

          // Shuffle and save the VPN server list to app preferences
          vpnServersList.shuffle();
          if (vpnServersList.isNotEmpty) {
            AppPreferences.vpnList = vpnServersList;
          }
        }
      } else {
        throw Exception(
            'Failed to retrieve VPN servers. Status code: ${responseFromApi.statusCode}');
      }
    } catch (errorMsg) {
      // Handle error and show notification
      Get.snackbar(
        'Error Occurred',
        errorMsg.toString(),
        colorText: Colors.white,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
      );
    }

    return vpnServersList;
  }

  // Fetch and update IP details
  static Future<void> retrieveIPDetails(
      {required Rx<IPInfo> ipInformation}) async {
    try {
      // Fetch IP details from the API with a 10-second timeout
      final responseFromApi =
          await http.get(Uri.parse(ipApiUrl)).timeout(Duration(seconds: 10));

      if (responseFromApi.statusCode == 200) {
        final dataFromApi = jsonDecode(responseFromApi.body);
        ipInformation.value = IPInfo.fromJson(dataFromApi);
      } else {
        throw Exception(
            'Failed to retrieve IP details. Status code: ${responseFromApi.statusCode}');
      }
    } catch (errorMsg) {
      // Handle error and show notification
      Get.snackbar(
        'Error Occurred',
        errorMsg.toString(),
        colorText: Colors.white,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
      );
    }
  }
}
