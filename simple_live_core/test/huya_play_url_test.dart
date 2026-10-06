import 'package:simple_live_core/simple_live_core.dart';
import 'package:test/test.dart';

void main() {
  group('HuyaSite.getPlayUrlExpiresAt', () {
    test('parses the hexadecimal wsTime parameter', () {
      final expiresAt = HuyaSite().getPlayUrlExpiresAt(
        'https://example.com/live.flv?wsTime=65f00000&wsSecret=test',
      );

      expect(expiresAt, isNotNull);
      expect(
        expiresAt!.millisecondsSinceEpoch,
        int.parse('65f00000', radix: 16) * 1000,
      );
    });

    test('returns null when wsTime is unavailable', () {
      final expiresAt = HuyaSite().getPlayUrlExpiresAt(
        'https://example.com/live.flv?wsSecret=test',
      );

      expect(expiresAt, isNull);
    });

    test('parses wsTime without depending on parameter letter case', () {
      final expiresAt = HuyaSite().getPlayUrlExpiresAt(
        'https://example.com/live.flv?WSTIME=65f00000&wsSecret=test',
      );

      expect(expiresAt, isNotNull);
      expect(
        expiresAt!.millisecondsSinceEpoch,
        int.parse('65f00000', radix: 16) * 1000,
      );
    });
  });
}
