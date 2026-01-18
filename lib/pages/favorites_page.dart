import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/content_item.dart';
import '../services/favorites_manager.dart';
import '../data/content_data.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesManager _favoritesManager = FavoritesManager();
  String? _animatingHeartId;

  @override
  void initState() {
    super.initState();
    _favoritesManager.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    _favoritesManager.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (mounted) setState(() {});
  }

  // Get all favorited items from shared data
  List<ContentItem> get favoriteItems {
    final favoriteIds = _favoritesManager.favoriteIds;
    return ContentData.allItems
        .where((item) => favoriteIds.contains(item.id))
        .toList();
  }

  void _copyToClipboard(String content) {
    Clipboard.setData(ClipboardData(text: content));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF496853),
      ),
    );
  }

  void _removeFavorite(ContentItem item) async {
    await _favoritesManager.toggleFavorite(item);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from favorites'),
        duration: Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF496853),
      ),
    );
  }

  void _handleDoubleTap(ContentItem item) async {
    await _favoritesManager.toggleFavorite(item);
    
    setState(() {
      _animatingHeartId = item.id;
    });
    
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _animatingHeartId = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final favorites = favoriteItems;

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Favorites',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              if (favorites.isNotEmpty)
                TextButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF262932),
                        title: const Text(
                          'Clear All Favorites?',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: const Text(
                          'This will remove all items from your favorites.',
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Clear All',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await _favoritesManager.clearAll();
                    }
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                  label: const Text(
                    'Clear All',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),

        // Grid of Favorites
        Expanded(
          child: favorites.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: Colors.white24,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Double tap items to add them here',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: favorites[0].type == ContentType.emoticon ? 3 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: favorites[0].type == ContentType.emoticon ? 2.5 : 1,
                    ),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final item = favorites[index];
                      final isAnimating = _animatingHeartId == item.id;
                      
                      return GestureDetector(
                        onTap: () => _copyToClipboard(item.content),
                        onDoubleTap: () => _handleDoubleTap(item),
                        onLongPress: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: const Color(0xFF262932),
                            builder: (context) => Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.delete, color: Colors.red),
                                    title: const Text(
                                      'Remove from favorites',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _removeFavorite(item);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF262932),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF496853),
                                  width: 2,
                                ),
                              ),
                              child: item.type == ContentType.emoticon
                                  ? Center(
                                      child: Text(
                                        item.content,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        item.content,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Center(
                                            child: Icon(Icons.image, color: Colors.white54),
                                          );
                                        },
                                      ),
                                    ),
                            ),
                            Positioned(
                              top: item.type == ContentType.emoticon ? 4 : 8,
                              right: item.type == ContentType.emoticon ? 4 : 8,
                              child: Container(
                                padding: EdgeInsets.all(item.type == ContentType.emoticon ? 2 : 4),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(item.type == ContentType.emoticon ? 10 : 20),
                                ),
                                child: Icon(
                                  Icons.favorite,
                                  color: const Color(0xFF496853),
                                  size: item.type == ContentType.emoticon ? 10 : 16,
                                ),
                              ),
                            ),
                            if (isAnimating)
                              Center(
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.elasticOut,
                                  builder: (context, value, child) {
                                    return Transform.scale(
                                      scale: value,
                                      child: Opacity(
                                        opacity: 1.0 - (value * 0.5),
                                        child: Icon(
                                          Icons.favorite,
                                          color: const Color(0xFF496853),
                                          size: item.type == ContentType.emoticon ? 40 : 80,
                                          shadows: const [
                                            Shadow(
                                              blurRadius: 20,
                                              color: Colors.black54,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
