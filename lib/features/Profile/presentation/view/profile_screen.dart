import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/profile_view_model.dart';
import '../widgets/profile_header.dart';
import '../widgets/stats_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<ProfileViewModel>().loadProfile()
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    if (vm.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          ProfileHeader(name: vm.name, email: vm.email),

          StatsCard(title: "Pending", value: vm.pending),
          StatsCard(title: "Completed", value: vm.completed),
        ],
      ),
    );
  }
}