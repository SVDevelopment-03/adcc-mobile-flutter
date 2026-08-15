import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
// local RewardItemCard implementation is below

class AvailableRewardsSection extends StatefulWidget {
  const AvailableRewardsSection({super.key});

  @override
  State<AvailableRewardsSection> createState() =>
      _AvailableRewardsSectionState();
}

class _AvailableRewardsSectionState extends State<AvailableRewardsSection> {
  bool _loading = true;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadRewards();
  }

  Future<void> _loadRewards() async {
    try {
      final resp =
          await ApiClient.instance.get<dynamic>(ApiEndpoints.storeItems);
      final list = ResponseParser.extractList(resp.data, const ['data']) ??
          ResponseParser.extractList(resp.data, const []) ??
          <dynamic>[];

      final items = list
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      if (mounted)
        setState(() {
          _items = items;
          _loading = false;
        });
    } catch (_) {
      if (mounted)
        setState(() {
          _loading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            AppLocalizations.of(context)!.available_rewards,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_loading)
          const Center(child: CircularProgressIndicator())
        else
          ..._items.map((it) {
            final image =
                it['imageUrl'] ?? it['image'] ?? 'assets/images/energy_bar.png';
            final title = it['title'] ?? it['name'] ?? AppLocalizations.of(context)!.reward;
            final points = (it['points'] ?? it['cost'] ?? 0).toString();
            return Column(
              children: [
                RewardItemCard(
                  title: title,
                  subtitle: AppLocalizations.of(context)!.usePoints(points),
                  points: points,
                ),
                const SizedBox(height: 12),
              ],
            );
          }).toList(),
        if (!_loading && _items.isEmpty)
          Text(AppLocalizations.of(context)!.noRewardsAvailable),
      ],
    );
  }
}

class RewardItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String points;

  const RewardItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, right: 2, bottom: 12),
      child: Container(
        width: double.infinity,
        height: 102,
        decoration: BoxDecoration(
          color: const Color(0xFFBCB0FF),
          borderRadius: BorderRadius.circular(9.9496),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                width: 30,
                height: 30,
                padding: const EdgeInsets.only(
                  top: 10,
                  right: 11.4545,
                  bottom: 9.4595,
                  left: 10.9091,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFBCB0FF),
                  borderRadius: BorderRadius.circular(53.8462),
                ),
                child: Image.asset(
                  "assets/icons/medal.png",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1,
                          letterSpacing: 0,
                          color: AppColors.charcoal),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        height: 1,
                        letterSpacing: 0,
                        color: AppColors.charcoal,
                      ),
                    ),

                    const SizedBox(height: 7),

                    /// POINT BADGE
                    Container(
                      width: 59,
                      height: 22,
                      padding: const EdgeInsets.only(
                        top: 3,
                        right: 8,
                        bottom: 4,
                        left: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        points,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 36),
              child: Container(
                  width: 94,
                  height: 30,
                  padding: const EdgeInsets.only(
                    top: 6,
                    right: 10,
                    bottom: 6,
                    left: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC12D32),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFFC12D32),
                      width: 1.2365,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context)!.claim_now,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      color: Color(0xFF5257B5),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1,
                      letterSpacing: 0,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
