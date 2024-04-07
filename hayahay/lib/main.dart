// Flutter related imports
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hayahay/commands/commands_page.dart';
// UI related imports
import 'package:home_automation/components/drawer_items/settings_screen.dart';
import 'package:home_automation/home/home_screen.dart';
import 'package:home_automation/services/change_notifiers/broker_notifier.dart';
import 'package:home_automation/services/change_notifiers/server_chooser.dart';
import 'package:home_automation/services/change_notifiers/temp.dart';
// Providers related imports
import 'package:provider/provider.dart';
import 'package:home_automation/services/change_notifiers/chosen_device_type.dart';
import 'package:home_automation/services/change_notifiers/page_selector.dart';
// Firebase related imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.blue));
  if (!kIsWeb) {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    FirebaseDatabase.instance.setPersistenceCacheSizeBytes(20000000);
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PageService()),
        ChangeNotifierProvider(create: (_) => ChosenDeviceType()),
        ChangeNotifierProvider(create: (_) => ServerChooser()),
        ChangeNotifierProvider(create: (_) => BrokerStatus()),
        ChangeNotifierProvider(create: (_) => Manual()),
        // ChangeNotifierProvider(create: (_) => StatusFetcher()),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //initialRoute: '/',
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Home Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black),
      ),
      home: HomeScreen(),
      routes: {
        //'/': (context) => HomeScreen(),
        '/settings-screen': (BuildContext context) => SettingsScreen(),
        //'/drawer': (BuildContext context) => NavDrawer(),
      },
    );
  }
}

// Enable mouse scrolling
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
