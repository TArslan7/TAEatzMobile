import 'package:flutter/material.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../location/domain/entities/location_entity.dart';

class HomeLocationHeader extends StatelessWidget {
  final ThemeManager themeManager;
  final LocationEntity? selectedLocation;
  final VoidCallback onTap;

  const HomeLocationHeader({
    super.key,
    required this.themeManager,
    required this.selectedLocation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            themeManager.primaryRed,
            themeManager.primaryRed.withOpacity(0.98),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.location_on,
                      size: 16,
                      color: themeManager.textColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Delivery to',
                          style: TextStyle(
                            color: themeManager.textColor.withOpacity(0.7),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                selectedLocation?.displayAddress ?? 'Select your location',
                                style: TextStyle(
                                  color: themeManager.textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 18,
                              color: themeManager.textColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

