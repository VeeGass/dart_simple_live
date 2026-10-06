class HuyaRecoveryPolicy {
  /// 一轮自动恢复的退避时间。
  static const retryDelays = <Duration>[
    Duration.zero,
    Duration(seconds: 1),
    Duration(seconds: 3),
  ];

  /// 一轮恢复失败后再次尝试的间隔。
  static const retryRoundDelay = Duration(seconds: 10);

  /// 连续收到多次“未开播”才确认下播，避免接口瞬时异常造成误判。
  static const offlineConfirmationCount = 2;

  static bool isOfflineConfirmed(int consecutiveOfflineResponses) =>
      consecutiveOfflineResponses >= offlineConfirmationCount;

  /// 播放器持续缓冲超过此时间后，主动获取新播放地址。
  static const stallTimeout = Duration(seconds: 15);

  /// 打开新地址后等待播放器真正开始播放的最长时间。
  static const startupTimeout = Duration(seconds: 12);

  /// 在凭证过期前提前换取新地址。
  static const credentialRefreshLeadTime = Duration(seconds: 30);

  /// 根据用户当前清晰度选择刷新后的清晰度。
  ///
  /// 优先按名称匹配，平台调整清晰度列表时再退回原索引附近。
  static int chooseQualityIndex(
    List<String> qualityNames, {
    required String preferredName,
    required int previousIndex,
  }) {
    if (qualityNames.isEmpty) {
      return -1;
    }

    final nameIndex = qualityNames.indexOf(preferredName);
    if (nameIndex >= 0) {
      return nameIndex;
    }

    return previousIndex.clamp(0, qualityNames.length - 1).toInt();
  }

  /// 将失败线路之后的 CDN 放到播放列表首位，并在每次重试时继续轮换。
  static List<T> rotateAfterFailure<T>(
    List<T> values, {
    required int failedIndex,
    required int attempt,
  }) {
    if (values.length < 2) {
      return List<T>.from(values);
    }

    final start = (failedIndex + attempt + 1) % values.length;
    return <T>[...values.skip(start), ...values.take(start)];
  }

  /// 计算凭证主动刷新延迟。过期时间不可用时交给错误恢复流程处理。
  static Duration? credentialRefreshDelay({
    required DateTime now,
    required DateTime? expiresAt,
  }) {
    if (expiresAt == null) {
      return null;
    }

    final remaining = expiresAt.difference(now);
    if (remaining <= credentialRefreshLeadTime) {
      return const Duration(seconds: 1);
    }
    return remaining - credentialRefreshLeadTime;
  }
}
