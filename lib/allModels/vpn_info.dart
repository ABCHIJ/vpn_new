class VpnInfo {
  late final String hostname;
  late final String ip;
  late final String ping;
  late final int speed; // Assuming speed is an integer
  late final String countryLongName;
  late final String countryShortName; // Fixed typo here
  late final int vpnSessionsNum;
  late final String base64OpenVPNConfiguration;

  VpnInfo({
    required this.hostname,
    required this.ip,
    required this.ping,
    required this.speed,
    required this.countryLongName,
    required this.countryShortName, // Fixed typo here
    required this.vpnSessionsNum,
    required this.base64OpenVPNConfiguration,
  });

  // Factory constructor to create VpnInfo from a JSON map
  VpnInfo.fromJson(Map<String, dynamic> jsonData) {
    hostname = jsonData['HostName'] ?? '';
    ip = jsonData['IP'] ?? '';
    ping = jsonData['Ping'].toString();
    speed = jsonData['Speed'] ??
        0; // Assuming speed is an integer, so no string conversion
    countryLongName = jsonData['CountryLong'] ?? '';
    countryShortName = jsonData['CountryShort'] ?? ''; // Fixed typo here
    vpnSessionsNum = jsonData['NumVpnSessions'] ?? 0;
    base64OpenVPNConfiguration = jsonData['OpenVPN_ConfigData_Base64'] ?? '';
  }

  // Convert VpnInfo instance to a JSON map
  Map<String, dynamic> toJson() {
    final jsonData = <String, dynamic>{};

    jsonData['HostName'] = hostname;
    jsonData['IP'] = ip;
    jsonData['Ping'] = ping;
    jsonData['Speed'] = speed; // Assuming speed is an integer
    jsonData['CountryLong'] = countryLongName;
    jsonData['CountryShort'] = countryShortName; // Fixed typo here
    jsonData['NumVpnSessions'] = vpnSessionsNum;
    jsonData['OpenVPN_ConfigData_Base64'] = base64OpenVPNConfiguration;
    return jsonData;
  }
}
