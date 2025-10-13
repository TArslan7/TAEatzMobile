import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../domain/entities/location_entity.dart';

class LocationSelectionPage extends StatefulWidget {
  final LocationEntity? currentLocation;

  const LocationSelectionPage({
    super.key,
    this.currentLocation,
  });

  @override
  State<LocationSelectionPage> createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  final TextEditingController _searchController = TextEditingController();
  List<LocationEntity> _recentSearches = [];
  List<LocationEntity> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadRecentSearches() {
    // TODO: Load from local storage
    setState(() {
      _recentSearches = [
        LocationEntity(
          id: '1',
          address: '123 Main Street, Amsterdam',
          streetNumber: '123',
          streetName: 'Main Street',
          city: 'Amsterdam',
          postalCode: '1012 AB',
          country: 'Netherlands',
          latitude: 52.3676,
          longitude: 4.9041,
          lastUsed: DateTime.now().subtract(const Duration(days: 1)),
        ),
        LocationEntity(
          id: '2',
          address: '456 Canal Street, Rotterdam',
          streetNumber: '456',
          streetName: 'Canal Street',
          city: 'Rotterdam',
          postalCode: '3011 AB',
          country: 'Netherlands',
          latitude: 51.9244,
          longitude: 4.4777,
          lastUsed: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];
    });
  }

  void _useCurrentLocation() async {
    // TODO: Implement location permission and fetching
    final location = LocationEntity(
      id: 'current',
      address: 'Current Location',
      city: 'Amsterdam',
      country: 'Netherlands',
      latitude: 52.3676,
      longitude: 4.9041,
      isCurrent: true,
    );
    
    Navigator.of(context).pop(location);
  }

  void _searchAddress(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // TODO: Implement actual address search API
    // Simulating search results
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _searchResults = [
            LocationEntity(
              id: '3',
              address: '$query, Amsterdam',
              streetName: query,
              city: 'Amsterdam',
              postalCode: '1012 AB',
              country: 'Netherlands',
              latitude: 52.3676,
              longitude: 4.9041,
            ),
            LocationEntity(
              id: '4',
              address: '$query, Rotterdam',
              streetName: query,
              city: 'Rotterdam',
              postalCode: '3011 AB',
              country: 'Netherlands',
              latitude: 51.9244,
              longitude: 4.4777,
            ),
          ];
          _isSearching = false;
        });
      }
    });
  }

  void _selectLocation(LocationEntity location) {
    // Add to recent searches
    _addToRecentSearches(location);
    Navigator.of(context).pop(location);
  }

  void _addToRecentSearches(LocationEntity location) {
    // TODO: Save to local storage
    setState(() {
      _recentSearches.removeWhere((l) => l.id == location.id);
      _recentSearches.insert(0, location.copyWith(lastUsed: DateTime.now()));
      if (_recentSearches.length > 5) {
        _recentSearches = _recentSearches.sublist(0, 5);
      }
    });
  }

  void _deleteRecentSearch(String id) {
    setState(() {
      _recentSearches.removeWhere((l) => l.id == id);
    });
    // TODO: Update local storage
  }

  void _showManualEntryDialog(ThemeManager themeManager) {
    final streetController = TextEditingController();
    final cityController = TextEditingController();
    final postalCodeController = TextEditingController();
    final countryController = TextEditingController(text: 'Netherlands');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeManager.cardColor,
        title: Text(
          'Add Address Manually',
          style: TextStyle(color: themeManager.textColor),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: streetController,
                style: TextStyle(color: themeManager.textColor),
                decoration: InputDecoration(
                  labelText: 'Street Address',
                  labelStyle: TextStyle(color: themeManager.textColor.withOpacity(0.7)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: themeManager.textColor.withOpacity(0.3)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: themeManager.primaryRed),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              TextField(
                controller: cityController,
                style: TextStyle(color: themeManager.textColor),
                decoration: InputDecoration(
                  labelText: 'City',
                  labelStyle: TextStyle(color: themeManager.textColor.withOpacity(0.7)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: themeManager.textColor.withOpacity(0.3)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: themeManager.primaryRed),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              TextField(
                controller: postalCodeController,
                style: TextStyle(color: themeManager.textColor),
                decoration: InputDecoration(
                  labelText: 'Postal Code',
                  labelStyle: TextStyle(color: themeManager.textColor.withOpacity(0.7)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: themeManager.textColor.withOpacity(0.3)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: themeManager.primaryRed),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              TextField(
                controller: countryController,
                style: TextStyle(color: themeManager.textColor),
                decoration: InputDecoration(
                  labelText: 'Country',
                  labelStyle: TextStyle(color: themeManager.textColor.withOpacity(0.7)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: themeManager.textColor.withOpacity(0.3)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: themeManager.primaryRed),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: themeManager.textColor.withOpacity(0.7)),
            ),
          ),
          TextButton(
            onPressed: () {
              if (streetController.text.isNotEmpty && cityController.text.isNotEmpty) {
                final location = LocationEntity(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  address: '${streetController.text}, ${cityController.text}',
                  streetName: streetController.text,
                  city: cityController.text,
                  postalCode: postalCodeController.text.isNotEmpty ? postalCodeController.text : null,
                  country: countryController.text.isNotEmpty ? countryController.text : null,
                );
                Navigator.of(context).pop();
                _selectLocation(location);
              }
            },
            child: Text(
              'Add',
              style: TextStyle(color: themeManager.primaryRed),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return Scaffold(
          backgroundColor: themeManager.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Enter Your Location',
              style: TextStyle(color: themeManager.textColor),
            ),
            backgroundColor: themeManager.cardColor,
            elevation: 0,
            iconTheme: IconThemeData(color: themeManager.textColor),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Column(
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                color: themeManager.cardColor,
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: themeManager.textColor),
                  decoration: InputDecoration(
                    hintText: 'Search for your address',
                    hintStyle: TextStyle(color: themeManager.textColor.withOpacity(0.5)),
                    prefixIcon: Icon(
                      Icons.search,
                      color: themeManager.textColor.withOpacity(0.7),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: themeManager.textColor.withOpacity(0.7),
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _searchAddress('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: themeManager.backgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: _searchAddress,
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Use Current Location Button
                      InkWell(
                        onTap: _useCurrentLocation,
                        child: Container(
                          padding: const EdgeInsets.all(AppTheme.spacingM),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: themeManager.textColor.withOpacity(0.1),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: themeManager.primaryRed.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.my_location,
                                  color: themeManager.primaryRed,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: AppTheme.spacingM),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Use Current Location',
                                      style: AppTheme.bodyLarge.copyWith(
                                        color: themeManager.primaryRed,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Enable location services',
                                      style: AppTheme.caption.copyWith(
                                        color: themeManager.textColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: themeManager.textColor.withOpacity(0.4),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Add Manually Button
                      InkWell(
                        onTap: () => _showManualEntryDialog(themeManager),
                        child: Container(
                          padding: const EdgeInsets.all(AppTheme.spacingM),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: themeManager.textColor.withOpacity(0.1),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: themeManager.textColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.edit_location_alt,
                                  color: themeManager.textColor.withOpacity(0.7),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: AppTheme.spacingM),
                              Expanded(
                                child: Text(
                                  'Add Address Manually',
                                  style: AppTheme.bodyLarge.copyWith(
                                    color: themeManager.textColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: themeManager.textColor.withOpacity(0.4),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacingL),

                      // Search Results
                      if (_isSearching)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppTheme.spacingL),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_searchResults.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
                          child: Text(
                            'Search Results',
                            style: AppTheme.bodyMedium.copyWith(
                              color: themeManager.textColor.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingS),
                        ..._searchResults.map((location) => _buildLocationItem(
                              location,
                              themeManager,
                              onTap: () => _selectLocation(location),
                            )),
                      ]
                      // Recent Searches
                      else if (_recentSearches.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Searches',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: themeManager.textColor.withOpacity(0.7),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingS),
                        ..._recentSearches.map((location) => _buildLocationItem(
                              location,
                              themeManager,
                              onTap: () => _selectLocation(location),
                              showDelete: true,
                              onDelete: () => _deleteRecentSearch(location.id),
                            )),
                      ]
                      // Empty State
                      else if (_searchController.text.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppTheme.spacingXL),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.location_searching,
                                  size: 64,
                                  color: themeManager.textColor.withOpacity(0.3),
                                ),
                                const SizedBox(height: AppTheme.spacingM),
                                Text(
                                  'No recent searches',
                                  style: AppTheme.bodyLarge.copyWith(
                                    color: themeManager.textColor.withOpacity(0.5),
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spacingS),
                                Text(
                                  'Search for your address or use current location',
                                  style: AppTheme.caption.copyWith(
                                    color: themeManager.textColor.withOpacity(0.4),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      // No Results
                      else
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppTheme.spacingXL),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: themeManager.textColor.withOpacity(0.3),
                                ),
                                const SizedBox(height: AppTheme.spacingM),
                                Text(
                                  'No results found',
                                  style: AppTheme.bodyLarge.copyWith(
                                    color: themeManager.textColor.withOpacity(0.5),
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spacingS),
                                Text(
                                  'Try adding your address manually',
                                  style: AppTheme.caption.copyWith(
                                    color: themeManager.textColor.withOpacity(0.4),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppTheme.spacingL),
                                ElevatedButton.icon(
                                  onPressed: () => _showManualEntryDialog(themeManager),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: themeManager.primaryRed,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppTheme.spacingL,
                                      vertical: AppTheme.spacingM,
                                    ),
                                  ),
                                  icon: const Icon(Icons.add_location_alt, color: Colors.white),
                                  label: const Text(
                                    'Add Manually',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationItem(
    LocationEntity location,
    ThemeManager themeManager, {
    required VoidCallback onTap,
    bool showDelete = false,
    VoidCallback? onDelete,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: themeManager.textColor.withOpacity(0.1),
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: themeManager.textColor.withOpacity(0.5),
              size: 20,
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.streetName ?? location.address,
                    style: AppTheme.bodyMedium.copyWith(
                      color: themeManager.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (location.city != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${location.city}${location.postalCode != null ? ', ${location.postalCode}' : ''}',
                      style: AppTheme.caption.copyWith(
                        color: themeManager.textColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showDelete && onDelete != null)
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: themeManager.textColor.withOpacity(0.5),
                  size: 20,
                ),
                onPressed: onDelete,
              )
            else
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: themeManager.textColor.withOpacity(0.4),
              ),
          ],
        ),
      ),
    );
  }
}

