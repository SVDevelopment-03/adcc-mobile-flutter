import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/communities/services/communities_service.dart';
import 'package:adcc/features/communities/view/explore_community_screen.dart';
import 'package:flutter/material.dart';

class CommunityDetailsLoaderScreen extends StatefulWidget {
  final String communityId;

  const CommunityDetailsLoaderScreen({super.key, required this.communityId});

  @override
  State<CommunityDetailsLoaderScreen> createState() =>
      _CommunityDetailsLoaderScreenState();
}

class _CommunityDetailsLoaderScreenState
    extends State<CommunityDetailsLoaderScreen> {
  final CommunitiesService _communitiesService = CommunitiesService();
  CommunityModel? _community;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCommunity();
  }

  Future<void> _loadCommunity() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final response = await _communitiesService.getCommunityById(
      communityId: widget.communityId,
    );

    if (!mounted) return;

    if (response.success && response.data != null) {
      setState(() {
        _community = response.data;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = false;
      _error = response.message ?? 'Unable to load community details.';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Community Details')),
        body: Center(child: Text(_error!)),
      );
    }

    return ExploreCommunityScreen(community: _community!);
  }
}
