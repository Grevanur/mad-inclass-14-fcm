import 'package:flutter_test/flutter_test.dart';
import 'package:inclass_14/payload_validator.dart';

void main() {
  group('validatePayload', () {
    test('accepts the supported promo payload', () {
      final result = validatePayload({'action': 'update_ui', 'asset': 'promo'});

      expect(result.isAccepted, isTrue);
      expect(result.assetPath, 'assets/images/promo.png');
      expect(result.diagnostic, isNull);
    });

    test('accepts the supported default payload', () {
      final result = validatePayload({
        'action': 'update_ui',
        'asset': 'default',
      });

      expect(result.isAccepted, isTrue);
      expect(result.assetPath, defaultAssetPath);
    });

    test('rejects a missing asset', () {
      final result = validatePayload({'action': 'update_ui'});

      expect(result.isAccepted, isFalse);
      expect(result.assetPath, isNull);
      expect(result.diagnostic, contains('asset'));
    });

    test('rejects an unsupported asset', () {
      final result = validatePayload({
        'action': 'update_ui',
        'asset': 'unknown',
      });

      expect(result.isAccepted, isFalse);
      expect(result.diagnostic, contains('default or promo'));
    });

    test('rejects an unsupported action', () {
      final result = validatePayload({'action': 'delete_ui', 'asset': 'promo'});

      expect(result.isAccepted, isFalse);
      expect(result.diagnostic, contains('update_ui'));
    });
  });
}
