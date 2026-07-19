import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/services/token_storage_service.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/events/services/events_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CompleteEvenetResult extends StatefulWidget {
  final String eventId;

  const CompleteEvenetResult({super.key, required this.eventId});

  @override
  State<CompleteEvenetResult> createState() => _CompleteEvenetResultState();
}

class _CompleteEvenetResultState extends State<CompleteEvenetResult> {
  final EventsService _eventsService = EventsService();
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _summary;
  List<Map<String, dynamic>> _leaderboard = [];
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _currentUserId = await TokenStorageService.getUserId();

    final summaryFuture =
        _eventsService.getCompletedEventSummary(eventId: widget.eventId);
    final leaderboardFuture =
        _eventsService.getCompletedEventLeaderboard(eventId: widget.eventId);

    final summaryResult = await summaryFuture;
    final leaderboardResult = await leaderboardFuture;

    if (!mounted) return;

    setState(() {
      _summary = summaryResult.success ? summaryResult.data : null;
      _leaderboard =
          leaderboardResult.success ? (leaderboardResult.data ?? []) : [];
      _errorMessage = summaryResult.success || leaderboardResult.success
          ? null
          : (summaryResult.message ??
              leaderboardResult.message ??
              'Failed to load event results');
      _isLoading = false;
    });
  }

  String _formatDate(String? rawDate) {
    final raw = rawDate?.trim();
    if (raw == null || raw.isEmpty) return '—';
    try {
      final parsed = DateTime.parse(raw).toLocal();
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${parsed.day} ${months[parsed.month - 1]} ${parsed.year}';
    } catch (_) {
      return raw;
    }
  }

  String _asText(dynamic value, {String fallback = '—'}) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? fallback : text;
  }

  Map<String, dynamic> get _eventMap {
    final event = _summary?['event'];
    if (event is Map<String, dynamic>) return event;
    if (_leaderboard.isNotEmpty) {
      final leaderboardEvent = _leaderboard.first['event'];
      if (leaderboardEvent is Map<String, dynamic>) return leaderboardEvent;
    }
    return const <String, dynamic>{};
  }

  String get _title =>
      _asText(_eventMap['title'], fallback: 'Completed Event Result');

  String get _eventDate => _formatDate(_eventMap['eventDate']?.toString());

  ImageProvider _resolveImage(String? imageValue) {
    final raw = imageValue?.trim();
    if (raw == null || raw.isEmpty) {
      return const AssetImage('assets/images/no-img.jpg');
    }

    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return NetworkImage(raw);
    }

    try {
      return AssetImage(raw);
    } catch (_) {
      return const AssetImage('assets/images/no-img.jpg');
    }
  }

  String? _resolveEventImage(Map<String, dynamic> event) {
    final imageCandidates = <String?>[
      event['mainImage']?.toString(),
      event['eventImage']?.toString(),
      event['image']?.toString(),
      event['coverImage']?.toString(),
    ];

    for (final candidate in imageCandidates) {
      if (candidate != null && candidate.trim().isNotEmpty) {
        return candidate.trim();
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5EDFF),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(EventsImgs.eventBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            color: AppColors.deepRed,
            onRefresh: _loadData,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              children: [
                Row(
                  children: [
                    _BackCircleButton(
                      onTap: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Completed Event Result',
                        style: TextStyle(
                          fontSize: 15.6,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.lightBeige),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 22),
                const Text(
                  'Your Result',
                  style: TextStyle(
                    fontSize: 13.4,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                _ResultCardRow(
                  left: _ResultCard(
                    title: 'Distance',
                    value: _asText(_summary?['distance'], fallback: '—'),
                    icon: Icons.route_rounded,
                  ),
                  right: _ResultCard(
                    title: 'Time',
                    value: _asText(_summary?['duration'], fallback: '—'),
                    icon: Icons.access_time_rounded,
                  ),
                ),
                const SizedBox(height: 12),
                _ResultCardRow(
                  left: _ResultCard(
                    title: 'Rank',
                    value: _asText(_summary?['rank'], fallback: '—'),
                    icon: Icons.leaderboard_rounded,
                  ),
                  right: _ResultCard(
                    title: 'Points Earned',
                    value: _asText(_summary?['pointsEarned'], fallback: '—'),
                    icon: Icons.stars_rounded,
                  ),
                ),
                const SizedBox(height: 12),
                _ResultCard(
                  title: 'Badge',
                  value:
                      _summary?['badge']?.toString().trim().isNotEmpty == true
                          ? _summary!['badge'].toString()
                          : '—',
                  icon: Icons.military_tech_rounded,
                  fullWidth: true,
                ),
                const SizedBox(height: 16),
                _EventSummaryCard(
                  title: _title,
                  subtitle: _eventDate,
                  imageProvider: _resolveImage(_resolveEventImage(_eventMap)),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Leaderboard (Top 10)',
                  style: TextStyle(
                    fontSize: 13.4,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 14),
                if (_leaderboard.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Center(
                      child: Text('No leaderboard data available yet'),
                    ),
                  )
                else
                  ..._leaderboard
                      .take(10)
                      .toList()
                      .asMap()
                      .entries
                      .map((entry) {
                    final index = entry.key;
                    final row = entry.value;
                    final user = row['user'];
                    final event = row['event'];
                    final isCurrentUser = _currentUserId != null &&
                        user is Map<String, dynamic> &&
                        user['_id']?.toString() == _currentUserId;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _LeaderboardRow(
                        rank: _asInt(row['rank'], fallback: index + 1),
                        name: isCurrentUser
                            ? 'You'
                            : _asText(
                                user is Map<String, dynamic>
                                    ? user['fullName']
                                    : null,
                                fallback: 'Rider',
                              ),
                        team: _asText(
                          event is Map<String, dynamic>
                              ? (event['community'] is Map<String, dynamic>
                                  ? (event['community']
                                      as Map<String, dynamic>)['title']
                                  : event['community']?['title'])
                              : null,
                          fallback: 'null',
                        ),
                        time: _asText(row['time'], fallback: '—'),
                        highlight: isCurrentUser,
                        faded: !isCurrentUser && index >= 3,
                      ),
                    );
                  }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _asInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }
}

class _BackCircleButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackCircleButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.fromARGB(255, 224, 199, 255),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          height: 35,
          width: 35,
          child: Icon(
            Icons.arrow_back,
            size: 15,
            color: Color(0xFF5818B8),
          ),
        ),
      ),
    );
  }
}

class _EventSummaryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final ImageProvider imageProvider;

  const _EventSummaryCard({
    required this.title,
    required this.subtitle,
    required this.imageProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image(
              image: imageProvider,
              height: 87,
              width: 95,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 1.15,
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.2,
                    fontWeight: FontWeight.w400,
                    color: AppColors.charcoal.withValues(alpha: 0.55),
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

class _ResultCardRow extends StatelessWidget {
  final Widget left;
  final Widget right;

  const _ResultCardRow({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String title;
  final String value;
  final bool fullWidth;
  final IconData icon;

  const _ResultCard({
    required this.title,
    required this.value,
    required this.icon,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: fullWidth ? 72 : 66,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 18,
            width: 18,
            decoration: const BoxDecoration(
              // color: AppColors.deepRed,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                size: 21,
                color: Color(0xFF5818B8),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    // color: AppColors.charcoal.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.9,
                    height: 1.15,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
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

class _LeaderboardRow extends StatelessWidget {
  final int rank;
  final String name;
  final String team;
  final String time;
  final bool highlight;
  final bool faded;

  const _LeaderboardRow({
    required this.rank,
    required this.name,
    required this.team,
    required this.time,
    this.highlight = false,
    this.faded = false,
  });

  @override
  Widget build(BuildContext context) {
    final double opacity = faded ? 0.35 : 1.0;

    return Opacity(
      opacity: opacity,
      child: Container(
        width: double.infinity,
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFD9DBF0),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Section — circular trophy avatar
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF5818B8),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Icon(
                  Icons.emoji_events_outlined,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Middle Section — name + team
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: highlight
                          ? const Color(0xFF5818B8)
                          : const Color(0xFF1A1A1A),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    team,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Right Section — race time
            Text(
              time,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D2D2D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _rankColor(int r) {
    if (r == 1) return const Color(0xFFD4A017); // golden
    if (r == 2)
      return const Color(0xFF1A1A1A).withValues(alpha: 0.55); // silver
    if (r == 3) return const Color(0xFFE87722); // bronze/orange
    return const Color(0xFF1A1A1A).withValues(alpha: 0.20);
  }
}
