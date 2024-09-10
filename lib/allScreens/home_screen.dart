import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpnapp/allModels/vpn_status.dart';
import 'package:vpnapp/allScreens/connected_network_ip_info_screen.dart';
import 'package:vpnapp/allWidgets/custom_widget.dart';
import 'package:vpnapp/allWidgets/timer_widget.dart';
import 'package:vpnapp/appPreferences/appPreferences.dart';
import 'package:vpnapp/vpnEngine/vpn_engine.dart';

import '../allControllers/controller_home.dart';
import 'available_vpn_servers_location_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final homeController = Get.put(ControllerHome());

  Widget vpnRoundButton(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    return Column(
      children: [
        //vpn button
        Semantics(
          button: true,
          child: InkWell(
            onTap: () {
              homeController.connectToVpnNow();
            },
            borderRadius: BorderRadius.circular(100),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: homeController.getRoundVpnButtonColor.withOpacity(0.1),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: homeController.getRoundVpnButtonColor.withOpacity(0.3),
                ),
                child: Container(
                  height: sizeScreen.height * 0.14,
                  width: sizeScreen.height * 0.14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: homeController.getRoundVpnButtonColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.power,
                        size: 36,
                        color: Colors.black,
                      ),
                      SizedBox(height: 6),
                      Text(
                        "VPN Button",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Status of connection
        Container(
          margin: EdgeInsets.only(
              top: sizeScreen.height * 0.015, bottom: sizeScreen.height * 0.02),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            homeController.vpnConnectionStage.value ==
                    VpnEngine.vpnDisconnectedNow
                ? 'Not Connected'
                : homeController.vpnConnectionStage.value
                    .replaceAll('_', ' ')
                    .toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),

        // Timer widget
        Obx(() => TimerWidget(
              initTimerNow: homeController.vpnConnectionStage.value ==
                  VpnEngine.vpnConnectedNow,
            )),
      ],
    );
  }

  Widget locationSelectionBottomNavigation(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    return SafeArea(
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: () {
            Get.to(() => AvailableVpnServersLocationScreen());
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: sizeScreen.width * 0.041),
            height: 62,
            color: Colors.black, // Added a background color for visibility
            child: Row(
              children: const [
                Icon(
                  CupertinoIcons.globe,
                  color: Colors.white,
                  size: 36,
                ),
                SizedBox(width: 12),
                Text(
                  'Select Location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                CircleAvatar(
                  backgroundColor: Colors.yellowAccent,
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listening to VPN connection state, replaced snapshotVpnStage with vpnStageSnapshot
    VpnEngine.vpnStageSnapshot().listen((event) {
      homeController.vpnConnectionStage.value = event;
    });

    final sizeScreen = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "AI-POWERED VPN",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Get.to(() => const ConnectedNetworkIPInfoScreen());
          },
          icon: const Icon(Icons.info, color: Colors.yellowAccent),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Toggle theme mode and save the preference
              Get.changeThemeMode(
                AppPreferences.isModeDark ? ThemeMode.light : ThemeMode.dark,
              );
              AppPreferences.isModeDark = !AppPreferences.isModeDark;
            },
            icon: const Icon(Icons.brightness_2_outlined,
                color: Colors.yellowAccent),
          ),
        ],
      ),
      bottomNavigationBar: locationSelectionBottomNavigation(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Round widgets for location and ping
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomWidget(
                    titleText:
                        homeController.vpnInfo.value.countryLongName.isEmpty
                            ? 'Location'
                            : homeController.vpnInfo.value.countryLongName,
                    subtitleText: 'Free',
                    roundWidgetWithIcon: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.yellowAccent[700],
                      child:
                          homeController.vpnInfo.value.countryLongName.isEmpty
                              ? const Icon(
                                  CupertinoIcons.location_solid,
                                  size: 30,
                                  color: Colors.black,
                                )
                              : null,
                      backgroundImage: homeController
                              .vpnInfo.value.countryLongName.isEmpty
                          ? null
                          : AssetImage(
                              'project/countryFlags/countryFlags/${homeController.vpnInfo.value.countryShortName.toLowerCase()}.png'),
                    ),
                  ),
                  CustomWidget(
                    titleText:
                        homeController.vpnInfo.value.countryLongName.isEmpty
                            ? '60 ms'
                            : '${homeController.vpnInfo.value.ping} ms',
                    subtitleText: 'PING',
                    roundWidgetWithIcon: const CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.black54,
                      child: Icon(
                        Icons.speed,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )),

          // VPN button
          Obx(() => vpnRoundButton(context)),

          // Round widgets for download and upload
          StreamBuilder<VpnStatus?>(
            initialData: VpnStatus(),
            stream: VpnEngine.snapshotVpnStatus(),
            builder: (context, datasnapshot) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomWidget(
                    titleText: '${datasnapshot.data?.byteIn ?? '0'} kbps',
                    subtitleText: 'DOWNLOAD',
                    roundWidgetWithIcon: const CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(
                        Icons.arrow_downward,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  CustomWidget(
                    titleText: '${datasnapshot.data?.byteOut ?? '0'} kbps',
                    subtitleText: 'UPLOAD',
                    roundWidgetWithIcon: const CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.orangeAccent,
                      child: Icon(
                        Icons.arrow_upward,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
