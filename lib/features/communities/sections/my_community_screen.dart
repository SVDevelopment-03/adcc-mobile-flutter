import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/communities/sections/community_list_card.dart';
import 'package:adcc/features/communities/view/community_type_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Mycommunity extends StatelessWidget {
  final List<CommunityModel> myCommunities;

  const Mycommunity({
    super.key,
    required this.myCommunities,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              CommunitiesImgs.AllcommunityBackground,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
            child: Column(
              children: [
                /// TOP BAR
                Row(
                  children: [
                    /// TOP BACK BUTTON
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context, true),
                        child: Container(
                          height: 35,
                          width: 35,
                          padding:
                              const EdgeInsets.fromLTRB(10, 10, 7.54, 9.46),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                                153, 235, 152, 210), // #C12D325C
                            borderRadius: BorderRadius.circular(53.8462),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            size: 15,
                            color: Color(0XFFF96291),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),
                    const Text(
                      "My Communities",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Outfit",
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        height: 1, // 100% line height
                        letterSpacing: 0,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 38),
                  ],
                ),

                const SizedBox(height: 46),

                /// LIST (SAME CommunityListCard)
                Expanded(
                  child: myCommunities.isEmpty
                      ? const Center(
                          child: Text(
                            "No communities found",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: myCommunities.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final community = myCommunities[index];

                            return CommunityListCard(
                              community: community,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CommunityCityDetails(
                                      community: community,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
