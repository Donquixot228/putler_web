import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:neon/neon.dart';
import 'package:rive/rive.dart';

const int maxAttempts = 3;

class HomePage extends StatefulWidget {
  HomePage();

  static const String routeName = '/homePage';

  static Widget create() {
    return HomePage();
  }

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool get isPlaying => _controller?.isActive ?? false;
  late BannerAd staticAd;
  late BannerAd inlineAd;
  bool inlineAdLoaded = false;
  bool staticAdLoaded = false;
  InterstitialAd? interstitialAd;
  int interstitialAttempt = 0;
  RewardedAd? rewardedAd;
  int rewarderAdAttempt = 0;
  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMIInput<bool>? _hoverInput;
  SMIInput<bool>? _pressInput;
  static const AdRequest request = AdRequest(
      // contentUrl: '',
      // keywords: ['',''],
      // nonPersonalizedAds: false,
      );

  void loadStaticBannerAd() {
    staticAd = BannerAd(
      adUnitId: 'ca-app-pub-1384320474458887/5515575621',
      size: AdSize.banner,
      request: request,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            staticAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('ad failed to load ${error}');
        },
      ),
    );
    staticAd.load();
  }

  @override
  void initState() {
    loadStaticBannerAd();
    super.initState();
    rootBundle.load('assets/animations/rocket.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        var controller =
            StateMachineController.fromArtboard(artboard, 'Button');
        if (controller != null) {
          artboard.addController(controller);
          _hoverInput = controller.findInput('Hover');
          _pressInput = controller.findInput('Press');
        }
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/bg.png'),
        fit: BoxFit.fill,
      )),
      child: Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: Center(
                child: Neon(
                  text: 'Russian warship?',
                  color: Colors.yellow,
                  flickeringText: false,
                  font: NeonFont.NightClub70s,
                  blurRadius: 4,
                  fontSize: 35,
                  glowingDuration: const Duration(seconds: 2),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: Center(
                child: Neon(
                  text: 'Go fuck yourself!',
                  color: Colors.yellow,
                  flickeringText: true,
                  font: NeonFont.NightClub70s,
                  blurRadius: 5,
                  fontSize: 35,
                  glowingDuration: const Duration(seconds: 2),
                ),
              ),
            ),
            Container(
              child: _riveArtboard == null
                  ? const SizedBox()
                  : MouseRegion(
                      onEnter: (_) => _hoverInput?.value = true,
                      onExit: (_) => _hoverInput?.value = false,
                      child: GestureDetector(
                        onTapDown: (_) => _pressInput?.value = true,
                        onTapCancel: () => _pressInput?.value = false,
                        onTapUp: (_) => _pressInput?.value = false,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: Rive(
                            artboard: _riveArtboard!,
                          ),
                        ),
                      ),
                    ),
            ),
            SizedBox(
              child: AdWidget(
                ad: staticAd,
              ),
              width: staticAd.size.width.toDouble(),
              height: staticAd.size.height.toDouble(),
            )
          ],
        ),
      ),
    );
  }
}
