import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

import 'achievement_viewmodel.dart';
import '../data/models/achievement.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AchievementViewModel()..load(),
      child: const _AchievementsView(),
    );
  }
}

class _AchievementsView extends StatefulWidget {
  const _AchievementsView({Key? key}) : super(key: key);

  @override
  State<_AchievementsView> createState() => _AchievementsViewState();
}

class _AchievementsViewState extends State<_AchievementsView>
    with TickerProviderStateMixin {
  String? _selectedCategory;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final vm = context.read<AchievementViewModel>();
    final category =
        _selectedCategory ??
            (vm.categories.isNotEmpty ? vm.categories.first : null);

    if (category == null) return;

    if (_scrollController.position.pixels + 300 >=
        _scrollController.position.maxScrollExtent) {
      if (vm.canLoadMore(category)) {
        vm.loadMore(category);
      }
    }
  }

  int _getCrossAxisCount(double width) {
    if (width >= 1100) return 6;
    if (width >= 900) return 5;
    if (width >= 700) return 4;
    if (width >= 500) return 3;
    return 2;
  }

  double _getChildAspectRatio(double width) {
    if (width < 360) return 0.62;
    if (width < 500) return 0.68;
    if (width < 700) return 0.75;
    return 0.82;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    final crossAxisCount = _getCrossAxisCount(width);
    final childAspectRatio = _getChildAspectRatio(width);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: SafeArea(
        child: Consumer<AchievementViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading) {
              return _buildShimmerGrid(
                crossAxisCount,
                childAspectRatio,
              );
            }

            final categories = vm.categories;

            if (categories.isEmpty) {
              return _buildEmptyState();
            }

            _selectedCategory ??= categories.first;

            return Column(
              children: [
                _buildCategoryChips(categories),

                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification) {
                        _onScroll();
                      }
                      return false;
                    },
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.all(width * 0.03),
                          sliver: _buildGridForCategory(
                            vm,
                            _selectedCategory!,
                            crossAxisCount,
                            childAspectRatio,
                          ),
                        ),

                        if (vm.canLoadMore(_selectedCategory!))
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryChips(List<String> categories) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final selected = cat == _selectedCategory;

          return ChoiceChip(
            label: Text(
              cat,
              overflow: TextOverflow.ellipsis,
            ),
            selected: selected,
            onSelected: (_) {
              setState(() => _selectedCategory = cat);
            },
            selectedColor:
            Theme.of(context).colorScheme.primary.withAlpha(31),
          );
        },
      ),
    );
  }

  Widget _buildGridForCategory(
      AchievementViewModel vm,
      String category,
      int crossAxisCount,
      double childAspectRatio,
      ) {
    final items = vm.itemsForCategory(category);

    if (items.isEmpty) {
      return SliverToBoxAdapter(
        child: _buildEmptyState(category: category),
      );
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: childAspectRatio,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final item = items[index];

          return _AchievementTile(
            item: item,
            onTap: () => _onTileTap(item),
          );
        },
        childCount: items.length,
      ),
    );
  }

  void _onTileTap(Achievement item) {
    context.read<AchievementViewModel>().unlockAchievement(item.id);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: SvgPicture.asset(item.assetPath),
            ),

            const SizedBox(height: 12),

            Text(
              item.description,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid(
      int crossAxisCount,
      double childAspectRatio,
      ) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState({String? category}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 12),

            Text(
              category == null
                  ? 'No achievements found'
                  : 'No achievements in "$category"',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementTile extends StatefulWidget {
  final Achievement item;
  final VoidCallback? onTap;

  const _AchievementTile({
    required this.item,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<_AchievementTile> createState() => _AchievementTileState();
}

class _AchievementTileState extends State<_AchievementTile>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();

    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    if (widget.item.unlocked) {
      _anim.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant _AchievementTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.item.unlocked && widget.item.unlocked) {
      _anim.forward();
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final width = MediaQuery.of(context).size.width;

    // final imageSize = width < 360 ? 72.0 : 80.0;
    final imageSize = 300.0;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, child) {
          final scale = 0.9 + 0.1 * _anim.value;
          final opacity = 0.5 + 0.5 * _anim.value;

          return Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,                  children: [
                Flexible(
                      child: Center(
                        child: Hero(
                          tag: widget.item.id,
                          child: SvgPicture.asset(
                            widget.item.assetPath,
                            width: imageSize,
                            height: imageSize,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      // widget.item.title,
                      "hello",
                      style: TextStyle(
                        fontSize: width < 360 ? 11 : 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}