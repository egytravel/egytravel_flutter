import 'package:egytravel_app/core/widgets/glassy_background.dart';
import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/details/explore_details_action_bar.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/details/explore_details_content.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/details/explore_details_hero_app_bar.dart';
import 'package:egytravel_app/feature/explore/ui/widgets/details/explore_details_info_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreDetailsScreen extends StatelessWidget {
  const ExploreDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ExploreItemModel item = Get.arguments as ExploreItemModel;

    return GlassyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            ExploreDetailsHeroAppBar(item: item),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExploreDetailsContent(item: item),
                    const SizedBox(height: 24),
                    ExploreDetailsInfoGrid(item: item),
                    const SizedBox(height: 30),
                    ExploreDetailsActionBar(price: item.price),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
