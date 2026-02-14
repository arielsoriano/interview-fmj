import 'package:city_events_explorer/src/core/routing/app_router.dart';
import 'package:city_events_explorer/src/core/utils/app_colors.dart';
import 'package:city_events_explorer/src/core/utils/app_spacing.dart';
import 'package:city_events_explorer/src/features/events/domain/entities/event.dart';
import 'package:city_events_explorer/src/features/events/presentation/widgets/favourite_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EventCard extends StatefulWidget {
  const EventCard({
    required this.event,
    super.key,
  });

  final Event event;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.98).animate(
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

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
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
          onTap: () => context.push(
            AppRoutes.eventDetailPath(widget.event.id),
            extra: widget.event,
          ),
          onTapDown: (_) => _animationController.forward(),
          onTapUp: (_) => _animationController.reverse(),
          onTapCancel: () => _animationController.reverse(),
          splashColor: AppColors.primary.withValues(alpha: 0.1),
          highlightColor: AppColors.primary.withValues(alpha: 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(),
              _buildContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        Hero(
          tag: 'event-image-${widget.event.id}',
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              widget.event.imageUrl,
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
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FavouriteButton(eventId: widget.event.id),
    );
  }

  Widget _buildCategoryChip() {
    final categoryColor = AppColors.getCategoryColor(widget.event.category);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: categoryColor,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        widget.event.category,
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
            widget.event.title,
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
            text: _formatDate(widget.event.startDate),
          ),
          const SizedBox(height: AppSpacing.xxs),
          _buildInfoRow(
            icon: Icons.access_time_outlined,
            text: _formatTime(widget.event.startDate, widget.event.endDate),
          ),
          const SizedBox(height: AppSpacing.xxs),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            text: widget.event.location.name,
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
