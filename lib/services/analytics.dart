import 'package:firebase_analytics/firebase_analytics.dart';


/*Future<void> logScreenNew(String name) async {
FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  await FirebaseAnalytics.instance
  .logScreenView(
    screenName: name,
  );

}*/

Future<void> logEvent(String name, Map<String, Object>? parameters) async {
FirebaseAnalytics analytics = FirebaseAnalytics.instance;
//parameters=parameters+('debug_mode':debug');

  await FirebaseAnalytics.instance
  .logEvent(
    name:name,
    parameters: parameters,
  );

}

Future<void> logTrafficType(String type) async {
  
FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  await FirebaseAnalytics.instance
  .setUserProperty(
    name: 'traffic_type', ///set this as a custom dimension?
    value: type,
  );

}

Future<void> logNetworkStatus(String type) async {
  
FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  await FirebaseAnalytics.instance
  .setUserProperty(
    name: 'network_status', ///set this as a custom dimension?
    value: type,
  );

}


