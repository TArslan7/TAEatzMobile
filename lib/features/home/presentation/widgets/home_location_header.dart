import 'package:flutter/material.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../location/domain/entities/location_entity.dart';

class HomeLocationHeader extends StatelessWidget {
  final ThemeManager themeManager;
  final LocationEntity? selectedLocation;
  final VoidCallback onTap;
  final bool isDeliveryMode;
  final ValueChanged<bool> onModeChanged;

  const HomeLocationHeader({
    super.key,
    required this.themeManager,
    required this.selectedLocation,
    required this.onTap,
    required this.isDeliveryMode,
    required this.onModeChanged,
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
          child: Row(
            children: [
              // Location Icon
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
              
              // Location Text
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isDeliveryMode ? 'Delivery to' : 'Collect from',
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
              ),
              
              const SizedBox(width: 8),
              
              // Delivery/Takeaway Switch
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isDeliveryMode ? Icons.delivery_dining : Icons.shopping_bag,
                      size: 16,
                      color: themeManager.textColor,
                    ),
                    const SizedBox(width: 4),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: isDeliveryMode,
                        onChanged: onModeChanged,
                        activeColor: themeManager.primaryRed,
                        activeTrackColor: themeManager.primaryRed.withOpacity(0.5),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.white.withOpacity(0.3),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

