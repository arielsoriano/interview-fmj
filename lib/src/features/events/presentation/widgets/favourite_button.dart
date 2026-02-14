import 'package:city_events_explorer/src/core/utils/app_colors.dart';
import 'package:city_events_explorer/src/features/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouriteButton extends StatefulWidget {
  const FavouriteButton({
    required this.eventId,
    super.key,
  });

  final String eventId;

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleToggle() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    context.read<FavouritesCubit>().toggleFavourite(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouritesCubit, FavouritesState>(
      builder: (context, state) {
        final isFavourite = state.favouriteIds.contains(widget.eventId);
        
        return ScaleTransition(
          scale: _scaleAnimation,
          child: IconButton(
            icon: Icon(
              isFavourite ? Icons.favorite : Icons.favorite_border,
              color: isFavourite
                  ? AppColors.favourite
                  : AppColors.favouriteInactive,
            ),
            onPressed: _handleToggle,
            tooltip: isFavourite
                ? 'Remove from favourites'
                : 'Add to favourites',
          ),
        );
      },
    );
  }
}
