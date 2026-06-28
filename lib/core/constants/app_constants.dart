class AppConstants {
  static const int statusCodeSuccess = 200;

  // Platform Channel Names
  static const String pairingMethodChannel = 'com.jithin.ble/pairing';
  static const String pairingEventChannel = 'com.jithin.ble/pairing/events';

  // Method Channel Methods
  static const String methodGetPairState = 'getPairState';
  static const String methodPair = 'pair';
  static const String methodUnPair = 'unPair';

  // Method Channel Arguments
  static const String argMacAddress = 'macAddress';

  // Android Bond States
  static const int bondNone = 10;
  static const int bondBonding = 11;
  static const int bondBonded = 12;

  // Connection Status
  static const String connected = 'CONNECTED';
  static const String disconnected = 'DISCONNECTED';
}

class AppStrings {
  static const String success = 'Success';
  static const String connected = 'Connected';
  static const String disconnected = 'Disconnected';
  static const String scanStarted = 'Scan started';
  static const String scanStopped = 'Scan stopped';
  static const String servicesDiscovered = 'Services discovered successfully';
  static const String characteristicRead = 'Characteristic read successfully';
  static const String characteristicWrite = 'Characteristic write successful';
  static const String writeSuccessful = 'Write Successful';
  static const String writeFailed = 'Write Failed';

  // Error Messages
  static const String iosPairingMessage = 'iOS manages pairing via the system settings.';
  static const String iosPairingProgrammaticMessage =
      'Bluetooth pairing is managed by iOS and cannot be initiated programmatically.';
  static const String failedToGetPairState = 'Failed to get pair state';
  static const String failedToInitiatePairing = 'Failed to initiate pairing';
  static const String failedToRemovePairing = 'Failed to remove pairing';
  static const String deviceAlreadyConnected =
      'A device is already connected. Please disconnect it before connecting to a new one.';
  static const String anotherDeviceConnected =
      'Another device is currently connected. Disconnect it to connect here.';

  // UI Strings
  static const String unknown = 'Unknown';
  static const String scanDevices = 'Scan Devices';
  static const String noDevicesFound = 'No devices found';
  static const String pressSearchToStart = 'Press search to start scanning';
  static const String uuid = 'UUID';
  static const String properties = 'Properties';
  static const String read = 'Read';
  static const String write = 'Write';
  static const String notify = 'Notify';
  static const String indicate = 'Indicate';
}
