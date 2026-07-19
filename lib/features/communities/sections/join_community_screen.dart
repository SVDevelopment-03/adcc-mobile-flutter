import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/communities/sections/my_community_screen.dart';
import 'package:adcc/features/communities/view/explore_community_screen.dart';
import 'package:adcc/features/events/sections/upcoming_event_screen.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:adcc/shared/widgets/app_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class JoinCommunity extends StatefulWidget {
  final CommunityModel community;

  const JoinCommunity({
    super.key,
    required this.community,
  });

  @override
  State<JoinCommunity> createState() => _JoinCommunityState();
}

class _JoinCommunityState extends State<JoinCommunity> {
  late CommunityModel _community;

  @override
  void initState() {
    super.initState();
    _community = widget.community;
  }

  @override
  Widget build(BuildContext context) {
    final title = _community.title.trim().isEmpty
        ? "Abu Dhabi Road Racers"
        : _community.title.trim();

    final members = _community.membersCount ?? 2800;
    final location = (_community.location ?? "Abu Dhabi").trim();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
      backgroundColor: Color(0xffFFF3F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context, true),
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 171, 220),
                        borderRadius: BorderRadius.circular(53.8462),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 15,
                        color: Color(0xFFFF78A1),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 28),
                      Center(
                        child: Image.asset(
                          "assets/icons/checkmark.gif",
                          height: 196,
                          width: 196,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 0),
                      const Text(
                        "Welcome to the Community!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Outfit",
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                          letterSpacing: 0,
                          color: AppColors.charcoal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "You have successfully joined $title",
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: "Outfit",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.25,
                          letterSpacing: 0,
                          color: AppColors.charcoal,
                        ),
                      ),
                      const SizedBox(height: 17),
                      _JoinedCommunityCard(
                        title: title,
                        members: members,
                        location: location,
                        imageUrl: _community.imageUrl,
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        "What's Next?",
                        style: TextStyle(
                          fontFamily: "Outfit",
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                          letterSpacing: 0,
                          color: AppColors.charcoal,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _NextOptionTile(
                        iconPath: "assets/images/notification_enable.png",
                        title: "Notifications Enabled",
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Notifications feature coming soon"),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _NextOptionTile(
                        iconPath: "assets/images/whatsup.png",
                        title: "Join Community Chats",
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Chat feature coming soon"),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _NextOptionTile(
                        iconPath: "assets/icons/add_calendar.png",
                        title: "Upcoming Events",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Upcomingevent(events: []),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 22),
                    ],
                  ),
                ),
              ),
              AppButton(
                label: "Start Exploring",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Mycommunity(
                        myCommunities: [_community],
                      ),
                    ),
                  );
                },
                type: AppButtonType.primary,
                backgroundColor: const Color(0xFFFF78A1),
                textColor: Colors.white,
                borderRadius: 12,
                height: 51,
                textStyle: const TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    ),);
  }
}

class _JoinedCommunityCard extends StatelessWidget {
  final String title;
  final int members;
  final String location;
  final String? imageUrl;

  const _JoinedCommunityCard({
    required this.title,
    required this.members,
    required this.location,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 408,
       decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      image: const DecorationImage(
        image: CachedNetworkImageProvider(
          CommunitiesImgs.communitywelcomeinfobackground,
        ),
        fit: BoxFit.cover,
      ),
    ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 14),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: AdaptiveImage(
                imagePath: imageUrl ?? "assets/images/no-img.jpg",
                width: double.infinity,
                height: 241,
                fit: BoxFit.cover,
                placeholderColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                  letterSpacing: 0,
                  color: AppColors.charcoal,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "The main cycling community in $location, bringing together...",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                  letterSpacing: 0,
                  color: AppColors.charcoal.withValues(alpha: 0.6),
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: _MiniInfoBox(
                    iconPath: "assets/icons/red_people.png",
                    title: "Members",
                    value: _formatCount(members),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MiniInfoBox(
                    iconPath: "assets/icons/location.png",
                    title: "Location",
                    value: location,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

String _formatCount(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final position = text.length - i;
    buffer.write(text[i]);
    if (position > 1 && position % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}

class _MiniInfoBox extends StatelessWidget {
  final String iconPath;
  final String title;
  final String value;

  const _MiniInfoBox({
    required this.iconPath,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 61,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF6FB),
        borderRadius: BorderRadius.circular(13.2955),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            height: 16,
            width: 13,
            color: const Color(0xFFFF78A0),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: "Outfit",
                    fontSize: 10.89,
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                    letterSpacing: 0,
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: "Outfit",
                    fontSize: 12.7,
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                    letterSpacing: 0,
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

class _NextOptionTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  const _NextOptionTile({
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  bool get isSvg => iconPath.endsWith(".svg");
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color:Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFFF78A0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: isSvg
                    ? SvgPicture.asset(
                        iconPath,
                        height: 27,
                        width: 27,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      )
                    : Image.asset(
                        iconPath,
                        height: 27,
                        width: 27,
                        color: Colors.white,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                  color: Color(0XFF101828),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 24,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
