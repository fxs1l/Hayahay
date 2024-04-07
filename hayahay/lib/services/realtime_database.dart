import 'package:firebase_database/firebase_database.dart';
class RealtimeDatabase {
  String? path;
  int limitToLast;
  DatabaseReference? asReference;
  FirebaseDatabase db = FirebaseDatabase.instance;
  RealtimeDatabase({this.path, this.limitToLast = 10});
  void setPath(String path) {
    this.path = path;
    this.asReference = this.db.ref(path);
    // this.asQuery = this.asReference!.limitToLast(limitToLast);
  }
  void update(Map<String, dynamic> payload) async {
    await this.asReference!.update(payload);
  }
  dynamic fetch(String path) async {}
  Stream<dynamic> streamStatus(String statusPath) async* {
    setPath(statusPath);
    final Stream<DatabaseEvent> events = this.asReference!.onValue;
    await for (DatabaseEvent event in events) {
      yield event.snapshot.value as dynamic;
    }
  }
}
