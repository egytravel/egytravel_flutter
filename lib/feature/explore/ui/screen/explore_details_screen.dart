import 'package:egytravel_app/core/widgets/glassy_background.dart';
import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';
import 'package:egytravel_app/feature/explore/logic/controller/explore_detail_controller.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/details/explore_details_action_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:egytravel_app/core/widgets/custom_back_button.dart';
import 'package:egytravel_app/core/widgets/glass_action_button.dart';
import 'package:egytravel_app/core/theme/app_color.dart';
import 'dart:io';

class ExploreDetailsScreen extends StatelessWidget {
  const ExploreDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamic args = Get.arguments;
    final ExploreItemModel item = args is Map
        ? args['item']
        : args as ExploreItemModel;
    final String heroTag = args is Map
        ? (args['heroTag'] ?? 'explore_image_${item.id}')
        : 'explore_image_${item.id}';

    // Use unique tag to prevent reusing old controller data between different items
    final controller = Get.put(ExploreDetailController(item), tag: item.id);

    return GlassyBackground(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 350.0,
              collapsedHeight: 150.0,
              toolbarHeight: 80.0,
              pinned: true,
              backgroundColor:
                  Colors.transparent, // Transparent to prevent hiding the image
              elevation: 0,
              automaticallyImplyLeading: false, // Custom leading
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Hero(
                    tag: heroTag,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(
                          0xFF0A1628,
                        ), // Dark background behind image to prevent text bleed
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: SizedBox(
                          height: constraints.maxHeight,
                          width: double.infinity,
                          child: _buildImage(item.image),
                        ),
                      ),
                    ),
                  );
                },
              ),
              titleSpacing: 16,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomBackButton(),
                  Row(
                    children: [
                      Obx(
                        () => GlassActionButton(
                          icon: item.isFavorite.value
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: item.isFavorite.value
                              ? Colors.red
                              : Colors.white,
                          onTap: controller.toggleFavorite,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildMainInfo(item),
                  const SizedBox(height: 24),
                  _buildTabBar(controller),
                  const SizedBox(height: 24),
                  Obx(() {
                    switch (controller.selectedTab.value) {
                      case 0:
                        return _buildDescriptionTab(item, controller);
                      case 1:
                        return _buildPhotosTab(item);
                      case 2:
                        return _buildReviewsTab(item);
                      default:
                        return _buildDescriptionTab(item, controller);
                    }
                  }),
                  // Extra space for the fixed bottom bar
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.price.isNotEmpty && item.price != 'N/A')
              ExploreDetailsActionBar(
                price: item.price,
                bookingUrl: item.bookingUrl,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return CachedNetworkImage(
      height: 350,
      width: double.infinity,
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(color: const Color(0xFF1A2A44)),
      errorWidget: (context, url, error) => Container(
        color: const Color(0xFF1A2A44),
        child: const Icon(Icons.broken_image, color: Colors.white24, size: 50),
      ),
    );
  }

  Widget _buildMainInfo(ExploreItemModel item) {
    String priceSuffix = item.type == ExploreItemType.hotel ? '/night' : '/p';
    if (item.price.toLowerCase().contains('free')) priceSuffix = '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    if (item.type == ExploreItemType.restaurant &&
                        item.cuisine != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          item.cuisine!,
                          style: const TextStyle(
                            color: Color(0xFFE09A1E),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    if (item.type == ExploreItemType.flight &&
                        item.airline != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          "${item.airline} • ${item.duration ?? ''}",
                          style: const TextStyle(
                            color: Color(0xFFE09A1E),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: item.price,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE09A1E),
                          ),
                        ),
                        TextSpan(
                          text: priceSuffix,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (item.rating > 0) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Color(0xFFFFD700),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.rating.toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFD700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: Color(0xFFE09A1E)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.location,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ExploreDetailController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A3A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Obx(
        () => Row(
          children: [
            _buildTabItem(0, "Descriptions", controller),
            _buildTabItem(1, "Photos", controller),
            _buildTabItem(2, "Reviews", controller),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(
    int index,
    String title,
    ExploreDetailController controller,
  ) {
    final isSelected = controller.selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4A5568) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white60,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionTab(
    ExploreItemModel item,
    ExploreDetailController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Overview",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (item.rating > 0)
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFFD700), size: 18),
                    const SizedBox(width: 4),
                    Text(
                      item.rating.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            item.description ?? "Explore the beauty of ${item.title}.",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.7,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            "Facilities",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildFacilitiesList(item),
          if (item.lat != null && item.lng != null) ...[
            const SizedBox(height: 30),
            const Text(
              "Location",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => controller.openMap(),
              child: _buildMapPreview(item),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMapPreview(ExploreItemModel item) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF1E2A3A),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?w=800',
          ), // Placeholder map texture
          fit: BoxFit.cover,
          opacity: 0.3,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE09A1E).withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFE09A1E).withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.location_on,
                color: Color(0xFFE09A1E),
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "View on Map",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              "${item.lat}, ${item.lng}",
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilitiesList(ExploreItemModel item) {
    final List<Map<String, dynamic>> facilities = [
      {'icon': Icons.map_outlined, 'label': 'Guided Tours'},
      {'icon': Icons.check_circle_outline, 'label': 'Visitor Center'},
      {'icon': Icons.info_outline, 'label': 'Information'},
    ];

    return SizedBox(
      height: 55,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: facilities.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2A3A),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                Icon(
                  facilities[index]['icon'],
                  color: const Color(0xFFE09A1E),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  facilities[index]['label'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhotosTab(ExploreItemModel item) {
    final controller = Get.find<ExploreDetailController>(tag: item.id);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Obx(
        () => GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: controller.photoUrls.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return GestureDetector(
                onTap: () => controller.showImageSourceDialog(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE09A1E).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_a_photo,
                          size: 28,
                          color: Color(0xFFE09A1E),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Add Photo',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final String imageUrl = controller.photoUrls[index - 1];
            return GestureDetector(
              onTap: () =>
                  controller.showImageViewer(context, imageUrl, index - 1),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: imageUrl.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.white10),
                      )
                    : Image.file(
                        File(imageUrl),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.white10,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.white24,
                                size: 40,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReviewsTab(ExploreItemModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      item.rating.toString(),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < item.rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: const Color(0xFFFFD700),
                          size: 16,
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '123 reviews',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar('Excellent', 0.8),
                      _buildRatingBar('Good', 0.15),
                      _buildRatingBar('Average', 0.03),
                      _buildRatingBar('Poor', 0.01),
                      _buildRatingBar('Bad', 0.01),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildReviewCard(
            'John Doe',
            '2 days ago',
            'Amazing place! Highly recommended for everyone visiting Egypt.',
          ),
          _buildReviewCard(
            'Sarah Smith',
            '1 week ago',
            'The view was stunning and the atmosphere was great.',
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(String label, double percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white60, fontSize: 10),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: Colors.white.withOpacity(0.05),
                valueColor: const AlwaysStoppedAnimation(Color(0xFFFFD700)),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percent * 100).toInt()}%',
            style: const TextStyle(color: Colors.white60, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String name, String date, String comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white10,
                child: Icon(Icons.person, color: Colors.white54),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.star, size: 14, color: Color(0xFFFFD700)),
              const SizedBox(width: 4),
              const Text(
                '5.0',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Color(0xFFFFD700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
