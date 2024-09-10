import 'package:flutter/material.dart';
import '../allModels/network_ip_info.dart';

class NetworkIpInfoWidget extends StatelessWidget {
  final NetworkIpInfo networkIpInfo;

  NetworkIpInfoWidget({super.key, required this.networkIpInfo});

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: sizeScreen.height * 0.01),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: networkIpInfo.iconData,
        title: Text(
          networkIpInfo.titleText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          networkIpInfo.subtitleText,
        ),
      ),
    );
  }
}
