import 'package:flutter/widgets.dart';
import 'package:home_automation/models/broker.dart';
import 'package:home_automation/services/realtime_database.dart';

class BrokerStatus with ChangeNotifier {
  Future<Map> jsonFetcher() async {
    RealtimeDatabase rtdb = RealtimeDatabase();
    rtdb.setPath("data/broker");
    Map<dynamic, dynamic> json = {};
    json =
        await rtdb.asReference!.limitToLast(5).get() as Map<dynamic, dynamic>;
    return json;
  }
  Future<Broker> get broker async {
    return Broker.fromJson(await jsonFetcher());
  }
}