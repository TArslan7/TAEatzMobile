import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class PreferencesPage extends StatefulWidget {
  final UserEntity user;

  const PreferencesPage({
    super.key,
    required this.user,
  });

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  final List<String> _dietaryOptions = [
    'Vegetarian',
    'Vegan',
    'Gluten-Free',
    'Dairy-Free',
    'Nut-Free',
    'Keto',
    'Paleo',
    'Halal',
    'Kosher',
  ];

  final List<String> _allergyOptions = [
    'Nuts',
    'Dairy',
    'Eggs',
    'Soy',
    'Wheat',
    'Fish',
    'Shellfish',
    'Sesame',
  ];

  late List<String> _selectedDietaryPreferences;
  late List<String> _selectedAllergies;

  @override
  void initState() {
    super.initState();
    _selectedDietaryPreferences = List.from(widget.user.dietaryPreferences);
    _selectedAllergies = List.from(widget.user.allergies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _savePreferences,
            child: const Text('Save'),
          ),
        ],
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is PreferencesUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Preferences updated successfully')),
            );
            Navigator.of(context).pop();
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                title: 'Dietary Preferences',
                subtitle: 'Select your dietary preferences',
                options: _dietaryOptions,
                selectedOptions: _selectedDietaryPreferences,
                onSelectionChanged: (selected) {
                  setState(() {
                    _selectedDietaryPreferences = selected;
                  });
                },
              ),
              const SizedBox(height: AppTheme.spacingXL),
              _buildSection(
                title: 'Allergies',
                subtitle: 'Select any allergies you have',
                options: _allergyOptions,
                selectedOptions: _selectedAllergies,
                onSelectionChanged: (selected) {
                  setState(() {
                    _selectedAllergies = selected;
                  });
                },
              ),
              const SizedBox(height: AppTheme.spacingXL),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _savePreferences,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    ),
                  ),
                  child: Text(
                    'Save Preferences',
                    style: AppTheme.button.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required List<String> options,
    required List<String> selectedOptions,
    required Function(List<String>) onSelectionChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.heading6,
        ),
        const SizedBox(height: AppTheme.spacingS),
        Text(
          subtitle,
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        Wrap(
          spacing: AppTheme.spacingS,
          runSpacing: AppTheme.spacingS,
          children: options.map((option) {
            final isSelected = selectedOptions.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                final newSelection = List<String>.from(selectedOptions);
                if (selected) {
                  newSelection.add(option);
                } else {
                  newSelection.remove(option);
                }
                onSelectionChanged(newSelection);
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimaryColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _savePreferences() {
    context.read<ProfileBloc>().add(
      UpdatePreferences(
        dietaryPreferences: _selectedDietaryPreferences,
        allergies: _selectedAllergies,
      ),
    );
  }
}
