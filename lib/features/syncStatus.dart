import 'dart:async';

import 'package:flutter/material.dart';

enum SyncState { idle, syncing, synced, error }

enum ReportFilter { today, yesterday, custom }

class SyncModule {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color accentColor;
  SyncState state;
  double progress;
  DateTime? lastSynced;
  int recordCount;
  String? errorMessage;

  SyncModule({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.accentColor,
    this.state = SyncState.idle,
    this.progress = 0,
    this.lastSynced,
    this.recordCount = 0,
    this.errorMessage,
  });

  SyncModule copyWith({
    SyncState? state,
    double? progress,
    DateTime? lastSynced,
    int? recordCount,
    String? errorMessage,
  }) =>
      SyncModule(
        id: id,
        title: title,
        description: description,
        icon: icon,
        iconColor: iconColor,
        accentColor: accentColor,
        state: state ?? this.state,
        progress: progress ?? this.progress,
        lastSynced: lastSynced ?? this.lastSynced,
        recordCount: recordCount ?? this.recordCount,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}


class SyncLogEntry {
  final String module;
  final String event;
  final DateTime timestamp;
  final SyncState state;

  const SyncLogEntry({
    required this.module,
    required this.event,
    required this.timestamp,
    required this.state,
  });
}

// ─────────────────────────────────────────────
// SAMPLE DATA
// ─────────────────────────────────────────────
List<SyncModule> buildModules() => [
  SyncModule(
    id: 'farmers',
    title: 'Farmer Records',
    description: 'Profiles, land holdings & KYC data',
    icon: Icons.people_alt_outlined,
    iconColor: const Color(0xFF00628E),
    accentColor: const Color(0xFF00628E),
    state: SyncState.synced,
    lastSynced: DateTime.now().subtract(const Duration(minutes: 8)),
    recordCount: 248,
  ),
  SyncModule(
    id: 'crop',
    title: 'Crop Collection',
    description: 'FFB weighment & collection batches',
    icon: Icons.agriculture_outlined,
    iconColor: const Color(0xFF2E7D32),
    accentColor: const Color(0xFF2E7D32),
    state: SyncState.idle,
    lastSynced: DateTime.now().subtract(const Duration(hours: 3)),
    recordCount: 502,
  ),
  SyncModule(
    id: 'inventory',
    title: 'Inventory',
    description: 'Stock levels, transfers & valuation',
    icon: Icons.warehouse_outlined,
    iconColor: const Color(0xFFBB0013),
    accentColor: const Color(0xFFBB0013),
    state: SyncState.error,
    errorMessage: 'Network connection failed',
    lastSynced: DateTime.now().subtract(const Duration(hours: 6)),
    recordCount: 134,
  ),
];

List<SyncLogEntry> buildLogs() {
  final now = DateTime.now();
  return [
    SyncLogEntry(module: 'Farmer Records', event: '248 records synced successfully', timestamp: now.subtract(const Duration(minutes: 8)), state: SyncState.synced),
    SyncLogEntry(module: 'Crop Collection', event: 'Batch #501 uploaded (312 records)', timestamp: now.subtract(const Duration(hours: 1, minutes: 15)), state: SyncState.synced),
    SyncLogEntry(module: 'Inventory', event: 'Network connection failed – retrying', timestamp: now.subtract(const Duration(hours: 2)), state: SyncState.error),
    SyncLogEntry(module: 'Farmer Records', event: 'Delta sync: 12 new records', timestamp: now.subtract(const Duration(days: 1, hours: 3)), state: SyncState.synced),
    SyncLogEntry(module: 'Crop Collection', event: 'Batch #500 uploaded (198 records)', timestamp: now.subtract(const Duration(days: 1, hours: 5)), state: SyncState.synced),
    SyncLogEntry(module: 'Inventory', event: 'Stock transfer records updated', timestamp: now.subtract(const Duration(days: 1, hours: 6)), state: SyncState.synced),
    SyncLogEntry(module: 'Crop Collection', event: 'Batch #499 upload failed – network error', timestamp: now.subtract(const Duration(days: 2, hours: 1)), state: SyncState.error),
    SyncLogEntry(module: 'Farmer Records', event: 'Full sync completed (248 records)', timestamp: now.subtract(const Duration(days: 2, hours: 4)), state: SyncState.synced),
    SyncLogEntry(module: 'Inventory', event: '134 inventory records synced', timestamp: now.subtract(const Duration(days: 2, hours: 7)), state: SyncState.synced),
  ];
}

// ─────────────────────────────────────────────
// MAIN SCREEN
// ─────────────────────────────────────────────
class SyncStatusScreen extends StatefulWidget {
  const SyncStatusScreen({super.key});

  @override
  State<SyncStatusScreen> createState() => _SyncStatusScreenState();
}

class _SyncStatusScreenState extends State<SyncStatusScreen>
    with SingleTickerProviderStateMixin {
  int _navIndex = 1;
  late TabController _tabController;
  late List<SyncModule> _modules;
  final Map<String, Timer?> _timers = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _modules = buildModules();
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final t in _timers.values) {
      t?.cancel();
    }
    super.dispose();
  }

  // ── Simulate sync for a single module ──
  void _startSync(String moduleId) {
    final idx = _modules.indexWhere((m) => m.id == moduleId);
    if (idx == -1 || _modules[idx].state == SyncState.syncing) return;

    setState(() {
      _modules[idx] = _modules[idx].copyWith(
        state: SyncState.syncing,
        progress: 0.0,
        errorMessage: null,
      );
    });

    _timers[moduleId]?.cancel();
    _timers[moduleId] =
        Timer.periodic(const Duration(milliseconds: 250), (t) {
          if (!mounted) {
            t.cancel();
            return;
          }
          final i = _modules.indexWhere((m) => m.id == moduleId);
          if (i == -1) {
            t.cancel();
            return;
          }
          final newProgress = (_modules[i].progress + 0.035).clamp(0.0, 1.0);
          if (newProgress >= 1.0) {
            t.cancel();
            setState(() {
              _modules[i] = _modules[i].copyWith(
                state: SyncState.synced,
                progress: 1.0,
                lastSynced: DateTime.now(),
                errorMessage: null,
              );
            });
          } else {
            setState(() {
              _modules[i] = _modules[i]
                  .copyWith(state: SyncState.syncing, progress: newProgress);
            });
          }
        });
  }

  void _syncAll() {
    for (int i = 0; i < _modules.length; i++) {
      Future.delayed(
        Duration(milliseconds: i * 350),
            () => _startSync(_modules[i].id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: cs.primary,
          onPressed: () {},
        ),
        title: const Text(
          'Sync Status',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF291715)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            color: Colors.grey.shade600,
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: cs.primary,
              unselectedLabelColor: Colors.grey.shade500,
              indicatorColor: cs.primary,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 14),
              tabs: const [Tab(text: 'Status'), Tab(text: 'Report')],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _StatusTab(
            modules: _modules,
            onSync: _startSync,
            onSyncAll: _syncAll,
          ),
          _ReportTab(allLogs: buildLogs()),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        selected: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STATUS TAB
// ─────────────────────────────────────────────
class _StatusTab extends StatelessWidget {
  final List<SyncModule> modules;
  final void Function(String id) onSync;
  final VoidCallback onSyncAll;

  const _StatusTab({
    required this.modules,
    required this.onSync,
    required this.onSyncAll,
  });

  @override
  Widget build(BuildContext context) {
    final allSynced = modules.every((m) => m.state == SyncState.synced);
    final anySyncing = modules.any((m) => m.state == SyncState.syncing);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      children: [
        _HeaderCard(
          allSynced: allSynced,
          anySyncing: anySyncing,
          modules: modules,
          onSyncAll: onSyncAll,
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            const Text(
              'DATA MODULES',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: Color(0xFF9E9E9E)),
            ),
            const Spacer(),
            Text('${modules.length} modules',
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF9E9E9E))),
          ],
        ),
        const SizedBox(height: 12),
        ...modules.map((m) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _ModuleSyncCard(
              module: m, onSync: () => onSync(m.id)),
        )),
        const SizedBox(height: 4),
        _InfoBanner(),
      ],
    );
  }
}

// ── Overall header card ──
class _HeaderCard extends StatelessWidget {
  final bool allSynced;
  final bool anySyncing;
  final List<SyncModule> modules;
  final VoidCallback onSyncAll;

  const _HeaderCard({
    required this.allSynced,
    required this.anySyncing,
    required this.modules,
    required this.onSyncAll,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasError = modules.any((m) => m.state == SyncState.error);

    String statusLabel;
    IconData statusIcon;

    if (anySyncing) {
      statusLabel = 'Syncing in progress…';
      statusIcon = Icons.sync_rounded;
    } else if (hasError) {
      statusLabel = 'Some modules need attention';
      statusIcon = Icons.warning_amber_rounded;
    } else if (allSynced) {
      statusLabel = 'All modules up to date';
      statusIcon = Icons.check_circle_rounded;
    } else {
      statusLabel = 'Ready to sync';
      statusIcon = Icons.cloud_upload_outlined;
    }

    final syncedCount =
        modules.where((m) => m.state == SyncState.synced).length;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.primary.withOpacity(0.82)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withOpacity(0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -16,
            bottom: -16,
            child: Icon(Icons.sync_rounded,
                size: 110,
                color: Colors.white.withOpacity(0.07)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status pill
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 14, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(statusLabel,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Ramcharan Oil Industries',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                '$syncedCount of ${modules.length} modules synced',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.78)),
              ),
              const SizedBox(height: 18),

              // Per-module mini progress bars
              Row(
                children: modules.map((m) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: m.state == SyncState.synced
                                  ? 1.0
                                  : m.state == SyncState.syncing
                                  ? m.progress
                                  : 0.0,
                              minHeight: 4,
                              backgroundColor:
                              Colors.white.withOpacity(0.2),
                              color: m.state == SyncState.error
                                  ? Colors.red.shade300
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            m.title.split(' ').first,
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

              // Sync All button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: anySyncing ? null : onSyncAll,
                  icon: anySyncing
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFFBB0013)),
                  )
                      : const Icon(Icons.cloud_sync_rounded, size: 18),
                  label:
                  Text(anySyncing ? 'Syncing…' : 'Sync All Modules'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFBB0013),
                    disabledBackgroundColor:
                    Colors.white.withOpacity(0.6),
                    disabledForegroundColor:
                    const Color(0xFFBB0013).withOpacity(0.5),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Individual module sync card ──
class _ModuleSyncCard extends StatelessWidget {
  final SyncModule module;
  final VoidCallback onSync;

  const _ModuleSyncCard(
      {required this.module, required this.onSync});

  @override
  Widget build(BuildContext context) {
    final isSyncing = module.state == SyncState.syncing;
    final isError = module.state == SyncState.error;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isError ? const Color(0xFFFFF0EE) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isError
              ? const Color(0xFFBA1A1A).withOpacity(0.35)
              : isSyncing
              ? module.accentColor.withOpacity(0.3)
              : Colors.grey.shade100,
          width: isError ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: icon + title + state badge ──
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: module.iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(module.icon,
                      color: module.iconColor, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Color(0xFF291715)),
                      ),
                      const SizedBox(height: 2),
                      Text(module.description,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _StateBadge(state: module.state),
              ],
            ),

            // ── Progress bar (while syncing) ──
            if (isSyncing) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: module.progress,
                        minHeight: 5,
                        backgroundColor: Colors.grey.shade100,
                        color: module.accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${(module.progress * 100).round()}%',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: module.accentColor),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 14),

            // ── Bottom row: meta info + sync button ──
            Row(
              children: [
                Icon(Icons.access_time_rounded,
                    size: 13, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Text(
                  module.lastSynced != null
                      ? _relTime(module.lastSynced!)
                      : 'Never synced',
                  style: TextStyle(
                      fontSize: 11, color: Colors.grey.shade500),
                ),
                const SizedBox(width: 12),
                Icon(Icons.folder_outlined,
                    size: 13, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Text(
                  '${module.recordCount} records',
                  style: TextStyle(
                      fontSize: 11, color: Colors.grey.shade500),
                ),
                const Spacer(),

                // ── Per-module SYNC BUTTON ──
                _SyncButton(
                  state: module.state,
                  accentColor: module.accentColor,
                  onTap: onSync,
                ),
              ],
            ),

            // ── Error message strip ──
            if (isError && module.errorMessage != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color:
                  const Color(0xFFBA1A1A).withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        size: 14, color: Color(0xFFBA1A1A)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        module.errorMessage!,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFBA1A1A),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _relTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

// ── Animated sync button ──
class _SyncButton extends StatelessWidget {
  final SyncState state;
  final Color accentColor;
  final VoidCallback onTap;

  const _SyncButton({
    required this.state,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSyncing = state == SyncState.syncing;
    final isSynced = state == SyncState.synced;
    final isError = state == SyncState.error;

    String label;
    IconData icon;
    Color bg;
    Color fg;

    if (isSyncing) {
      label = 'Syncing…';
      icon = Icons.sync_rounded;
      bg = accentColor.withOpacity(0.1);
      fg = accentColor;
    } else if (isSynced) {
      label = 'Sync Again';
      icon = Icons.refresh_rounded;
      bg = accentColor.withOpacity(0.08);
      fg = accentColor;
    } else if (isError) {
      label = 'Retry Sync';
      icon = Icons.replay_rounded;
      bg = const Color(0xFFBA1A1A).withOpacity(0.1);
      fg = const Color(0xFFBA1A1A);
    } else {
      label = 'Sync Now';
      icon = Icons.cloud_upload_outlined;
      bg = accentColor;
      fg = Colors.white;
    }

    return GestureDetector(
      onTap: isSyncing ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          boxShadow: (state == SyncState.idle)
              ? [
            BoxShadow(
                color: accentColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isSyncing
                ? SizedBox(
              width: 13,
              height: 13,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: fg),
            )
                : Icon(icon, size: 14, color: fg),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: fg)),
          ],
        ),
      ),
    );
  }
}

// ── State badge ──
class _StateBadge extends StatelessWidget {
  final SyncState state;
  const _StateBadge({required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case SyncState.synced:
        return _badge(Icons.check_circle_rounded, 'Synced',
            const Color(0xFF2E7D32));
      case SyncState.syncing:
        return _spinBadge('Syncing', Colors.blue.shade700);
      case SyncState.error:
        return _badge(Icons.error_rounded, 'Error',
            const Color(0xFFBA1A1A));
      default:
        return _badge(Icons.circle_outlined, 'Idle', Colors.grey);
    }
  }

  Widget _badge(IconData icon, String text, Color color) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(text,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color)),
        ],
      ),
    );
  }

  Widget _spinBadge(String text, Color color) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(
                strokeWidth: 1.5, color: color),
          ),
          const SizedBox(width: 4),
          Text(text,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color)),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.wifi_rounded,
              color: Colors.blue.shade700, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'For faster sync and reduced data usage, connect to Wi-Fi before syncing large batches.',
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.blue.shade800,
                  height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// REPORT TAB
// ─────────────────────────────────────────────
class _ReportTab extends StatefulWidget {
  final List<SyncLogEntry> allLogs;
  const _ReportTab({required this.allLogs});

  @override
  State<_ReportTab> createState() => _ReportTabState();
}

class _ReportTabState extends State<_ReportTab> {
  ReportFilter _filter = ReportFilter.today;
  String _selectedModule = 'All Modules';
  DateTimeRange? _customRange;

  static const _modules = [
    'All Modules',
    'Farmer Records',
    'Crop Collection',
    'Inventory',
  ];

  List<SyncLogEntry> get _filteredLogs {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    return widget.allLogs.where((log) {
      if (_selectedModule != 'All Modules' &&
          log.module != _selectedModule) return false;
      final logDay = DateTime(log.timestamp.year,
          log.timestamp.month, log.timestamp.day);
      switch (_filter) {
        case ReportFilter.today:
          return logDay == today;
        case ReportFilter.yesterday:
          return logDay == yesterday;
        case ReportFilter.custom:
          if (_customRange == null) return true;
          final from = DateTime(_customRange!.start.year,
              _customRange!.start.month, _customRange!.start.day);
          final to = DateTime(_customRange!.end.year,
              _customRange!.end.month, _customRange!.end.day);
          return !logDay.isBefore(from) && !logDay.isAfter(to);
      }
    }).toList();
  }

  Future<void> _pickRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate:
      DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _customRange ??
          DateTimeRange(
            start:
            DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now(),
          ),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx)
              .colorScheme
              .copyWith(primary: const Color(0xFFBB0013)),
        ),
        child: child!,
      ),
    );
    if (range != null) {
      setState(() {
        _customRange = range;
        _filter = ReportFilter.custom;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final logs = _filteredLogs;
    final synced =
        logs.where((l) => l.state == SyncState.synced).length;
    final errors =
        logs.where((l) => l.state == SyncState.error).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      children: [
        _Label('Time Range'),
        const SizedBox(height: 10),
        _DateFilterRow(
          selected: _filter,
          customRange: _customRange,
          onChanged: (f) {
            setState(() => _filter = f);
            if (f == ReportFilter.custom) _pickRange();
          },
        ),
        const SizedBox(height: 22),

        _Label('Module'),
        const SizedBox(height: 10),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _modules.length,
            separatorBuilder: (_, __) =>
            const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final active = _selectedModule == _modules[i];
              return GestureDetector(
                onTap: () => setState(
                        () => _selectedModule = _modules[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: active ? cs.primary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: active
                            ? cs.primary
                            : Colors.grey.shade200),
                    boxShadow: active
                        ? [
                      BoxShadow(
                          color: cs.primary.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3))
                    ]
                        : [],
                  ),
                  child: Text(
                    _modules[i],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: active
                          ? Colors.white
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 22),

        // Summary tiles
        Row(
          children: [
            _SummaryTile(
                label: 'Total',
                value: '${logs.length}',
                icon: Icons.list_alt_rounded,
                color: Colors.blueGrey.shade700),
            const SizedBox(width: 10),
            _SummaryTile(
                label: 'Synced',
                value: '$synced',
                icon: Icons.check_circle_outline_rounded,
                color: const Color(0xFF2E7D32)),
            const SizedBox(width: 10),
            _SummaryTile(
                label: 'Errors',
                value: '$errors',
                icon: Icons.error_outline_rounded,
                color: const Color(0xFFBA1A1A)),
          ],
        ),
        const SizedBox(height: 22),

        _Label('Sync Activity  ·  ${logs.length} events'),
        const SizedBox(height: 12),

        if (logs.isEmpty)
          _EmptyState()
        else
          ...logs.map((log) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _LogCard(entry: log),
          )),
      ],
    );
  }
}

class _DateFilterRow extends StatelessWidget {
  final ReportFilter selected;
  final DateTimeRange? customRange;
  final ValueChanged<ReportFilter> onChanged;

  const _DateFilterRow({
    required this.selected,
    required this.customRange,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final customLabel = customRange != null
        ? '${_f(customRange!.start)}–${_f(customRange!.end)}'
        : 'Custom';

    final items = [
      (ReportFilter.today, 'Today', Icons.today_rounded),
      (ReportFilter.yesterday, 'Yesterday', Icons.history_rounded),
      (ReportFilter.custom, customLabel, Icons.date_range_rounded),
    ];

    return Row(
      children: items.map((item) {
        final active = selected == item.$1;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(item.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: active ? cs.primary : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: active
                          ? cs.primary
                          : Colors.grey.shade200),
                  boxShadow: active
                      ? [
                    BoxShadow(
                        color: cs.primary.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3))
                  ]
                      : [],
                ),
                child: Column(
                  children: [
                    Icon(item.$3,
                        size: 18,
                        color: active
                            ? Colors.white
                            : Colors.grey.shade600),
                    const SizedBox(height: 4),
                    Text(
                      item.$2,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: active
                            ? Colors.white
                            : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _f(DateTime d) => '${d.day}/${d.month}';
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: color)),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: color)),
          ],
        ),
      ),
    );
  }
}

class _LogCard extends StatelessWidget {
  final SyncLogEntry entry;
  const _LogCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final isError = entry.state == SyncState.error;
    final Color accent =
    isError ? const Color(0xFFBA1A1A) : const Color(0xFF2E7D32);
    final IconData icon = isError
        ? Icons.error_outline_rounded
        : Icons.check_circle_outline_rounded;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isError ? const Color(0xFFFFF0EE) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isError
              ? const Color(0xFFBA1A1A).withOpacity(0.2)
              : Colors.grey.shade100,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accent, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.module,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: accent,
                        letterSpacing: 0.3)),
                const SizedBox(height: 2),
                Text(entry.event,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF291715))),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(_rel(entry.timestamp),
              style: TextStyle(
                  fontSize: 11, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  String _rel(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 52),
      child: Column(
        children: [
          Icon(Icons.inbox_rounded,
              size: 54, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text('No sync activity found',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500,
                  fontSize: 15)),
          const SizedBox(height: 4),
          Text('Try a different filter or date range',
              style: TextStyle(
                  fontSize: 12, color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.3,
          color: Color(0xFF9E9E9E)),
    );
  }
}

// ─────────────────────────────────────────────
// BOTTOM NAV
// ─────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final items = [
      (Icons.home_outlined, Icons.home_rounded, 'Home'),
      (Icons.sync_outlined, Icons.sync_rounded, 'Sync'),
      (Icons.storage_outlined, Icons.storage_rounded, 'Data'),
      (Icons.settings_outlined, Icons.settings_rounded, 'Settings'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border:
        Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final active = selected == i;
              return GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: active
                        ? cs.primary.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                          active ? items[i].$2 : items[i].$1,
                          color: active
                              ? cs.primary
                              : Colors.grey.shade500,
                          size: 24),
                      const SizedBox(height: 2),
                      Text(items[i].$3,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: active
                                  ? cs.primary
                                  : Colors.grey.shade500)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
 