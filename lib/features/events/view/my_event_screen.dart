import 'dart:convert';

import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/profile/models/profile_history_models.dart';
import 'package:adcc/features/profile/repositories/profile_repository.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MYEVENET extends StatefulWidget {
  const MYEVENET({super.key});

  @override
  State<MYEVENET> createState() => _MYEVENETState();
}

class _MYEVENETState extends State<MYEVENET> {
  static const Color _backgroundColor = Color(0xFFF4F0FF);
  static const Color _primaryBlue = Color(0xFF5818B8);

  final ProfileRepository _profileRepository = ProfileRepository();

  int _selectedTab = 0;
  bool _isLoading = true;
  String? _errorMessage;

  List<_MyEventCardData> _completedEvents = const [];
  List<_MyEventCardData> _upcomingEvents = const [];
  List<_MyEventCardData> _cancelledEvents = const [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final completedFuture = _profileRepository.fetchCompletedEvents();
      final upcomingFuture = _profileRepository.fetchActiveParticipations();

      final results = await Future.wait<dynamic>([
        completedFuture,
        upcomingFuture,
      ]);

      final completedEvents = results[0] as List<ProfileEventHistoryItem>;
      final upcomingEvents = results[1] as List<ProfileUpcomingEventItem>;

      if (!mounted) return;

      setState(() {
        _completedEvents = completedEvents
            .map(
              (item) => _MyEventCardData(
                id: item.id,
                title: item.title,
                date: _formatDate(item.date),
                time: _formatTime(item.time),
                statusLabel: 'Completed',
                imageProvider: _resolveImage(item.image),
                accentColor: _primaryBlue,
              ),
            )
            .toList();

        _upcomingEvents = upcomingEvents
            .map(
              (item) => _MyEventCardData(
                id: item.id,
                title: item.title,
                date: _formatDate(item.date),
                time: _formatTime(item.time),
                statusLabel: 'Upcoming',
                imageProvider: _resolveImage(item.image),
                accentColor: const Color(0xFF5818B8),
              ),
            )
            .toList();

        _cancelledEvents = const [];
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  List<_MyEventCardData> get _visibleEvents {
    switch (_selectedTab) {
      case 0:
        return _completedEvents;
      case 1:
        return _upcomingEvents;
      case 2:
        return _cancelledEvents;
      default:
        return _completedEvents;
    }
  }

  String _formatDate(String rawDate) {
    if (rawDate.isEmpty || rawDate == '—') return 'Date unavailable';

    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return rawDate;

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
  }

  String _formatTime(String rawTime) {
    if (rawTime.isEmpty || rawTime == '—') return 'Time unavailable';

    final parsed = DateTime.tryParse(rawTime);
    if (parsed != null) {
      final hour = parsed.hour % 12 == 0 ? 12 : parsed.hour % 12;
      final minute = parsed.minute.toString().padLeft(2, '0');
      final period = parsed.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    }

    return rawTime;
  }

  ImageProvider _resolveImage(String? imageValue) {
    final raw = imageValue?.trim();
    if (raw == null || raw.isEmpty) {
      return const AssetImage('assets/images/no-img.jpg');
    }

    if (raw.startsWith('http')) {
      return NetworkImage(raw);
    }

    try {
      final cleaned = raw.contains('base64,') ? raw.split('base64,').last : raw;
      return MemoryImage(base64Decode(cleaned));
    } catch (_) {
      return const AssetImage('assets/images/no-img.jpg');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(EventsImgs.eventBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _RoundBackButton(
                        onTap: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 56),
                      child: Text(
                        AppLocalizations.of(context)!.myEvents,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                          color: Color(0xFF111111),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _TopTabs(
                  selectedTab: _selectedTab,
                  tabs: [
                    AppLocalizations.of(context)!.challenge_tab_completed,
                    AppLocalizations.of(context)!.challenge_tab_upcoming,
                    AppLocalizations.of(context)!.challenge_tab_cancelled,
                  ],
                  onTabTap: (index) {
                    setState(() => _selectedTab = index);
                  },
                  selectedColor: _primaryBlue,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: RefreshIndicator(
                  color: _primaryBlue,
                  onRefresh: _loadEvents,
                  child: _buildContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        children: const [
          SizedBox(height: 120),
          Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (_errorMessage != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        children: [
          const SizedBox(height: 120),
          Center(
            child: Column(
              children: [
                const Icon(Icons.event_busy_rounded,
                    size: 42, color: Color(0xFF5818B8)),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.failedToLoadEvents,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111111),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    color: AppColors.charcoal.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _loadEvents,
                  child: Text(AppLocalizations.of(context)!.retry),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final events = _visibleEvents;
    if (events.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
        children: [
          _EmptyState(
            title: _selectedTab == 2
                ? AppLocalizations.of(context)!.noCancelledEvents
                : AppLocalizations.of(context)!.noEventsFound,
            subtitle: _selectedTab == 2
                ? AppLocalizations.of(context)!.cancelledEventsHint
                : AppLocalizations.of(context)!.eventHistoryHint,
            icon: _selectedTab == 2
                ? Icons.event_busy_rounded
                : Icons.event_available_rounded,
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
      itemCount: events.length,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final event = events[index];
        return _EventCard(
          data: event,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EventDetailsScreen(eventId: event.id),
              ),
            );
          },
        );
      },
    );
  }
}

class _RoundBackButton extends StatelessWidget {
  const _RoundBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.fromARGB(255, 224, 199, 255),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          height: 40,
          width: 40,
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

class _TopTabs extends StatelessWidget {
  const _TopTabs({
    required this.tabs,
    required this.selectedTab,
    required this.onTabTap,
    required this.selectedColor,
  });

  final List<String> tabs;
  final int selectedTab;
  final ValueChanged<int> onTabTap;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tabWidth = constraints.maxWidth / tabs.length;

        return Column(
          children: [
            Row(
              children: List.generate(
                tabs.length,
                (index) => Expanded(
                  child: InkWell(
                    onTap: () => onTabTap(index),
                    borderRadius: BorderRadius.circular(999),
                    child: SizedBox(
                      height: 40,
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOut,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 15.5,
                            fontWeight: FontWeight.w600,
                            color: selectedTab == index
                                ? selectedColor
                                : const Color(0xFF666666),
                          ),
                          child: Text(tabs[index]),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Stack(
              children: [
                Container(
                  height: 1,
                  color: const Color(0xFFD9D5F2),
                ),
                AnimatedAlign(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOut,
                  alignment: selectedTab == 0
                      ? Alignment.centerLeft
                      : selectedTab == 1
                          ? Alignment.center
                          : Alignment.centerRight,
                  child: Container(
                    width: tabWidth,
                    height: 2,
                    decoration: BoxDecoration(
                      color: selectedColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.data, required this.onTap});

  final _MyEventCardData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      shadowColor: const Color(0x19000000),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                EventsImgs.EventCardDetailBackground,
              ),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 104,
                  height: 104,
                  color: const Color(0xFFF2F2F2),
                  child: Image(
                    image: data.imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StatusBadge(
                        label: data.statusLabel,
                        color: data.accentColor,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        data.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          color: Color(0xFF111111),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        icon: Icons.calendar_month_rounded,
                        text: data.date,
                      ),
                      const SizedBox(height: 8),
                      _InfoRow(
                        icon: Icons.schedule_rounded,
                        text: data.time,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
          color: color,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: const Color(0xFF666666)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 42, color: const Color(0xFF5818B8)),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyEventCardData {
  const _MyEventCardData({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.statusLabel,
    required this.imageProvider,
    required this.accentColor,
  });

  final String id;
  final String title;
  final String date;
  final String time;
  final String statusLabel;
  final ImageProvider imageProvider;
  final Color accentColor;
}
