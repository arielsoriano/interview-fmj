import 'dart:async';

import 'package:city_events_explorer/src/core/utils/app_colors.dart';
import 'package:city_events_explorer/src/core/utils/app_spacing.dart';
import 'package:city_events_explorer/src/features/events/presentation/bloc/events_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventSearchBar extends StatefulWidget {
  const EventSearchBar({super.key});

  @override
  State<EventSearchBar> createState() => _EventSearchBarState();
}

class _EventSearchBarState extends State<EventSearchBar>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;
  late AnimationController _animationController;
  late Animation<double> _elevationAnimation;

  static const Duration _debounceDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
    _focusNode.addListener(_handleFocusChange);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _elevationAnimation = Tween<double>(begin: 2, end: 6).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      unawaited(_animationController.forward());
    } else {
      unawaited(_animationController.reverse());
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      context.read<EventsBloc>().add(const EventsEvent.clearFilters());
      return;
    }

    _debounceTimer = Timer(_debounceDuration, () {
      context.read<EventsBloc>().add(EventsEvent.searchEvents(query));
    });
  }

  void _clearSearch() {
    _controller.clear();
    context.read<EventsBloc>().add(const EventsEvent.clearFilters());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _elevationAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: _elevationAnimation.value * 2,
                offset: Offset(0, _elevationAnimation.value / 2),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: _onSearchChanged,
            onTapOutside: (event) => _focusNode.unfocus(),
            decoration: InputDecoration(
              hintText: 'Search events...',
              hintStyle: const TextStyle(
                color: AppColors.textTertiary,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: _focusNode.hasFocus
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: _clearSearch,
                      splashRadius: 20,
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
          ),
        );
      },
    );
  }
}
