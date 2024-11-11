import 'package:apheria/constants.dart';
import 'package:apheria/homePages/filesHomePage.dart';
import 'package:apheria/main.dart';
import 'package:apheria/newTransferScreen.dart';
import 'package:apheria/services/analytics.dart';
import 'package:apheria/widgets/starpoints.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//import 'firebase_notifier.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:url_launcher/url_launcher.dart';

enum FirebaseState {
  loading,
  available,
  notAvailable,
}

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'API KEY',
    appId: 'APP ID',
    messagingSenderId: 'SENDER ID',
    projectId: 'PROJECT ID',
    storageBucket: 'STORAGE BUCKET',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'API KEY',
    appId: 'APP ID',
    messagingSenderId: 'SENDER ID',
    projectId: 'PROJECT ID',
    storageBucket: 'STORAGE BUCKET',
    iosClientId: 'CLIENT ID',
    iosBundleId: 'BUNDLE ID',
  );
}

const cloudRegion = 'europe-west1';
//const cluster = '500_sp';
const thousandSP = '1000_sp';
//const supernova = '2500_sp';

const storeKeyUpgrade = 'dash_upgrade_3d';
const storeKeySubscription = 'dash_subscription_doubler';

// TODO: Replace by your own server IP
const serverIp = '192.168.178.46';

enum PurchaseType {
  subscriptionPurchase,
  nonSubscriptionPurchase,
}

enum Store {
  googlePlay,
  appStore,
}

enum Status {
  pending,
  completed,
  active,
  expired,
}

@immutable
class PastPurchase {
  final PurchaseType type;
  final Store store;
  final String orderId;
  final String productId;
  final DateTime purchaseDate;
  final DateTime? expiryDate;
  final Status status;

  String get title {
    return switch (productId) {
      //cluster => 'Consumable',
      //supergiant => 'Consumable',
      thousandSP => 'Consumable',

      //storeKeySubscription => 'Subscription',
      _ => productId
    };
  }

  PastPurchase.fromJson(Map<String, dynamic> json)
      : type = _typeFromString(json['type'] as String),
        store = _storeFromString(json['iapSource'] as String),
        orderId = json['orderId'] as String,
        productId = json['productId'] as String,
        purchaseDate = DateTime.now(),
        expiryDate = null,
        status = _statusFromString(json['status'] as String);
}

PurchaseType _typeFromString(String type) {
  return switch (type) {
    'nonSubscription' => PurchaseType.subscriptionPurchase,
    'subscription' => PurchaseType.nonSubscriptionPurchase,
    _ => throw ArgumentError.value(type, '$type is not a supported type')
  };
}

Store _storeFromString(String store) {
  return switch (store) {
    'googleplay' => Store.googlePlay,
    'appstore' => Store.appStore,
    _ => throw ArgumentError.value(store, '$store is not a supported store')
  };
}

Status _statusFromString(String status) {
  return switch (status) {
    'pending' => Status.pending,
    'completed' => Status.completed,
    'active' => Status.active,
    'expired' => Status.expired,
    _ => throw ArgumentError.value(status, '$status is not a supported status')
  };
}

class IAPRepo extends ChangeNotifier {
  late FirebaseFirestore _firestore;
  late FirebaseAuth _auth;

  bool get isLoggedIn => _user != null;
  User? _user;
  bool hasActiveSubscription = false;
  bool hasUpgrade = false;
  List<PastPurchase> purchases = [];

  StreamSubscription<User?>? _userSubscription;
  StreamSubscription<QuerySnapshot>? _purchaseSubscription;

  IAPRepo(FirebaseNotifier firebaseNotifier) {
    firebaseNotifier.firestore.then((value) {
      _auth = FirebaseAuth.instance;
      _firestore = value;
      updatePurchases();
      listenToLogin();
    });
  }

  void listenToLogin() {
    _user = _auth.currentUser;
    _userSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      updatePurchases();
    });
  }

  void updatePurchases() {
    _purchaseSubscription?.cancel();
    var user = _user;
    if (user == null) {
      purchases = [];
      hasActiveSubscription = false;
      hasUpgrade = false;
      return;
    }
    var purchaseStream = _firestore
        .collection('purchases')
        .where('userId', isEqualTo: user.uid)
        .snapshots();
    _purchaseSubscription = purchaseStream.listen((snapshot) {
      purchases = snapshot.docs.map((document) {
        var data = document.data();
        return PastPurchase.fromJson(data);
      }).toList();

      hasActiveSubscription = purchases.any((element) =>
          element.productId == storeKeySubscription &&
          element.status != Status.expired);

      hasUpgrade = purchases.any(
        (element) => element.productId == storeKeyUpgrade,
      );

      notifyListeners();
    });
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    _purchaseSubscription?.cancel();
    super.dispose();
  }
}

class FirebaseNotifier extends ChangeNotifier {
  bool loggedIn = false;
  FirebaseState state = FirebaseState.loading;
  bool isLoggingIn = false;

  FirebaseNotifier() {
    load();
  }

  late final Completer<bool> _isInitialized = Completer();

  Future<FirebaseFirestore> get firestore async {
    var isInitialized = await _isInitialized.future;
    if (!isInitialized) {
      throw Exception('Firebase is not initialized');
    }
    return FirebaseFirestore.instance;
  }

  User? get user => FirebaseAuth.instance.currentUser;

  Future<void> load() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      loggedIn = FirebaseAuth.instance.currentUser != null;
      state = FirebaseState.available;
      _isInitialized.complete(true);
      notifyListeners();
    } catch (e) {
      state = FirebaseState.notAvailable;
      _isInitialized.complete(false);
      notifyListeners();
    }
  }

  Future<void> login() async {
    isLoggingIn = true;
    notifyListeners();
    // Trigger the authentication flow
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        isLoggingIn = false;
        notifyListeners();
        return;
      }

      // Obtain the auth details from the request
      final googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);

      loggedIn = true;
      isLoggingIn = false;
      notifyListeners();
    } catch (e) {
      isLoggingIn = false;
      notifyListeners();
      return;
    }
  }
}

/////

enum StoreState {
  loading,
  available,
  notAvailable,
}

/////////////

enum ProductStatus {
  purchasable,
  purchased,
  pending,
}

//////////

class PurchasableProduct {
  String get id => productDetails.id;
  String get title => productDetails.title;
  String get description => productDetails.description;
  String get price => productDetails.price;
  ProductStatus status;
  ProductDetails productDetails;

  PurchasableProduct(this.productDetails) : status = ProductStatus.purchasable;
}

////////////////

const updatesPerSecond = 10;

//////////

class DashUpgrades extends ChangeNotifier {
  DashCounter counter;
  FirebaseNotifier firebaseNotifier;

  DashUpgrades(this.counter, this.firebaseNotifier) {
    counter.addListener(_onCounterChange);
    _updateUpgradeOptions();
  }

  Upgrade tim = Upgrade(cost: 5, work: 1, count: 0);

  void _onCounterChange() {
    if (_updateUpgradeOptions()) notifyListeners();
  }

  bool _updateUpgradeOptions() {
    var hasChanges = false;

    hasChanges = _updateUpgrade(tim) | hasChanges;

    return hasChanges;
  }

  bool _updateUpgrade(Upgrade upgrade) {
    var canBuy = counter.count >= upgrade.cost;
    if (canBuy == upgrade.purchasable) return false;
    upgrade._purchasable = canBuy;
    return true;
  }

  void addTim() {
    _buy(tim);
  }

  void _buy(
    Upgrade upgrade,
  ) {
    if (counter.count < upgrade.cost) return;

    counter.addAutoIncrement(
      incrementPerSecond: upgrade.work,
      costs: upgrade.cost,
    );
    upgrade._increment();
    _updateUpgradeOptions();
    notifyListeners();
  }

  @override
  void dispose() {
    counter.removeListener(_onCounterChange);
    super.dispose();
  }
}

class Upgrade {
  int get cost => _cost;
  late int _cost;

  double get work => _work;
  late double _work;

  int get count => _count;
  late int _count;

  bool get purchasable => _purchasable;
  bool _purchasable = false;

  Upgrade({required int cost, required double work, required int count}) {
    _cost = cost;
    _work = work;
    _count = count;
  }

  void _increment() {
    _count++;
    _cost = (_cost * 1.3).ceil();
  }
}

/////////////

class DashPurchases extends ChangeNotifier {
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final iapConnection = IAPConnection.instance;
  DashCounter counter;
  StoreState storeState = StoreState.loading;
  List<PurchasableProduct> products = [];

  Future<void> loadPurchases() async {
    final available = await iapConnection.isAvailable();
    if (!available) {
      storeState = StoreState.notAvailable;
      notifyListeners();
      return;
    }
    const ids = <String>{
      thousandSP
    //  cluster, supergiant, supernova
      //storeKeySubscription,
      // storeKeyUpgrade,
    };
    final response = await iapConnection.queryProductDetails(ids);
    for (var element in response.notFoundIDs) {
      debugPrint('Purchase $element not found');
    }
    products =
        response.productDetails.map((e) => PurchasableProduct(e)).toList();
    storeState = StoreState.available;
    notifyListeners();
  }

  bool get beautifiedDash => _beautifiedDashUpgrade;
  bool _beautifiedDashUpgrade = false;

  FirebaseNotifier firebaseNotifier;
  IAPRepo iapRepo;

  DashPurchases(this.counter, this.firebaseNotifier, this.iapRepo) {
    final purchaseUpdated = iapConnection.purchaseStream;

    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: _updateStreamOnDone,
      onError: _updateStreamOnError,
    );
    iapRepo.addListener(purchasesUpdate);

    loadPurchases();
  }

  @override
  void dispose() {
    iapRepo.removeListener(purchasesUpdate);
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _onPurchaseUpdate(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      await _handlePurchase(purchaseDetails);
    }
    notifyListeners();
  }

  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
//for some reason purchase isn't getting past this point
    if (purchaseDetails.status == PurchaseStatus.purchased) {
      // Send to server
      //var validPurchase = await _verifyPurchase(purchaseDetails);

      //  if (validPurchase) {
      // Apply changes locally
      if (myproductid == '1000_sp') {
        starpoints = starpoints + 1000;
        updateStarPoints();
        logEvent('sp_action',
            {'action': 'bought_sp', 'name': '1000 ★', 'points': 1000});
      }
      //}
    }

    if (purchaseDetails.pendingCompletePurchase) {
      await iapConnection.completePurchase(purchaseDetails);
    }
  }

  void _updateStreamOnDone() {
    _subscription.cancel();
  }

  void _updateStreamOnError(dynamic error) {
    //Handle error here
  }

  void purchasesUpdate() {
    var subscriptions = <PurchasableProduct>[];
    var upgrades = <PurchasableProduct>[];
    // Get a list of purchasable products for the subscription and upgrade.
    // This should be 1 per type.
    if (products.isNotEmpty) {
      subscriptions = products
          .where((element) => element.productDetails.id == storeKeySubscription)
          .toList();
      upgrades = products
          .where((element) => element.productDetails.id == storeKeyUpgrade)
          .toList();
    }

    // Set the subscription in the counter logic and show/hide purchased on the
    // purchases page.
    if (iapRepo.hasActiveSubscription) {
      counter.applyPaidMultiplier();
      for (var element in subscriptions) {
        _updateStatus(element, ProductStatus.purchased);
      }
    } else {
      counter.removePaidMultiplier();
      for (var element in subscriptions) {
        _updateStatus(element, ProductStatus.purchasable);
      }
    }

    // Set the Dash beautifier and show/hide purchased on
    // the purchases page.
    if (iapRepo.hasUpgrade != _beautifiedDashUpgrade) {
      _beautifiedDashUpgrade = iapRepo.hasUpgrade;
      for (var element in upgrades) {
        _updateStatus(
            element,
            _beautifiedDashUpgrade
                ? ProductStatus.purchased
                : ProductStatus.purchasable);
      }
      notifyListeners();
    }
  }

  void _updateStatus(PurchasableProduct product, ProductStatus status) {
    if (product.status != ProductStatus.purchased) {
      product.status = ProductStatus.purchased;
      notifyListeners();
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    final url = Uri.parse('http://$serverIp:8080/verifypurchase');
    const headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      url,
      body: jsonEncode({
        'source': purchaseDetails.verificationData.source,
        'productId': purchaseDetails.productID,
        'verificationData':
            purchaseDetails.verificationData.serverVerificationData,
        'userId': firebaseNotifier.user?.uid,
      }),
      headers: headers,
    );
    if (response.statusCode == 200) {
      print('Successfully verified purchase');
      return true;
    } else {
      print('failed request: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

  Future<void> buy(PurchasableProduct product) async {
    final purchaseParam = PurchaseParam(productDetails: product.productDetails);
    switch (product.id) {
     /* case cluster:
        await iapConnection.buyConsumable(purchaseParam: purchaseParam);
        break;
      case supergiant:
        await iapConnection.buyConsumable(purchaseParam: purchaseParam);
        break;*/
      case thousandSP:
        await iapConnection.buyConsumable(purchaseParam: purchaseParam);
        break;
      case storeKeySubscription:
      case storeKeyUpgrade:
        await iapConnection.buyNonConsumable(purchaseParam: purchaseParam);
        break;
      default:
        throw ArgumentError.value(
            product.productDetails, '${product.id} is not a known product');
    }
  }
}

/////////////

class DashCounter extends ChangeNotifier {
  final numberFormatter = NumberFormat.compactLong();

  int get count => _count.floor();

  String get countString => _countString;
  String _countString = '0';
  double _count = 0;
  late Timer timer;

  double _autoIncrementCount = 0;
  int _multiplier = 1;

  DashCounter() {
    timer = Timer.periodic(
      const Duration(milliseconds: 1000 ~/ updatesPerSecond),
      (timer) => _updateWithAutoIncrement(),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void increment() {
    _increment(1);
  }

  void addAutoIncrement({
    required double incrementPerSecond,
    required int costs,
  }) {
    _count -= costs;
    _autoIncrementCount += incrementPerSecond;
    notifyListeners();
  }

  void _updateWithAutoIncrement() {
    _increment(_autoIncrementCount * _multiplier / updatesPerSecond);
  }

  void _increment(double increment) {
    var oldCount = _countString;
    _count += increment;
    _countString = numberFormatter.format(count);
    if (_countString != oldCount) {
      notifyListeners();
    }
  }

  void applyPaidMultiplier() {
    _multiplier = 10;
  }

  void removePaidMultiplier() {
    _multiplier = 1;
  }

  void addBoughtDashes(int amount) {
    _increment(amount.toDouble());
  }
}

///////////



class InAppPurchasePage extends StatefulWidget {
  @override
  State<InAppPurchasePage> createState() => _InAppPurchasePageState();
}

typedef PageBuilder = Widget Function();

class _InAppPurchasePageState extends State<InAppPurchasePage> {
  int _selectedIndex = 0;

 

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseNotifier>(
            create: (_) => FirebaseNotifier()),
        ChangeNotifierProvider<DashCounter>(create: (_) => DashCounter()),
        ChangeNotifierProvider<DashUpgrades>(
          create: (context) => DashUpgrades(
            context.read<DashCounter>(),
            context.read<FirebaseNotifier>(),
          ),
        ),
        ChangeNotifierProvider<IAPRepo>(
          create: (context) => IAPRepo(context.read<FirebaseNotifier>()),
        ),
        ChangeNotifierProvider<DashPurchases>(
            create: (context) => DashPurchases(
                  context.read<DashCounter>(),
                  context.read<FirebaseNotifier>(),
                  context.read<IAPRepo>(),
                ),
            lazy: false //new
            ),
      ],
      child: Scaffold(
          backgroundColor: apheriapink,
          appBar: apheriaAppBar(context, 'star points'),
          body: PurchasePage()
          // _widgetOptions[_selectedIndex],
          /*bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shop),
              label: 'Purchase',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: (index) => setState(() => _selectedIndex = index),
        ),*/
          ),
    );
  }
}

////

/////
///
Widget earnWidget(String name, int points, Function function) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
    child: Card(
        elevation: 5,
        color: Colors.white,
        child: ListTile(
            onTap: () {
              function();
              logEvent('sp_action',
                  {'action': 'earned_sp', 'brand': name, 'points': points});
            },
            leading: Text('$points ★',
                style: TextStyle(color: apheriaamber, fontSize: 22)),
            trailing: Icon(Icons.arrow_forward, color: darkapheriapink),
            title: Text(name, style: TextStyle(color: apheriapink)))),
  );
}

class AdPage extends StatefulWidget {
  AdPage(this.title, this.image, this.sp, this.url, this.benefits);
  String image, url, title;
  List<String> benefits;
  int sp;
  @override
  State<AdPage> createState() =>
      _AdPageState(this.title, this.image, this.sp, this.url, this.benefits);
}

class _AdPageState extends State<AdPage> {
  _AdPageState(this.title, this.image, this.sp, this.url, this.benefits);
  String image, url, title;
  List<String> benefits;

  int sp;
  int count = 5;

  void timer() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      count = 4;
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      count = 3;
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      count = 2;
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      count = 1;
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      count = 0;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: apheriapink,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              apheriaAppBar(context, 'back to star points'),
              Expanded(
                child: Center(
                  child: MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView(
                      shrinkWrap: true,
                      // physics: ScrollPhysics(),
                      children: [
                        //SizedBox(height:12),
                        GestureDetector(
                            onTap: () {
                              Uri URL = Uri.parse(url);
                              launchUrl(URL);

  logEvent('sp_action',
                  {'action': 'earn_ad_click', 'brand': title, });
            

                            },
                            child: Card(
                              elevation: 5,
                              shape: curvedcard,
                              color: apheriaamber,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Card(
                                  shape: curvedcard,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 12),
                                      Text(title,
                                          style: TextStyle(
                                              color: apheriapurple,
                                              fontSize: 25),
                                          textAlign: TextAlign.center),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          shape: curvedcard,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.asset(
                                              image,
                                              // height:500,width:500,
                                              //width: MediaQuery.of(context).size.width * 0.7
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Text('click to shop',style:TextStyle(color:apheriapink)),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListView.builder(
                                          itemCount: benefits.length,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Text('• ${benefits[index]}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: darkapheriapink));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                        //  Text('hi'),
                        //(height:12),

                        /*  Flexible(
                          //height:100,
                          child: ListView.builder(
                            physics:NeverScrollableScrollPhysics(),
                            shrinkWrap:true,
                            itemBuilder: (context, index) {
                            return Text(
                              '•',
                              textAlign: TextAlign.center,
                            );
                          },),
                        /*)*/
                        Flexible(
                  
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: perks.length,
                      itemBuilder: (context,index){
                      return Text('- ${perks[index]}',textAlign:TextAlign.center);}),
                  ),*/
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                shape: curvedcard,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                      elevation: 5,
                      color: darkapheriapink,
                      shape: curvedcard,
                      child: ListTile(
                          onTap: () {
                            if (count == 0) {
                              starpoints = starpoints + sp;
                              updateStarPoints();
                              setState(() {});
                            }
                            Navigator.pop(context);
                          },
                          leading: count == 0
                              ? Icon(Icons.star, color: Colors.white)
                              : Icon(Icons.timer_rounded, color: Colors.white),
                          title: Text(
                              count == 0
                                  ? 'redeem $sp star points'
                                  : 'please wait... $count',
                              style: TextStyle(color: Colors.white)),
                          subtitle: Text(
                              count == 0
                                  ? 'close ad'
                                  : 'close ad without points',
                              style: TextStyle(color: Colors.white)))),
                ),
              ),
            ],
          ),
        ));
  }
}

String myproductid = 'test_product';

class PurchasePage extends StatelessWidget {
  const PurchasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var upgrades = context.watch<DashPurchases>();

    Widget storeWidget;
    switch (upgrades.storeState) {
      case StoreState.loading:
        storeWidget = _PurchasesLoading();
      case StoreState.available:
        storeWidget = _PurchaseList();
      case StoreState.notAvailable:
        storeWidget = _PurchasesNotAvailable();
    }
    return Stack(
      children: [
        Center(
          child: Container(
              width: 500,
              child: Image.asset('images/files/ob51.png',
                  color: Colors.white.withOpacity(0.6))),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                starPointCounter('sp_page'),
                /*
                SizedBox(width:12),
                Container(
                          height: 66,
                          width: 66,
                          child: FloatingActionButton(
                              shape: circlecard,
                              heroTag: 'settings',
                              tooltip: 'settings',
                              backgroundColor: apheriapink,
                              child: Icon(Icons.settings,
                                  color: Colors.white, size: 50),
                              onPressed: () {
                                logEvent('navigation_action',
                                    {'action': 'home_button_settings'});
                                goTo(SettingsPage(), context);
                              }),
                        ),
                        */
              ],
            ),
            Expanded(
              child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color:Colors.white,
                 child:ListTile(
                  onTap:(){
                    Navigator.pop(context);
                   goTo(FilesListHome((){}), context);
                  },
                leading:Icon(Icons.store,color:apheriapink),
                trailing:Icon(Icons.arrow_forward,color:apheriapink),
                title:Text('spend star points',style:TextStyle(color:apheriapink)),
                  subtitle:Text('redeem new files',style:TextStyle(color:apheriapink)))),
        
                ),*/
                    //Text(myproductid),
                   /* Padding(
                      padding: const EdgeInsets.fromLTRB(12, 1, 12, 1),
                      child: Text('buy star points:'),
                    ),*/
                    storeWidget,
                    /*
                    _PurchaseWidget(
                        product: PurchasableProduct(ProductDetails(
                            id: 'test',
                            title: 'cluster',
                            description: 'test',
                            price: 'test',
                            rawPrice: 0,
                            currencyCode: 'test')),
                        onPressed: () {}),
                        */
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 1, 12, 1),
                      child: Text('earn star points with apheria partners:'),
                    ),
                    earnWidget('preworn', 10, () {
                      goTo(
                          AdPage(
                              'preworn',
                              'images/cardImages/brands/banners/preworn2.jpg',
                              10,
                              'https://preworn.ltd/?ref=apheria',
                              [
                                'use code "apheria" for 10% off!',
                                'largest second hand clothing seller in uk',
                                'free uk shipping',
                                'pay later available',
                                '25% off with mailing list',
                              ]),
                          context);
                    }),
                    earnWidget('artDiscount', 10, () {
                      goTo(
                          AdPage(
                              'artDiscount',
                              'images/cardImages/brands/banners/artDiscountBanner.png',
                              10,
                              'https://click.linksynergy.com/link?id=EQENbhsOODA&offerid=674330.4382132950466871378&bids=674330.4382132950466871378&bids=674330.4382132950466871378&type=2&murl=https%3a%2f%2fartdiscount.co.uk%2fproducts%2fpink-pig-classic-square-sketchbooks%3fvariant%3d32950466871378&',
                              [
                                'pink pig sketchbooks',
                                'made in Great Britain',
                                'handmade silk covers',
                                'acid free',
                                'archival quality white cartridge paper'
                              ]),
                          context);
                    }),
                    earnWidget("crafter's companion", 10, () {
                      goTo(
                          AdPage(
                              "crafter's companion",
                              'images/cardImages/brands/banners/craftcomp50.jpg',
                              10,
                              'https://www.awin1.com/cread.php?s=3259192&v=5655&q=449547&r=1548542',
                              [
                                'leading players in the papercraft, colouring and needlecraft',
                                ' innovative crafting tools and materials',
                                'founded by UK dragon Sara Davies'
                              ]),
                          context);
                    }),
                    earnWidget('wave phone case', 10, () {
                      goTo(
                          AdPage(
                              'wave phone case',
                              'images/cardImages/brands/banners/diyWaveBanner.png',
                              10,
                              'https://www.awin1.com/cread.php?awinmid=24785&awinaffid=1548542&clickref=apheria&ued=https%3A%2F%2Fwww.wavecase.co.uk%2Fcollections%2Fall',
                              [
                                'phone cases made from biodegradeable wheat straw',
                                'proud member of 1% for the planet',
                                'simple + sustainable packaging',
                                'surfers against sewage 250 club',
                                'carbon neutral shipping',
                                'return old wave case for discount on new one'
                              ]),
                          context);
                    }),
                   /* earnWidget('broken society', 10, () {
                      goTo(
                          AdPage(
                              'broken society',
                              'images/cardImages/brands/banners/brokensocietybanner.jpg',
                              10,
                              'https://www.awin1.com/cread.php?s=3635792&v=50895&q=463448&r=1548542',
                              [
                                'female owned and female run',
                                'eco-friendly, water-based dyes',
                                'unique artwork',
                                '100% vegan',
                                'zero-waste policy (never send clothing to landfill)',
                                'recyclable & biodegradable packaging',
                                'clothing is ethically produced'
                              ]),
                          context);
                    }),*/

                    /* const Padding(
                  padding: EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 0.0),
                  child: Text(
                    'Past purchases',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const PastPurchasesWidget(),*/
                  ]),
            ),
            BackToTransferScreen()
          ],
        ),
      ],
    );
  }
}

class _PurchasesLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Store is loading'));
  }
}

class _PurchasesNotAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Store not available'));
  }
}

class _PurchaseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var purchases = context.watch<DashPurchases>();
    var products = purchases.products;
        products.sort((a, b) => a.title.compareTo(b.title));

    return Column(
      children: products
          .map((product) => _PurchaseWidget(
              product: product,
              onPressed: () {
                purchases.buy(product);
              }))
          .toList(),
    );
  }
}

class _PurchaseWidget extends StatelessWidget {
  final PurchasableProduct product;
  final VoidCallback onPressed;

  const _PurchaseWidget({
    required this.product,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var title = product.title;
    if (product.status == ProductStatus.purchased) {
      title += ' (purchased)';
    }
    title = title.replaceAll('(apheria: an illustrated world)', '');
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            myproductid = product.id;
             logEvent('sp_action',
            {'action': 'sp_product_click', 'name': '1000 ★', 'points': 1000});
            onPressed();
          },
          child: Card(
            shape: curvedcard,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Card(
                  color: apheriaamber,
                  shape: curvedcard,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius:40,
                            child: Icon(Icons.star,color:darkapheriapink,size:33)
                          ),
                          Column(
                            children: [
                              Card(
                                color: darkapheriapink,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                                  child: Text(
                                    title,
                                    style: TextStyle(color: Colors.white,fontSize: 25),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Card(
                                //shape:curvedcard,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(product.description,
                                      style: TextStyle(color: apherialilac)),
                                ),
                              ),
                            ],
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(_trailing(),
                                  style: TextStyle(color: apheriapurple)),
                            ),
                          )
                        ]),
                  )),
            ),
          ),
        ));
  }

  String _trailing() {
    return switch (product.status) {
      ProductStatus.purchasable => product.price,
      ProductStatus.purchased => 'purchased',
      ProductStatus.pending => 'buying...'
    };
  }
}





///////////

class CounterStateWidget extends StatelessWidget {
  const CounterStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // This widget is the only widget that directly listens to the counter
    // and is thus updated almost every frame. Keep this as small as possible.
    var counter = context.watch<DashCounter>();
    return RichText(
      text: TextSpan(
        text: 'You have tapped Dash ',
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
              text: counter.countString,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const TextSpan(text: ' times!'),
        ],
      ),
    );
  }
}

///////////////


class _UpgradeWidget extends StatelessWidget {
  final Upgrade upgrade;
  final String title;
  final VoidCallback onPressed;

  const _UpgradeWidget({
    required this.upgrade,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        child: ListTile(
          leading: Center(
            widthFactor: 1,
            child: Text(
              upgrade.count.toString(),
            ),
          ),
          title: Text(
            title,
            style: !upgrade.purchasable
                ? const TextStyle(color: Colors.redAccent)
                : null,
          ),
          subtitle: Text('Produces ${upgrade.work} dashes per second'),
          trailing: Text(
            '${NumberFormat.compact().format(upgrade.cost)} dashes',
          ),
        ));
  }
}

///
///
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var firebaseNotifier = context.watch<FirebaseNotifier>();

    if (firebaseNotifier.isLoggingIn) {
      return const Center(
        child: Text('Logging in...'),
      );
    }
    return Center(
        child: FilledButton(
      onPressed: () {
        firebaseNotifier.login();
      },
      child: const Text('Login'),
    ));
  }
}
