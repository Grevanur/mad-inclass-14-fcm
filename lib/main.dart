import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'fcm_service.dart';
import 'firebase_options.dart';
import 'payload_validator.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('onBackgroundMessage: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const Activity14App());
}

class Activity14App extends StatelessWidget {
  const Activity14App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Activity 14: FCM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006B63)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FCMService _fcmService = FCMService();

  String _statusText = 'Waiting for a cloud message';
  String _imagePath = defaultAssetPath;
  String _feedback = 'Initializing messaging...';
  String _lastHandler = 'None yet';
  String _lastMessageId = 'None yet';
  int _messageCount = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_initializeMessaging());
  }

  void _report(String text) {
    debugPrint(text);
    if (mounted) {
      setState(() => _feedback = text);
    }
  }

  Future<void> _initializeMessaging() async {
    try {
      await _fcmService.initialize(onData: _handleMessage, onStatus: _report);
    } on FirebaseException catch (error, stack) {
      debugPrint('Firebase error: $error\n$stack');
      _report('Messaging error (${error.code}): ${error.message}');
    } on StateError catch (error, stack) {
      debugPrint('Messaging setup error: $error\n$stack');
      _report(error.message.toString());
    }
  }

  void _handleMessage(RemoteMessage message, String source) {
    if (!mounted) return;

    final decision = validatePayload(message.data);
    setState(() {
      _lastHandler = source;
      _lastMessageId = message.messageId ?? '(no ID)';
      _messageCount += 1;

      if (decision.isAccepted) {
        _statusText = message.notification?.title ?? 'Payload received';
        _imagePath = decision.assetPath!;
        _feedback = 'Applied payload ${message.messageId ?? "(no ID)"}';
      } else {
        _feedback = '${decision.diagnostic} Previous content preserved.';
      }
    });
  }

  @override
  void dispose() {
    unawaited(
      _fcmService.dispose().catchError((Object error, StackTrace stack) {
        debugPrint('FCM cleanup error: $error\n$stack');
      }),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity 14: Cloud Courier'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            _statusText,
            key: const Key('statusText'),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Image.asset(
                _imagePath,
                key: const Key('messageImage'),
                height: 220,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stack) {
                  debugPrint('Asset load error: $error');
                  return Text(
                    'Cannot load $_imagePath. Check the asset declaration.',
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery evidence',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Text('Last handler: $_lastHandler'),
                  Text('Messages handled this launch: $_messageCount'),
                  Text('Last message ID: $_lastMessageId'),
                  const SizedBox(height: 12),
                  Text(
                    _feedback,
                    key: const Key('feedbackText'),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Supported data: action=update_ui and asset=default or promo.',
          ),
        ],
      ),
    );
  }
}
