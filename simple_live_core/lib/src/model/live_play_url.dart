import 'dart:convert';

class LivePlayUrl {
  /// 播放地址
  final List<String> urls;

  /// 请求头
  final Map<String, String>? headers;

  /// 播放凭证过期时间。
  ///
  /// 大多数平台没有显式的过期时间，因此该值可以为空。客户端可以在凭证
  /// 到期前重新获取播放地址，避免播放器在旧地址失效后反复重试。
  final DateTime? expiresAt;

  LivePlayUrl({required this.urls, this.headers, this.expiresAt});

  @override
  String toString() {
    return json.encode({
      "urls": urls,
      "headers": headers.toString(),
      "expiresAt": expiresAt?.toIso8601String(),
    });
  }
}
