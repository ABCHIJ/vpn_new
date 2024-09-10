import 'package:get/get.dart';
import 'package:vpnapp/allModels/vpn_info.dart';
import 'package:vpnapp/apiVpnGate/api_vpi_gate.dart';
import 'package:vpnapp/appPreferences/appPreferences.dart';

class ControllerVpnLocation extends GetxController {
  List<VpnInfo> vpnFreeServerAvailableList = AppPreferences.vpnList;
  final RxBool isLoadingNewLocations = false.obs;
  Future<void> retrieveVpnInformation() async {
    isLoadingNewLocations.value = true;
    vpnFreeServerAvailableList.clear();
    vpnFreeServerAvailableList =
        await ApiVpnGate.retrieveAllAvailableVpnServers();
    isLoadingNewLocations.value = false;
  }
}
