class Broker {
  String ip;
  int port;
  bool isSynced;
  Broker.fromJson(Map<dynamic, dynamic> json)
      : ip = json['ip'],
        port = json['port'],
        isSynced = json['isSynced'];
  // Broker() {
  //   final json = jsonFetcher();
  //   ip = json['ip'];
  //   port = json['port'];
  //   isSynced = json['isSynced'];
  // }
}