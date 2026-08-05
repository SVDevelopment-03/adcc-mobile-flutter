import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/core/utils/share_helper.dart';

import '../repositories/challenges_repository.dart';
import 'challenge_accepted_screen.dart';

class ChallengeDetailsScreen extends StatefulWidget {
  const ChallengeDetailsScreen({
    super.key,
    required this.challengeId,
  });

  final String challengeId;

  @override
  State<ChallengeDetailsScreen> createState() => _ChallengeDetailsScreenState();
}

class _ChallengeDetailsScreenState extends State<ChallengeDetailsScreen> {
  final ChallengesRepository _repository = ChallengesRepository();

  bool _isLoading = true;
  bool _isJoining = false;
  bool _isMarkingComplete = false;
  Map<String, dynamic>? _challengeData;

  @override
  void initState() {
    super.initState();
    _loadChallengeData();
  }

  Future<void> _loadChallengeData() async {
    final challenge = await _repository.fetchChallengeById(widget.challengeId);
    final isJoined = challenge?.isJoined == true ||
        await _repository.isChallengeJoined(widget.challengeId);

    if (!mounted) return;

    if (challenge != null) {
      setState(() {
        final remaining = (challenge.target - challenge.progress).clamp(
          0,
          challenge.target,
        );
        _challengeData = {
          'id': challenge.id,
          'image': challenge.image,
          'title': challenge.title,
          'description': challenge.description,
          'joined': challenge.participants,
          'daysLeft': challenge.daysLeft,
          'points': challenge.points,
          'progress': challenge.progress,
          'target': challenge.target,
          'unit': challenge.unit,
          'percentage': challenge.target == 0
              ? 0
              : ((challenge.progress / challenge.target) * 100).round(),
          'remaining': remaining,
          'rules': challenge.rules.isEmpty ? <String>[] : challenge.rules,
          'topPerformers': List<Map<String, dynamic>>.from(
            challenge.topPerformers.map(
              (performer) => {
                'rank': performer.rank,
                'name': performer.name,
                'value': performer.value,
              },
            ),
          ),
          'isJoined': isJoined,
          'isCompleted': false,
        };
        _isLoading = false;
      });
      return;
    }

    // No static fallback — if the challenge was not found, leave _challengeData null
    // so the UI shows the "Go Back" state above.
    setState(() {
      _challengeData = null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF094AAD)),
        ),
      );
    }

    final data = _challengeData;
    if (data == null) {
      return Scaffold(
        backgroundColor: Color(0xFFC9DAF4),
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Go Back'),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              ChallengeImges.challengeBackground,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 65, 16, 28),
            physics: const BouncingScrollPhysics(),
            children: [
            _ChallengeHero(
              imagePath: data['image'] as String,
              onBack: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 19),
            _ChallengeTitleBlock(
              title: data['title'] as String,
              description: data['description'] as String,
              onShare: () => ShareHelper.share(
                context,
                ShareHelper.challenge(
                  data['title'] as String,
                  data['id']?.toString() ?? '',
                ),
                subject: 'Check out this challenge on ADCC',
              ),
            ),
            const SizedBox(height: 28),
            _ChallengeMetricRow(
              joined: data['joined'] as int,
              daysLeft: data['daysLeft'] as int,
              points: data['points'] as int,
            ),
            const SizedBox(height: 25),
            _ProgressPanel(
              progress: data['progress'] as int,
              target: data['target'] as int,
              unit: data['unit'] as String,
              percentage: data['percentage'] as int,
              remaining: data['remaining'] as int,
            ),
            const SizedBox(height: 40),
            _ChallengeRules(rules: data['rules'] as List<String>),
            const SizedBox(height: 38),
            _TopPerformersPanel(
              performers: data['topPerformers'] as List<Map<String, dynamic>>,
              onViewAll: () => debugPrint('View all performers tapped'),
            ),
            const SizedBox(height: 28),
            _PrimaryActionButton(
              text: data['isJoined'] == true ? 'Joined' : 'Join Challenge',
              onPressed: (data['isJoined'] == true || _isJoining)
                  ? null
                  : () => _joinChallenge(data),
            ),
            const SizedBox(height: 28),
            _OutlineActionButton(
              text: (data['progress'] as int) >= (data['target'] as int)
                  ? 'Mark as complete'
                  : 'Progress incomplete',
              onPressed: (data['isJoined'] == true &&
                      data['isCompleted'] == false &&
                      !_isMarkingComplete &&
                      (data['progress'] as int) >= (data['target'] as int))
                  ? () => _markChallengeComplete(data)
                  : null,
            ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _joinChallenge(Map<String, dynamic> data) async {
    if (data['isJoined'] == true || _isJoining) return;

    setState(() => _isJoining = true);

    final success = await _repository.joinChallenge(widget.challengeId);

    if (!mounted) return;
    setState(() => _isJoining = false);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to join challenge')),
      );
      return;
    }

    // Optimistically update UI and navigate
    setState(() {
      data['isJoined'] = true;
      data['joined'] = (data['joined'] as int) + 1;
    });

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => _JoinSuccessDialog(
        title: data['title'] as String,
        onContinue: () => Navigator.of(dialogContext).pop(),
      ),
    );
  }

  Future<void> _markChallengeComplete(Map<String, dynamic> data) async {
    final progress = data['progress'] as int;
    final target = data['target'] as int;
    if (data['isJoined'] != true ||
        data['isCompleted'] == true ||
        _isMarkingComplete ||
        progress < target) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You can only mark the challenge complete after you reach the target progress.',
          ),
        ),
      );
      return;
    }

    setState(() => _isMarkingComplete = true);

    final challengeResponse = await _repository.updateChallengeProgress(
      widget.challengeId,
      progress: data['target'] as int,
      progressPercent: 100,
    );

    if (!mounted) return;

    setState(() => _isMarkingComplete = false);

    if (challengeResponse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update challenge progress')),
      );
      return;
    }

    setState(() {
      data['isCompleted'] = true;
      data['progress'] = data['target'] as int;
      data['percentage'] = 100;
      data['remaining'] = 0;
    });

    final rewardBadge = challengeResponse['rewardBadge'];
    final badgeName = rewardBadge is Map<String, dynamic>
        ? ResponseParser.asString(rewardBadge['name'],
            fallback: 'Completion Badge')
        : 'Completion Badge';
    final badgeSubtitle = rewardBadge is Map<String, dynamic>
        ? ResponseParser.asString(
            rewardBadge['description'],
            fallback: 'Great work finishing the challenge!',
          )
        : 'Great work finishing the challenge!';
    final badgeImage = rewardBadge is Map<String, dynamic>
        ? ResponseParser.asString(rewardBadge['image'])
        : '';

    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChallengeAcceptedScreen(
          challengeId: widget.challengeId,
          challengeTitle: data['title'] as String,
          challengeImageUrl: data['image'] as String?,
          badgeName: badgeName,
          badgeSubtitle: badgeSubtitle,
          badgeImageUrl: badgeImage,
          rewardPoints: data['points'] as int?,
        ),
      ),
    );
  }
}

class _JoinSuccessDialog extends StatelessWidget {
  const _JoinSuccessDialog({
    required this.title,
    required this.onContinue,
  });

  final String title;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8F4),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -28,
              top: -22,
              child: Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x1A06A16F),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: onContinue,
                      icon: const Icon(Icons.close_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        fixedSize: const Size(36, 36),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ClipOval(
                    child: Image.asset(
                      'assets/icons/checkmark.gif',
                      height: 96,
                      width: 96,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    "You're registered!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: Color(0xFF1A1C20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You joined "$title" successfully. Get ready for the challenge!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.35,
                      color: Color(0xFF525252),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: onContinue,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFF094AAD),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChallengeHero extends StatelessWidget {
  const _ChallengeHero({
    required this.imagePath,
    required this.onBack,
  });

  final String imagePath;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 414,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 414,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _ChallengeImage(path: imagePath),
                  Positioned(
                    left: -35,
                    bottom: -35,
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF094AAD),
                        BlendMode.srcIn,
                      ),
                      child: Image.asset(
                        'assets/images/frame_1.png',
                        width: 160,
                        height: 160,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 15,
            top: 18,
            child: GestureDetector(
              onTap: onBack,
              child: Container(
                width: 35,
                height: 35,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF094AAD),
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeImage extends StatelessWidget {
  const _ChallengeImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/Rectangle22.png',
          fit: BoxFit.cover,
        ),
      );
    }

    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/Rectangle22.png',
        fit: BoxFit.cover,
      ),
    );
  }
}

class _ChallengeTitleBlock extends StatelessWidget {
  const _ChallengeTitleBlock({
    required this.title,
    required this.description,
    required this.onShare,
  });

  final String title;
  final String description;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  height: 1.27,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                  color: Color(0xFF1A1C20),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: IconButton(
            onPressed: onShare,
            style: IconButton.styleFrom(
              fixedSize: const Size(35, 35),
              backgroundColor: const Color(0xFFC9DAF4),
              padding: EdgeInsets.zero,
            ),
            icon: const Icon(
              Icons.share_outlined,
              color: Color(0xFF8f816b),
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChallengeMetricRow extends StatelessWidget {
  const _ChallengeMetricRow({
    required this.joined,
    required this.daysLeft,
    required this.points,
  });

  final int joined;
  final int daysLeft;
  final int points;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.groups_outlined,
            label: 'Joined',
            value: '$joined',
          ),
        ),
        const SizedBox(width: 21),
        Expanded(
          child: _MetricCard(
            icon: Icons.schedule_rounded,
            label: 'Days Left',
            value: '$daysLeft',
          ),
        ),
        const SizedBox(width: 21),
        Expanded(
          child: _MetricCard(
            icon: Icons.stars_rounded,
            label: 'Points',
            value: '$points',
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 71,
      padding: const EdgeInsets.fromLTRB(12, 14, 8, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFC9DAF4),
        borderRadius: BorderRadius.circular(9.95),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF8f816b), size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12.44,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 15.8,
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressPanel extends StatelessWidget {
  const _ProgressPanel({
    required this.progress,
    required this.target,
    required this.unit,
    required this.percentage,
    required this.remaining,
  });

  final int progress;
  final int target;
  final String unit;
  final int percentage;
  final int remaining;

  @override
  Widget build(BuildContext context) {
    final progressRatio =
        target <= 0 ? 0.0 : (progress / target).clamp(0.0, 1.0);

    return Container(
      height: 160,
      padding: const EdgeInsets.fromLTRB(19, 25, 19, 17),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: CachedNetworkImageProvider(
            ChallengeImges.challengeProgressBackground,
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Color.fromARGB(255, 174, 210, 255),
            BlendMode.dstOver, // or multiply, overlay, modulate, etc.
          ),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: Divider(
                  color: Color(0xffFFFFFF),
                  thickness: 1,
                  indent: 0,
                  endIndent: 8,
                ),
              ),
              _ProgressTargetIcon(),
              SizedBox(width: 30),
              Text(
                'Your Progress',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.56,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 30),
              _ProgressTargetIcon(),
              Expanded(
                child: Divider(
                  color: Color(0xFFFFFFFF),
                  thickness: 1,
                  indent: 8,
                  endIndent: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.56,
                  color: Colors.white,
                ),
              ),
              Text(
                '$progress/$target $unit',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.56,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progressRatio,
              minHeight: 11,
              backgroundColor: const Color.fromARGB(255, 162, 188, 237),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFFFFFFF)),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '$percentage% to go • $remaining $unit remaining',
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.34,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressTargetIcon extends StatelessWidget {
  const _ProgressTargetIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.45),
            ),
          ),
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.35),
            ),
          ),
          Container(
            width: 3.5,
            height: 3.5,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeRules extends StatelessWidget {
  const _ChallengeRules({required this.rules});

  final List<String> rules;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Challenge Rules',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1.25,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 24),
        for (final rule in rules) ...[
          _RuleRow(text: rule),
          if (rule != rules.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          size: 20,
          color: Color(0xFF094AAD),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.28,
              color: Color(0xFF525252),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 51,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF094AAD),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 17.46,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class _TopPerformersPanel extends StatelessWidget {
  const _TopPerformersPanel({
    required this.performers,
    required this.onViewAll,
  });

  final List<Map<String, dynamic>> performers;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final visiblePerformers = performers.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Top Performers',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1.25,
                color: Color(0xFF333333),
              ),
            ),
            TextButton(
              onPressed: onViewAll,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF484A4D),
                padding: EdgeInsets.zero,
                minimumSize: const Size(62, 28),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.28,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right_rounded, size: 16),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 19),
        Container(
          padding: const EdgeInsets.fromLTRB(21, 16, 21, 16),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                ChallengeImges.challengeTopPerformersBackground,
              ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Color.fromARGB(255, 255, 54, 54),
                BlendMode.dstOver, // or multiply, overlay, modulate, etc.
              ),
            ),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFf5baba),
                Color(0xFF094AAD),
              ],
              stops: [0, 1],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: visiblePerformers.isEmpty
              ? SizedBox(
                  height: 130,
                  child: Center(
                    child: Text(
                      'No performers yet. Join the challenge to appear here.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    for (var index = 0;
                        index < visiblePerformers.length;
                        index++) ...[
                      _PerformerRow(data: visiblePerformers[index]),
                      if (index != visiblePerformers.length - 1) ...[
                        const SizedBox(height: 16),
                        const Divider(height: 1, color: Colors.white),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _PerformerRow extends StatelessWidget {
  const _PerformerRow({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final value = data['value'].toString();
    final parts = value.split(' ');
    final amount = parts.isEmpty ? value : parts.first;
    final unit = parts.length > 1 ? parts.sublist(1).join(' ') : 'km';

    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFF8f816b),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.directions_bike_rounded,
                  color: Color(0xFF0A0A0A),
                  size: 25,
                ),
              ),
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFF094AAD),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events_outlined,
                    color: Colors.white,
                    size: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'].toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    height: 1.26,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Rank #${data['rank']}',
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    height: 1.26,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.26,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                unit,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.26,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  const _OutlineActionButton({
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 51,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF094AAD),
          disabledForegroundColor:
              const Color(0xFF094AAD).withValues(alpha: 0.45),
          side: BorderSide(
            color: onPressed == null
                ? const Color(0xFF094AAD).withValues(alpha: 0.45)
                : const Color(0xFF094AAD),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

// Removed static fallback rules and performers — UI is driven by API data only.
