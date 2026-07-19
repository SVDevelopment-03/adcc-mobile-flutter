import 'package:flutter/material.dart';

class ServiceIntegration {
  final String name;
  final VoidCallback? onConnect;

  const ServiceIntegration({
    required this.name,
    this.onConnect,
  });
}

class RouteDetailsIntegrationSection extends StatelessWidget {
  final List<ServiceIntegration> services;

  const RouteDetailsIntegrationSection({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Route Details',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 25 / 20,
            color: Color(0xFF1A1C20),
          ),
        ),
        const SizedBox(height: 15),
        Column(
          children: services.asMap().entries.map((entry) {
            final index = entry.key;
            final service = entry.value;
            final isLast = index == services.length - 1;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
              child: Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F6FC),
                  borderRadius: BorderRadius.circular(17.5168),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E3176).withValues(alpha: 0.10),
                      offset: const Offset(0, 4.38),
                      blurRadius: 30.65,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        service.name,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 13.1376,
                          fontWeight: FontWeight.w600,
                          height: 17 / 13.1376,
                          letterSpacing: 0.13,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: service.onConnect,
                      child: Container(
                        width: 93,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0359E8),
                          borderRadius: BorderRadius.circular(9.11628),
                        ),
                        child: const Text(
                          'Coming Soon',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 16 / 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
