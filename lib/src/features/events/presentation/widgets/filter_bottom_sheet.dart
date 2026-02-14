import 'dart:async';

import 'package:city_events_explorer/src/core/utils/app_colors.dart';
import 'package:city_events_explorer/src/core/utils/app_spacing.dart';
import 'package:city_events_explorer/src/features/events/presentation/bloc/events_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();

  static void show(BuildContext context) {
    FocusScope.of(context).unfocus();
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => BlocProvider.value(
          value: context.read<EventsBloc>(),
          child: const FilterBottomSheet(),
        ),
      ),
    );
  }
}

class _FilterBottomSheetState extends State<FilterBottomSheet>
    with SingleTickerProviderStateMixin {
  static const List<String> _categories = [
    'Music',
    'Technology',
    'Sports',
    'Food',
    'Art',
    'Health & Wellness',
  ];

  String? _selectedCategory;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    unawaited(_animationController.forward());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.md),
            ),
          ),
          padding: EdgeInsets.only(
            left: AppSpacing.screenPaddingHorizontal,
            right: AppSpacing.screenPaddingHorizontal,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                AppSpacing.screenPaddingVertical +
                AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: AppSpacing.lg),
              _buildCategoryChips(),
              const SizedBox(height: AppSpacing.lg),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Filter by Category',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
          color: AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: _categories.map((category) {
        final isSelected = _selectedCategory == category;
        final categoryColor = AppColors.getCategoryColor(category);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedCategory = isSelected ? null : category;
              });
            },
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            splashColor: categoryColor.withValues(alpha: 0.2),
            highlightColor: categoryColor.withValues(alpha: 0.1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? categoryColor.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(
                  color: isSelected ? categoryColor : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.xxs),
                      child: Icon(
                        Icons.check,
                        size: 16,
                        color: categoryColor,
                      ),
                    ),
                  Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? categoryColor : AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              context.read<EventsBloc>().add(const EventsEvent.clearFilters());
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
              ),
              side: const BorderSide(color: AppColors.primary, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.xs),
              ),
              splashFactory: InkRipple.splashFactory,
            ),
            child: const Text(
              'Clear',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: FilledButton(
            onPressed: _selectedCategory != null
                ? () {
                    context.read<EventsBloc>().add(
                          EventsEvent.filterByCategory(_selectedCategory!),
                        );
                    Navigator.of(context).pop();
                  }
                : null,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
              ),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
              disabledBackgroundColor: AppColors.border,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.xs),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Apply',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
