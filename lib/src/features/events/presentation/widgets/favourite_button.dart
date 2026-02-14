import 'package:city_events_explorer/src/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class FavouriteButton extends StatelessWidget {
  const FavouriteButton({
    required this.isFavourite,
    required this.onPressed,
    super.key,
  });

  final bool isFavourite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavourite ? Icons.favorite : Icons.favorite_border,
        color: isFavourite
            ? AppColors.favourite
            : AppColors.favouriteInactive,
      ),
      onPressed: onPressed,
      tooltip: isFavourite ? 'Remove from favourites' : 'Add to favourites',
    );
  }
}
