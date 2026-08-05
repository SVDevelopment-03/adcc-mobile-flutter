import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:adcc/features/events/services/events_service.dart';
import 'package:adcc/features/events/view/my_event_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  final Event event;
  final String? bloodGroup;
  final String? country;
  final String? bikeType;
  final String? haveBike;
  final String? emergencyName;
  final String? emergencyPhone;
  final String redArcImagePath;

  const RegistrationSuccessScreen({
    super.key,
    required this.event,
    this.bloodGroup,
    this.country,
    this.bikeType,
    this.haveBike,
    this.emergencyName,
    this.emergencyPhone,
    this.redArcImagePath = 'assets/images/frame_1.png',
  });

  Future<void> _openCalendar(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await EventsService().addEventToCalendar(event: event);
    final calendarUrl = result.data;

    if (calendarUrl == null || calendarUrl.isEmpty) {
      messenger.showSnackBar(
        SnackBar(
            content: Text(result.message ?? 'Unable to build calendar link.')),
      );
      return;
    }

    final uri = Uri.parse(calendarUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      messenger.showSnackBar(
        const SnackBar(content: Text('Calendar link opened successfully.')),
      );
      return;
    }

    messenger.showSnackBar(
      const SnackBar(content: Text('Unable to open calendar link.')),
    );
  }

  Future<void> _shareRegistration(BuildContext context) async {
    final summary = [
      'I just registered for ${event.title}.',
      if (event.formattedDate != null) 'Date: ${event.formattedDate}',
      if (event.eventTime != null) 'Time: ${event.eventTime}',
      if (event.address != null) 'Location: ${event.address}',
    ].join('\n');

    await Clipboard.setData(ClipboardData(text: summary));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Registration details copied to clipboard.')),
    );
  }

  void _openMyEvents(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MYEVENET()),
    );
  }

  String? _formatInfo(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? null : text;
  }

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

  @override
  Widget build(BuildContext context) {
    final selectedSummary = <_SelectedInfo>[
      if (_formatInfo(bloodGroup) != null)
        _SelectedInfo(label: 'Blood Group', value: bloodGroup!),
      if (_formatInfo(country) != null)
        _SelectedInfo(label: 'Country', value: country!),
      if (_formatInfo(haveBike) != null)
        _SelectedInfo(label: 'Own Bike', value: haveBike!),
      if (_formatInfo(bikeType) != null)
        _SelectedInfo(label: 'Bike Type', value: bikeType!),
      if (_formatInfo(emergencyName) != null)
        _SelectedInfo(label: 'Emergency Contact', value: emergencyName!),
      if (_formatInfo(emergencyPhone) != null)
        _SelectedInfo(label: 'Emergency Phone', value: emergencyPhone!),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(EventsImgs.eventBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: -52,
                    top: 240,
                    child: Image.asset(
                      redArcImagePath,
                      width: 160,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          _BackCircleButton(
                            onTap: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Center(
                        child: ClipOval(
                          child: Image.asset(
                            'assets/icons/checkmark.gif',
                            height: 102,
                            width: 102,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: Text(
                          'You\'re registered!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: AppColors.charcoal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          'Get ready for an amazing ride with\nthe community!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.35,
                            fontWeight: FontWeight.w400,
                            color: AppColors.charcoal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _EventSummaryCard(
                          event: event,
                          imageProvider: _resolveImage(event.mainImage)),
                      if (selectedSummary.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _RegistrationInfoCard(items: selectedSummary),
                      ],
                      const SizedBox(height: 26),
                      _ActionTile(
                        imagePath: 'assets/icons/add_calendar.png',
                        title: 'Add to Calendar',
                        onTap: () => _openCalendar(context),
                      ),
                      const SizedBox(height: 12),
                      _ActionTile(
                        imagePath: 'assets/icons/share_2.png',
                        title: 'Share with Friends',
                        onTap: () => _shareRegistration(context),
                      ),
                      const SizedBox(height: 12),
                      _ActionTile(
                        imagePath: 'assets/icons/add_calendar.png',
                        title: 'View My Events',
                        onTap: () => _openMyEvents(context),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        height: 52,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0XFF1B1A6E),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Return to Home',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 61),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedInfo {
  final String label;
  final String value;

  const _SelectedInfo({required this.label, required this.value});
}

class _BackCircleButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackCircleButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromRGBO(82, 98, 239, 0.36),
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
            color: const Color(0XFFF1B1A6E),
          ),
        ),
      ),
    );
  }
}

class _EventSummaryCard extends StatelessWidget {
  final Event event;
  final ImageProvider imageProvider;

  const _EventSummaryCard({
    required this.event,
    required this.imageProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        image: const DecorationImage(
          
          image: CachedNetworkImageProvider(
              EventsImgs.EventRegistedCardBackground),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        height: 1.15,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      event.address?.trim().isNotEmpty == true
                          ? event.address!
                          : (event.city?.trim().isNotEmpty == true
                              ? event.city!
                              : 'Event location'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.2,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffbbc2fa),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MiniInfoCard(
                  imagePath: 'assets/icons/clock.png',
                  title: 'When',
                  value: event.formattedDate ?? 'TBD',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniInfoCard(
                  imagePath: 'assets/icons/distance.png',
                  title: 'Location',
                  value: event.city?.trim().isNotEmpty == true
                      ? event.city!
                      : 'Abu Dhabi',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MiniInfoCard(
                  imagePath: 'assets/icons/red_star.png',
                  title: 'Type',
                  value: event.derivedCategory ?? event.category ?? 'Event',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniInfoCard(
                  imagePath: 'assets/icons/red_people.png',
                  title: 'Community',
                  value: event.createdBy?['name']?.toString() ??
                      event.createdBy?['groupName']?.toString() ??
                      'null',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RegistrationInfoCard extends StatelessWidget {
  final List<_SelectedInfo> items;

  const _RegistrationInfoCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBeige),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Registration',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF101828),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items
                .map(
                  (item) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5EDFF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${item.label}: ${item.value}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF101828),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _MiniInfoCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String value;

  const _MiniInfoCard({
    required this.imagePath,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.lightBeige,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            height: 18,
            width: 18,
            color: AppColors.deepRed,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w400,
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.1,
                    fontWeight: FontWeight.w500,
                    color: AppColors.charcoal,
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

class _ActionTile extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;
  final Color iconColor;

  const _ActionTile({
    required this.imagePath,
    required this.title,
    required this.onTap,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 255, 255, 255),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 80,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 13, 16, 13),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0XFF1B1A6E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Image.asset(
                    imagePath,
                    width: 27,
                    height: 27,
                    color: iconColor,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0XFF101828),
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
