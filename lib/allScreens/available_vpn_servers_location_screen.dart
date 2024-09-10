import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../allControllers/controller_vpn_location.dart';
import '../allWidgets/vpn_location_card_widget.dart';

class AvailableVpnServersLocationScreen extends StatelessWidget {
  AvailableVpnServersLocationScreen({super.key});

  final vpnLocationController = ControllerVpnLocation();

  // Loading UI
  Widget loadingUIWidget() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
          ),
          const SizedBox(height: 8),
          Text(
            'Gathering VPN servers...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // No VPN server found UI
  Widget noVpnServerFoundUIWidget() {
    return Center(
      child: Text(
        'No VPN Servers Found. Try Again',
        style: TextStyle(
          fontSize: 18,
          color: Colors.black54,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Available VPN servers list
  Widget vpnAvailableServersData() {
    return ListView.builder(
      itemCount: vpnLocationController.vpnFreeServerAvailableList.length,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(3),
      itemBuilder: (context, index) {
        return VpnLocationCardWidget(
          vpnInfo: vpnLocationController.vpnFreeServerAvailableList[index],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve VPN information if the list is empty
    if (vpnLocationController.vpnFreeServerAvailableList.isEmpty) {
      vpnLocationController.retrieveVpnInformation();
    }

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text(
            'VPN locations (${vpnLocationController.vpnFreeServerAvailableList.length})',
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 10, bottom: 10),
          child: FloatingActionButton(
            backgroundColor: Colors.redAccent,
            onPressed: () {
              vpnLocationController.retrieveVpnInformation();
            },
            child: Icon(CupertinoIcons.refresh_circled),
          ),
        ),
        body: vpnLocationController.isLoadingNewLocations.value
            ? loadingUIWidget()
            : vpnLocationController.vpnFreeServerAvailableList.isEmpty
                ? noVpnServerFoundUIWidget()
                : vpnAvailableServersData(),
      ),
    );
  }
}
