class SessionBase {
  final String? downloadDir;
  final bool? downloadQueueEnabled;
  final int? downloadQueueSize;
  final int? peerPort;
  final bool? speedLimitDownEnabled;
  final bool? speedLimitUpEnabled;
  final int? speedLimitDown;
  final int? speedLimitUp;

  const SessionBase({
    this.downloadDir,
    this.downloadQueueEnabled,
    this.downloadQueueSize,
    this.peerPort,
    this.speedLimitDownEnabled,
    this.speedLimitUpEnabled,
    this.speedLimitDown,
    this.speedLimitUp,
  });
}

abstract class Session extends SessionBase {
  const Session({
    super.downloadDir,
    super.downloadQueueEnabled,
    super.downloadQueueSize,
    super.peerPort,
    super.speedLimitDownEnabled,
    super.speedLimitUpEnabled,
    super.speedLimitDown,
    super.speedLimitUp,
  });

  Future<void> update(SessionBase session);
}
