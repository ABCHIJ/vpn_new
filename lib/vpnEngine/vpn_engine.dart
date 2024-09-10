import 'package:flutter/services.dart';
import 'package:vpnapp/allModels/vpn_configuration.dart';
import 'package:vpnapp/allModels/vpn_status.dart';

class VpnEngine {
  static const _eventChannelVpnStage = 'vpnStage';
  static const _eventChannelVpnStatus = 'vpnStatus';
  static const _methodChannelVpnControl = 'vpnControl';

  static Stream<String> vpnStageSnapshot() =>
      EventChannel(_eventChannelVpnStage)
          .receiveBroadcastStream()
          .cast<String>();

  static Stream<VpnStatus?> snapshotVpnStatus() =>
      EventChannel(_eventChannelVpnStatus)
          .receiveBroadcastStream()
          .map((eventStatus) {
        return eventStatus != null ? VpnStatus.fromJson(eventStatus) : null;
      }).cast<VpnStatus?>();

  static Future<void> startVpnNow(VpnConfiguration vpnConfiguration) async {
    try {
      await MethodChannel(_methodChannelVpnControl).invokeMethod('start', {
        'config': vpnConfiguration.config,
        'countryName': vpnConfiguration.countryName,
        'username': vpnConfiguration.username,
        'password': vpnConfiguration.password,
      });
    } catch (e) {
      print('Error starting VPN: $e');
      rethrow; // You can handle this better at a higher level if needed
    }
  }

  static Future<void> stopVpnNow() async {
    try {
      await MethodChannel(_methodChannelVpnControl).invokeMethod('stop');
    } catch (e) {
      print('Error stopping VPN: $e');
      rethrow;
    }
  }

  static Future<void> killSwitchOpenNow() async {
    try {
      await MethodChannel(_methodChannelVpnControl).invokeMethod('kill_switch');
    } catch (e) {
      print('Error opening kill switch: $e');
      rethrow;
    }
  }

  static Future<void> refreshStageNow() async {
    try {
      await MethodChannel(_methodChannelVpnControl).invokeMethod('refresh');
    } catch (e) {
      print('Error refreshing VPN stage: $e');
      rethrow;
    }
  }

  static Future<String?> getStageNow() async {
    try {
      return await MethodChannel(_methodChannelVpnControl)
          .invokeMethod<String>('stage');
    } catch (e) {
      print('Error getting VPN stage: $e');
      return null;
    }
  }

  static Future<bool> isConnectedNow() async {
    try {
      final stage = await getStageNow();
      if (stage != null) {
        return stage.toLowerCase() == vpnConnectedNow.toLowerCase();
      }
      return false;
    } catch (e) {
      print('Error checking VPN connection: $e');
      return false;
    }
  }

  // VPN Status constants
  static const vpnConnectedNow = 'connected';
  static const vpnDisconnectedNow = 'disconnected';
  static const vpnWaitConnectionNow = 'wait_connection';
  static const vpnAuthenticatingNow = 'authenticating';
  static const vpnReconnectNow = 'reconnect';
  static const vpnNoConnectionNow = 'no_connection';
  static const vpnConnectingNow = 'connecting';
  static const vpnPrepareNow = 'prepare';
  static const vpnDeniedNow = 'denied';
}
