import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:storifyme_flutter/storifyme_flutter.dart';
import 'package:storifyme_flutter/util/storify_me_auto_layout_behavior.dart';
import 'package:storifyme_flutter/util/storify_me_story_audio_options.dart';
import 'package:storifyme_flutter/util/storify_me_story_playback_options.dart';

class WidgetSegmentsProvider extends ChangeNotifier {
  List<String> segments = [];

  void setSegments(List<String> segments) {
    this.segments = segments;
    notifyListeners();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
      create: (_) => WidgetSegmentsProvider(),
      child: const StorifyMeFlutterDemoApp()));
}

class StorifyMeFlutterDemoApp extends StatefulWidget {
  const StorifyMeFlutterDemoApp({super.key});

  @override
  State<StorifyMeFlutterDemoApp> createState() =>
      _StorifyMeFlutterDemoAppState();
}

class _StorifyMeFlutterDemoAppState extends State<StorifyMeFlutterDemoApp>
    with NativeEventListener {
  final _storifyMeFlutterPlugin = StorifyMeFlutterPlugin();

  var dummyCounter = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    try {
      // Please add your credentials
      await _storifyMeFlutterPlugin.initPlugin({
        Params.API_KEY_ID: 'API_KEY_ID',
        Params.ACCOUNT_ID_KEY: 'ACCOUNT_ID_KEY',
        Params.ENVIRONMENT_KEY: 'EU'
      });
      _storifyMeFlutterPlugin.setEventListener(this);
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }

    Future.delayed(const Duration(microseconds: 1)).then((value) {
      context
          .read<WidgetSegmentsProvider>()
          .setSegments(['homepage-ae-en-kids']);
    });

    Future.delayed(const Duration(seconds: 2)).then((value) {
      setState(() {
        dummyCounter += 1;
      });
    });

    Future.delayed(const Duration(seconds: 5)).then((value) {
      context
          .read<WidgetSegmentsProvider>()
          .setSegments(['homepage-ae-en-men']);
    });

    Future.delayed(const Duration(seconds: 7)).then((value) {
      setState(() {
        dummyCounter += 1;
      });
    });

    Future.delayed(const Duration(seconds: 10)).then((value) {
      context
          .read<WidgetSegmentsProvider>()
          .setSegments(['homepage-ae-en-women']);
    });

    Future.delayed(const Duration(seconds: 20)).then((value) {
      context
          .read<WidgetSegmentsProvider>()
          .setSegments(['homepage-ae-en-kids']);
    });

    Future.delayed(const Duration(seconds: 25)).then((value) {
      context
          .read<WidgetSegmentsProvider>()
          .setSegments(['homepage-ae-en-men']);
    });

    Future.delayed(const Duration(seconds: 30)).then((value) {
      context
          .read<WidgetSegmentsProvider>()
          .setSegments(['homepage-ae-en-women']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('StorifyMe Flutter Demo TEST'),
            ),
            body: SingleChildScrollView(
              child: Column(children: <Widget>[
                Text('StorifyMe Flutter Top Widgets $dummyCounter'),
                Container(height: 100, color: Colors.green),
                Consumer<WidgetSegmentsProvider>(
                    builder: (context, state, child) {
                  final segments = state.segments;
                  final String keyValue;
                  if (segments.isNotEmpty) {
                    keyValue = segments.first;
                  } else {
                    keyValue = 'unknown';
                  }
                  return StoriesViewWidget(
                      key: Key(keyValue),
                      segments: segments,
                      widgetId: 7789,
                      audioOptions: StorifyMeStoryAudioOptions(
                          behaviour: StorifyMeStoryAudioBehaviour
                              .applyChangeForPresentedStories,
                          defaultState: StorifyMeStoryAudioState.unmuted),
                      playbackOptions: StorifyMeStoryPlaybackOptions(
                          behaviour: StorifyMeStoryPlaybackBehaviour
                              .alwaysResumeStoryWhereStopped),
                      showLoadingActivityIndicator: true,
                      autoLayoutBehavior: StorifyMeAutoLayoutBehavior
                          .gridViewAdjustedFirstStory(0.85));
                }),
                Container(height: 100, color: Colors.green),
                const Text('StorifyMe Flutter Bottom Widgets')
              ]),
            )));
  }

  @override
  void onAction(String type, String dataJson) {
    debugPrint("onAction: $type");
  }

  @override
  void onEvent(String type, String dataJson) {
    debugPrint("onAction: $type");
  }

  @override
  void onFail(String exceptionMessage) {
    debugPrint("onFail: $exceptionMessage");
  }

  @override
  void onLoad(int widgetId, String storiesJson) {
    debugPrint("onLoad: $storiesJson");
  }

  @override
  void onStoryClosed(String? storyJson) {
    debugPrint("onStoryClosed: $storyJson");
  }

  @override
  void onStoryOpened(String? storyJson, int index) {
    debugPrint("onStoryOpened: $storyJson");
  }

  @override
  void onStoryFinished(String? storyJson, int index) {
    debugPrint("onStoryFinished: $storyJson");
  }

  @override
  void onStoryShared(String? storyJson) {
    debugPrint("onStoryShared: $storyJson");
  }
}
