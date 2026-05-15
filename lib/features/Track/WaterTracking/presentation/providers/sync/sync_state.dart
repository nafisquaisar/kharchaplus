class SyncState {
  final bool isSyncing;
  final double progress;
  final DateTime? lastSyncAt;
  final String? error;

  const SyncState({
    required this.isSyncing,
    required this.progress,
    required this.lastSyncAt,
    required this.error,
  });

  factory SyncState.initial() {
    return const SyncState(
      isSyncing: false,
      progress: 0,
      lastSyncAt: null,
      error: null,
    );
  }

  SyncState copyWith({
    bool? isSyncing,
    double? progress,
    DateTime? lastSyncAt,
    String? error,
  }) {
    return SyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      progress: progress ?? this.progress,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      error: error,
    );
  }
}

