import 'package:flutter_test/flutter_test.dart';
import 'package:simple_live_app/modules/live_room/player/huya_recovery_policy.dart';

void main() {
  group('HuyaRecoveryPolicy.chooseQualityIndex', () {
    test('keeps the same named quality after refreshing room data', () {
      final index = HuyaRecoveryPolicy.chooseQualityIndex(
        const ['原画', '超清', '高清'],
        preferredName: '超清',
        previousIndex: 0,
      );

      expect(index, 1);
    });

    test('clamps the previous index when the named quality disappeared', () {
      final index = HuyaRecoveryPolicy.chooseQualityIndex(
        const ['原画', '高清'],
        preferredName: '蓝光',
        previousIndex: 5,
      );

      expect(index, 1);
    });

    test('returns -1 for an empty quality list', () {
      final index = HuyaRecoveryPolicy.chooseQualityIndex(
        const [],
        preferredName: '原画',
        previousIndex: 0,
      );

      expect(index, -1);
    });
  });

  group('HuyaRecoveryPolicy.rotateAfterFailure', () {
    test('starts with the CDN after the failed line', () {
      final urls = HuyaRecoveryPolicy.rotateAfterFailure(
        const ['cdn-1', 'cdn-2', 'cdn-3'],
        failedIndex: 0,
        attempt: 0,
      );

      expect(urls, const ['cdn-2', 'cdn-3', 'cdn-1']);
    });

    test('rotates again on the next recovery attempt', () {
      final urls = HuyaRecoveryPolicy.rotateAfterFailure(
        const ['cdn-1', 'cdn-2', 'cdn-3'],
        failedIndex: 0,
        attempt: 1,
      );

      expect(urls, const ['cdn-3', 'cdn-1', 'cdn-2']);
    });

    test('keeps the first CDN for a proactive credential refresh', () {
      final urls = HuyaRecoveryPolicy.rotateAfterFailure(
        const ['cdn-1', 'cdn-2', 'cdn-3'],
        failedIndex: -1,
        attempt: 0,
      );

      expect(urls, const ['cdn-1', 'cdn-2', 'cdn-3']);
    });
  });

  group('HuyaRecoveryPolicy.isOfflineConfirmed', () {
    test('does not trust a single transient offline response', () {
      expect(HuyaRecoveryPolicy.isOfflineConfirmed(1), isFalse);
    });

    test('accepts consecutive offline responses', () {
      expect(HuyaRecoveryPolicy.isOfflineConfirmed(2), isTrue);
    });
  });

  group('HuyaRecoveryPolicy.credentialRefreshDelay', () {
    final now = DateTime.fromMillisecondsSinceEpoch(1000000);

    test('refreshes before the credential expires', () {
      final delay = HuyaRecoveryPolicy.credentialRefreshDelay(
        now: now,
        expiresAt: now.add(const Duration(minutes: 5)),
      );

      expect(delay, const Duration(minutes: 4, seconds: 30));
    });

    test('refreshes quickly when close to expiry', () {
      final delay = HuyaRecoveryPolicy.credentialRefreshDelay(
        now: now,
        expiresAt: now.add(const Duration(seconds: 10)),
      );

      expect(delay, const Duration(seconds: 1));
    });

    test('refreshes quickly when the credential is already expired', () {
      final delay = HuyaRecoveryPolicy.credentialRefreshDelay(
        now: now,
        expiresAt: now.subtract(const Duration(seconds: 1)),
      );

      expect(delay, const Duration(seconds: 1));
    });

    test('uses a four minute fallback when expiry is unavailable', () {
      final delay = HuyaRecoveryPolicy.credentialRefreshDelay(
        now: now,
        expiresAt: null,
      );

      expect(delay, const Duration(minutes: 4));
    });
  });
}
