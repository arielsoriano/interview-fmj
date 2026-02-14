import 'package:city_events_explorer/src/core/routing/app_router.dart';
import 'package:city_events_explorer/src/core/utils/app_colors.dart';
import 'package:city_events_explorer/src/core/utils/app_spacing.dart';
import 'package:city_events_explorer/src/features/events/domain/entities/event.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    required this.event,
    super.key,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPaddingHorizontal,
        vertical: AppSpacing.xs,
      ),
      elevation: AppSpacing.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.eventDetailPath(event.id)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        Hero(
          tag: 'event-image-${event.id}',
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              event.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const ColoredBox(
                  color: AppColors.surfaceVariant,
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 48,
                      color: AppColors.textTertiary,
                    ),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return ColoredBox(
                  color: AppColors.surfaceVariant,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          top: AppSpacing.xs,
          right: AppSpacing.xs,
          child: _buildFavouriteButton(),
        ),
        Positioned(
          bottom: AppSpacing.xs,
          left: AppSpacing.xs,
          child: _buildCategoryChip(),
        ),
      ],
    );
  }

  Widget _buildFavouriteButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(
          Icons.favorite_border,
          color: AppColors.favouriteInactive,
        ),
        onPressed: () {},
        tooltip: 'Add to favourites',
      ),
    );
  }

  Widget _buildCategoryChip() {
    final categoryColor = AppColors.getCategoryColor(event.category);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: categoryColor,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Text(
        event.category,
        style: const TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            text: _formatDate(event.startDate),
          ),
          const SizedBox(height: AppSpacing.xxs),
          _buildInfoRow(
            icon: Icons.access_time_outlined,
            text: _formatTime(event.startDate, event.endDate),
          ),
          const SizedBox(height: AppSpacing.xxs),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            text: event.location.name,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppSpacing.iconSizeSmall,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.xxs),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEE, MMM d, yyyy').format(date);
  }

  String _formatTime(DateTime start, DateTime end) {
    final startTime = DateFormat('h:mm a').format(start);
    final endTime = DateFormat('h:mm a').format(end);
    return '$startTime - $endTime';
  }
}
