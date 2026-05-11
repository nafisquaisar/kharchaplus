// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../../../../core/utils/AppFlushbar.dart';
// import '../../domain/entities/electricity_entity.dart';
// import '../provider/electricity_di.dart';
//
// class ElectricityBackendTestScreen extends ConsumerStatefulWidget {
//   const ElectricityBackendTestScreen({super.key});
//
//   @override
//   ConsumerState<ElectricityBackendTestScreen> createState() =>
//       _ElectricityBackendTestScreenState();
// }
//
// class _ElectricityBackendTestScreenState
//     extends ConsumerState<ElectricityBackendTestScreen> {
//   String _status = 'Idle';
//   String? _lastActionId;
//   String _latestResponse = 'None';
//   bool _isListening = false;
//   int _lastFetchCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     debugPrint('[TEST SCREEN] [INIT]');
//     debugPrint('[TEST SCREEN] [PROVIDER SCOPE] active');
//
//     ref.listen(electricityProvider, (previous, next) {
//       if (next.list.length != _lastFetchCount) {
//         _lastFetchCount = next.list.length;
//         _latestResponse = 'List updated: $_lastFetchCount items';
//         debugPrint('[STREAM UPDATE] count=$_lastFetchCount');
//       }
//       if (next.error != null && next.error != previous?.error) {
//         debugPrint('[STATE UPDATED] error=${next.error}');
//         AppFlushbar.showError(context, next.error!);
//       }
//     });
//   }
//
//   ElectricityEntity _fakeEntity({String? idOverride}) {
//     final now = DateTime.now();
//     final id = idOverride ?? now.millisecondsSinceEpoch.toString();
//     final uid = FirebaseAuth.instance.currentUser?.uid ?? 'test-user';
//
//     return ElectricityEntity(
//       id: id,
//       title: 'Test Bill $id',
//       startDate: now.subtract(const Duration(days: 30)),
//       endDate: now,
//       prevUnit: 1200,
//       currentUnit: 1350,
//       rate: 7.5,
//       isSynced: false,
//       isDeleted: false,
//       isEdited: false,
//       isActive: true,
//       isOfflineCreated: true,
//       version: 1,
//       createdAt: now,
//       updatedAt: now,
//       userId: uid,
//       serverId: null,
//     );
//   }
//
//   String? _validateEntity(ElectricityEntity entity) {
//     if (entity.title == null || entity.title!.trim().isEmpty) {
//       return 'Title is required';
//     }
//     if (entity.startDate.isAfter(entity.endDate)) {
//       return 'Invalid date range';
//     }
//     if (entity.prevUnit < 0 || entity.currentUnit < 0) {
//       return 'Units must be >= 0';
//     }
//     if (entity.prevUnit > entity.currentUnit) {
//       return 'Current unit must be >= previous unit';
//     }
//     if (entity.rate <= 0) {
//       return 'Rate must be > 0';
//     }
//     return null;
//   }
//
//   void _logStatus(String message) {
//     setState(() {
//       _status = message;
//     });
//   }
//
//   Future<void> _handleAdd() async {
//     debugPrint('[UI BUTTON CLICKED] [ADD]');
//     final notifier = ref.read(electricityProvider.notifier);
//
//     try {
//       AppFlushbar.showInfo(context, 'Uploading electricity data');
//       final entity = _fakeEntity();
//       _lastActionId = entity.id;
//       final error = _validateEntity(entity);
//       if (error != null) {
//         debugPrint('[TEST SCREEN] [VALIDATION ERROR] $error');
//         AppFlushbar.showError(context, error);
//         return;
//       }
//
//       final uid = FirebaseAuth.instance.currentUser?.uid;
//       if (uid == null) {
//         debugPrint('[TEST SCREEN] [AUTH ERROR] currentUser is null');
//         AppFlushbar.showError(context, 'Auth required for upload');
//         return;
//       }
//
//       debugPrint('[TEST SCREEN] [ADD PAYLOAD] id=${entity.id}');
//       debugPrint('[TEST SCREEN] [UID] $uid');
//       debugPrint('[TEST SCREEN] [FIRESTORE PATH] users/$uid/electricity_cycles');
//
//       await notifier.addElectricity(entity);
//       _logStatus('Add success: ${entity.id}');
//       _latestResponse = 'Upload success: ${entity.id}';
//       debugPrint('[TEST SCREEN] [ADD SUCCESS] ${entity.id}');
//       AppFlushbar.showSuccess(context, 'Electricity added successfully');
//     } catch (e) {
//       _logStatus('Add failed: $e');
//       _latestResponse = 'Upload failed: $e';
//       debugPrint('[TEST SCREEN] [ERROR] $e');
//       AppFlushbar.showError(context, 'Firebase upload failed');
//     }
//   }
//
//   Future<void> _handleFetch() async {
//     debugPrint('[UI BUTTON CLICKED] [FETCH]');
//     final notifier = ref.read(electricityProvider.notifier);
//
//     try {
//       AppFlushbar.showInfo(context, 'Fetching electricity data');
//       await notifier.loadElectricity();
//       _logStatus('Fetch success');
//       _latestResponse = 'Fetch success: ${ref.read(electricityProvider).list.length} items';
//       debugPrint('[TEST SCREEN] [FETCH SUCCESS] count=$_lastFetchCount');
//       AppFlushbar.showSuccess(context, 'Fetch success');
//     } catch (e) {
//       _logStatus('Fetch failed: $e');
//       _latestResponse = 'Fetch failed: $e';
//       debugPrint('[TEST SCREEN] [ERROR] $e');
//       AppFlushbar.showError(context, 'Fetch failed');
//     }
//   }
//
//   Future<void> _handleUpdate(ElectricityEntity? current) async {
//     debugPrint('[UI BUTTON CLICKED] [UPDATE]');
//     final notifier = ref.read(electricityProvider.notifier);
//
//     try {
//       AppFlushbar.showInfo(context, 'Updating electricity data');
//       final base = current ?? _fakeEntity(idOverride: _lastActionId);
//       if (base == null) {
//         _logStatus('Update skipped: no data');
//         return;
//       }
//
//       final updated = ElectricityEntity(
//         id: base.id,
//         title: '${base.title} (Updated)',
//         startDate: base.startDate,
//         endDate: base.endDate,
//         prevUnit: base.prevUnit,
//         currentUnit: base.currentUnit + 20,
//         rate: base.rate,
//         isSynced: base.isSynced,
//         isDeleted: base.isDeleted,
//         isEdited: true,
//         isActive: base.isActive,
//         isOfflineCreated: base.isOfflineCreated,
//         version: base.version + 1,
//         createdAt: base.createdAt,
//         updatedAt: DateTime.now(),
//         userId: base.userId,
//         serverId: base.serverId,
//       );
//
//       debugPrint('[TEST SCREEN] [UPDATE PAYLOAD] id=${updated.id}');
//       final error = _validateEntity(updated);
//       if (error != null) {
//         debugPrint('[TEST SCREEN] [VALIDATION ERROR] $error');
//         AppFlushbar.showError(context, error);
//         return;
//       }
//       await notifier.updateElectricity(updated);
//       _logStatus('Update success: ${updated.id}');
//       _latestResponse = 'Update success: ${updated.id}';
//       debugPrint('[TEST SCREEN] [UPDATE SUCCESS] ${updated.id}');
//       AppFlushbar.showSuccess(context, 'Update success');
//     } catch (e) {
//       _logStatus('Update failed: $e');
//       _latestResponse = 'Update failed: $e';
//       debugPrint('[TEST SCREEN] [ERROR] $e');
//       AppFlushbar.showError(context, 'Update failed');
//     }
//   }
//
//   Future<void> _handleDelete(ElectricityEntity? current) async {
//     debugPrint('[UI BUTTON CLICKED] [DELETE]');
//     final notifier = ref.read(electricityProvider.notifier);
//
//     try {
//       AppFlushbar.showInfo(context, 'Deleting electricity record');
//       final id = current?.id ?? _lastActionId;
//       if (id == null) {
//         _logStatus('Delete skipped: no data');
//         return;
//       }
//
//       debugPrint('[TEST SCREEN] [DELETE PAYLOAD] id=$id');
//       await notifier.deleteElectricity(id);
//       _logStatus('Delete success: $id');
//       _latestResponse = 'Delete success: $id';
//       debugPrint('[TEST SCREEN] [DELETE SUCCESS] $id');
//       AppFlushbar.showSuccess(context, 'Delete success');
//     } catch (e) {
//       _logStatus('Delete failed: $e');
//       _latestResponse = 'Delete failed: $e';
//       debugPrint('[TEST SCREEN] [ERROR] $e');
//       AppFlushbar.showError(context, 'Delete failed');
//     }
//   }
//
//   void _handleStreamStart() {
//     debugPrint('[UI BUTTON CLICKED] [STREAM]');
//     final notifier = ref.read(electricityProvider.notifier);
//
//     try {
//       notifier.startRealtimeListener();
//       _isListening = true;
//       _logStatus('Stream listening');
//       _latestResponse = 'Stream active';
//       debugPrint('[TEST SCREEN] [STREAM START]');
//       AppFlushbar.showInfo(context, 'Realtime listener started');
//     } catch (e) {
//       _isListening = false;
//       _logStatus('Stream failed: $e');
//       _latestResponse = 'Stream failed: $e';
//       debugPrint('[TEST SCREEN] [ERROR] $e');
//       AppFlushbar.showError(context, 'Stream failed');
//     }
//   }
//
//   Future<void> _handleSync() async {
//     debugPrint('[UI BUTTON CLICKED] [SYNC]');
//     final notifier = ref.read(electricityProvider.notifier);
//
//     try {
//       AppFlushbar.showInfo(context, 'Syncing pending data');
//       await notifier.syncPending();
//       _logStatus('Sync complete');
//       _latestResponse = 'Sync complete';
//       debugPrint('[TEST SCREEN] [SYNC COMPLETE]');
//       AppFlushbar.showSuccess(context, 'Sync success');
//     } catch (e) {
//       _logStatus('Sync failed: $e');
//       _latestResponse = 'Sync failed: $e';
//       debugPrint('[TEST SCREEN] [ERROR] $e');
//       AppFlushbar.showError(context, 'Sync failed');
//     }
//   }
//
//   Color _statusColor(ElectricityEntity entity) {
//     if (entity.isDeleted) {
//       return Colors.red;
//     }
//     if (!entity.isSynced || entity.isEdited || entity.isOfflineCreated) {
//       return Colors.orange;
//     }
//     return Colors.green;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(electricityProvider);
//     final latest = state.list.isNotEmpty ? state.list.first : null;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Electricity Backend Test'),
//       ),
//       body: Column(
//         children: [
//           _buildStatusSection(state),
//           _buildActions(latest),
//           const Divider(height: 1),
//           Expanded(
//             child: _buildList(state),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatusSection(state) {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Backend Status',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           Text('Status: $_status'),
//           Text('Realtime listener: ${_isListening ? 'Active' : 'Inactive'}'),
//           Text('Loading: ${state.isLoading}'),
//           Text('Syncing: ${state.isSyncing}'),
//           Text('Searching: ${state.isSearching}'),
//           Text('Error: ${state.error ?? "None"}'),
//           Text('Latest response: $_latestResponse'),
//           const SizedBox(height: 8),
//           const Text(
//             'Total Records',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Text('${state.list.length} items'),
//           const SizedBox(height: 8),
//           const Text(
//             'Firebase',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Text('UID: ${FirebaseAuth.instance.currentUser?.uid ?? 'null'}'),
//           Text('Path: ${FirebaseAuth.instance.currentUser?.uid == null ? 'users/{uid}/electricity_cycles' : 'users/${FirebaseAuth.instance.currentUser?.uid}/electricity_cycles'}'),
//           const SizedBox(height: 8),
//           const Text(
//             'Latest Data',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           if (state.list.isNotEmpty)
//             Text('Last ID: ${state.list.first.id}')
//           else
//             const Text('No data loaded'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActions(ElectricityEntity? latest) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       child: Wrap(
//         spacing: 8,
//         runSpacing: 8,
//         children: [
//           ElevatedButton(
//             onPressed: _handleAdd,
//             child: const Text('Add Electricity'),
//           ),
//           ElevatedButton(
//             onPressed: _handleFetch,
//             child: const Text('Fetch Electricity'),
//           ),
//           ElevatedButton(
//             onPressed: () => _handleUpdate(latest),
//             child: const Text('Update Electricity'),
//           ),
//           ElevatedButton(
//             onPressed: () => _handleDelete(latest),
//             child: const Text('Soft Delete Electricity'),
//           ),
//           ElevatedButton(
//             onPressed: _handleStreamStart,
//             child: const Text('Start Stream Listener'),
//           ),
//           ElevatedButton(
//             onPressed: _handleSync,
//             child: const Text('Sync Pending Data'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildList(state) {
//     if (state.isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     if (state.list.isEmpty) {
//       return const Center(child: Text('No records found'));
//     }
//
//     return ListView.separated(
//       padding: const EdgeInsets.all(12),
//       itemCount: state.list.length,
//       separatorBuilder: (_, __) => const Divider(),
//       itemBuilder: (context, index) {
//         final item = state.list[index];
//
//         return ListTile(
//           leading: CircleAvatar(
//             backgroundColor: _statusColor(item),
//           ),
//           title: Text(item.displayTitle),
//           subtitle: Text(
//             'Units: ${item.prevUnit} -> ${item.currentUnit} | Rate: ${item.rate}',
//           ),
//           trailing: Text(item.id),
//         );
//       },
//     );
//   }
// }
//
