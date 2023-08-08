import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:uuid/uuid.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
class ClassProvider extends ChangeNotifier {

  final ScrollController controller = ScrollController();

  List images = [];
  Map result={};
  String amimate="False";
  int? selectedindex;


  String? loading = "False";
  int selectedmode = 0;
  List list = [];



  InterstitialAd? interstitialAd;

  final BannerAd bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-2649758662056392/1265177990',
      listener: BannerAdListener(onAdClosed: (Ad ad) {
        print("Ad Closed");
      }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
      }, onAdLoaded: (Ad ad) {
        print('Ad Loaded');
      }, onAdOpened: (Ad ad) {
        print('Ad opened');
      }),
      request: AdRequest());

  late AdWidget adWidget;





  LoadBannerad(){
    adWidget = AdWidget(ad: bannerAd);
    bannerAd..load();
  }

  LoadInterTialAds(){
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-2649758662056392/2362637243',
        request: AdManagerAdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            interstitialAd = ad;
            interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
          },
        ));


  }

  ShowIntertiial() {

    interstitialAd!.show();
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('%ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();

        InterstitialAd.load(
            adUnitId: 'ca-app-pub-2649758662056392/2362637243',
            request: AdManagerAdRequest(),
            adLoadCallback: InterstitialAdLoadCallback(
              onAdLoaded: (InterstitialAd ad) {
                interstitialAd = ad;
                interstitialAd!.setImmersiveMode(true);
              },
              onAdFailedToLoad: (LoadAdError error) {
                print('InterstitialAd failed to load: $error.');
                interstitialAd = null;
              },
            ));
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (InterstitialAd ad) => print('$ad impression occurred.'),
    );
  }




  SelectedMode(int value) {
    selectedmode = value;
    controller.animateTo(0, duration: Duration(seconds: 1), curve: Curves.linear);
    notifyListeners();
  }




  FechApi() async {
    await http
        .get(
      Uri.parse("https://bhankumari.github.io/Mahakal-Wallpaper/Wallpaper.json"),
    )
        .then((value) async {
      result = jsonDecode(value.body);
      images.clear();
      result.forEach((key, value) {
        images.add(key);
      });
      notifyListeners();
    });
  }


  var progressString = "";
  String? comingoriginal;
  String Circular = "False";
  String Linear = "True";



  ImageSaver(String image,context) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      var response = await Dio().get(image, onReceiveProgress: (rec, total) {

          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
          notifyListeners();
      },
          options: Options(
            responseType: ResponseType.bytes,
          ));
      String id = Uuid().v4();


      ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 100,
          name: id);

      if (progressString == "100%") {

        ShowIntertiial();

        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          message: "Successfuly Downloaded",
          icon: Icon(
            Icons.check,
            size: 28.0,
            color: Colors.green[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.green[300],
        )..show(context);

      }
      notifyListeners();
    } else {



      var response = await Dio().get(image, onReceiveProgress: (rec, total) {

          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
          notifyListeners();

      },
          options: Options(
            responseType: ResponseType.bytes,
          ));
      String postid = Uuid().v4();
      ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 100,
          name: postid);

      if (progressString == "100%") {
        ShowIntertiial();

        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          message: "Successfuly Downloaded",
          icon: Icon(
            Icons.check,
            size: 28.0,
            color: Colors.green[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.green[300],
        )..show(context);

      }
    }
    notifyListeners();
  }



 Animate(){
    amimate="True";
    notifyListeners();
 }


 SelectedIndex(int index){
    selectedindex=index;
    notifyListeners();

 }



}
