import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'pages/emoticon_page.dart';
import 'pages/gif_page.dart';
import 'pages/meme_page.dart';
import 'pages/favorites_page.dart';
import 'services/favorites_manager.dart';
import 'data/content_data.dart';
import 'models/content_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FavoritesManager().init();
  runApp(const HersheyApp());
}

class HersheyApp extends StatelessWidget {
  const HersheyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hershey',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 1; // Start with Emoticons selected
  late AnimationController _rotationController;

  // List of pages corresponding to each tab
  final List<Widget> _pages = [
    const Center(child: Text('Home', style: TextStyle(color: Colors.white))), // Index 0 (unused for now)
    const EmoticonPage(),  // Index 1
    const GifPage(),       // Index 2
    const MemePage(),      // Index 3
    const FavoritesPage(), // Index 4
  ];

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(); // Continuously rotate
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF262932),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add New Item',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select a category',
                style: TextStyle(
                  color: Color(0xFF777A8D),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              _buildCategoryButton(
                icon: Icons.emoji_emotions_outlined,
                label: 'Emoticon',
                color: const Color(0xFF496853),
                onTap: () {
                  Navigator.pop(context);
                  _showAddContentDialog(ContentType.emoticon);
                },
              ),
              const SizedBox(height: 12),
              _buildCategoryButton(
                icon: Icons.gif_box_outlined,
                label: 'GIF',
                color: const Color(0xFF496853),
                onTap: () {
                  Navigator.pop(context);
                  _showAddContentDialog(ContentType.gif);
                },
              ),
              const SizedBox(height: 12),
              _buildCategoryButton(
                icon: Icons.image_outlined,
                label: 'Meme',
                color: const Color(0xFF496853),
                onTap: () {
                  Navigator.pop(context);
                  _showAddContentDialog(ContentType.meme);
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF777A8D)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1B21),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }

  void _showAddContentDialog(ContentType type) async {
    if (type == ContentType.gif || type == ContentType.meme) {
      // For GIF and Meme, open file picker
      await _pickImageFile(type);
    } else {
      // For Emoticon, show text input dialog
      _showEmoticonInputDialog();
    }
  }

  Future<void> _pickImageFile(ContentType type) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        // Show loading dialog
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF496853),
              ),
            ),
          );
        }

        // Get app directory
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = '${type.name}_${DateTime.now().millisecondsSinceEpoch}${_getFileExtension(pickedFile.path)}';
        final localPath = '${appDir.path}/$fileName';

        // Copy file to app directory
        final File localFile = await File(pickedFile.path).copy(localPath);

        // Close loading dialog
        if (mounted) Navigator.pop(context);

        // Show tags input dialog
        _showTagsDialog(type, localPath);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking file: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  String _getFileExtension(String path) {
    return path.substring(path.lastIndexOf('.'));
  }

  void _showTagsDialog(ContentType type, String filePath) {
    final tagsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF262932),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Tags for ${type.name.toUpperCase()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'File selected successfully!',
                style: TextStyle(
                  color: Color(0xFF496853),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tags (comma separated)',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: tagsController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'e.g., happy, cute, funny',
                  hintStyle: const TextStyle(color: Color(0xFF777A8D)),
                  filled: true,
                  fillColor: const Color(0xFF1A1B21),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // Delete the file if user cancels
                      File(filePath).delete();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Color(0xFF777A8D)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      _addNewItem(
                        type,
                        filePath,
                        tagsController.text,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF496853),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEmoticonInputDialog() {
    final contentController = TextEditingController();
    final tagsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF262932),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add EMOTICON',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Emoticon',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: contentController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'e.g., (˶ᵔ ᵕ ᵔ˶)',
                    hintStyle: const TextStyle(color: Color(0xFF777A8D)),
                    filled: true,
                    fillColor: const Color(0xFF1A1B21),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tags (comma separated)',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: tagsController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'e.g., happy, cute, smile',
                    hintStyle: const TextStyle(color: Color(0xFF777A8D)),
                    filled: true,
                    fillColor: const Color(0xFF1A1B21),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Color(0xFF777A8D)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (contentController.text.isNotEmpty) {
                          _addNewItem(
                            ContentType.emoticon,
                            contentController.text,
                            tagsController.text,
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF496853),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addNewItem(ContentType type, String content, String tagsString) {
    final tags = tagsString
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    final newItem = ContentItem(
      id: '${type.name}_${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      type: type,
      tags: tags,
    );

    setState(() {
      switch (type) {
        case ContentType.emoticon:
          ContentData.emoticons.add(newItem);
          break;
        case ContentType.gif:
          ContentData.gifs.add(newItem);
          break;
        case ContentType.meme:
          ContentData.memes.add(newItem);
          break;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${type.name.toUpperCase()} added successfully!'),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF496853),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16171D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16171D),
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'images/top-logo.png', 
          height: 60,
        ),
      ),
      // Display the page based on selected index
      body: _pages[_selectedIndex],
      floatingActionButton: SizedBox(
        width: 65,
        height: 65,
        child: FloatingActionButton(
          onPressed: _showAddItemDialog,
          backgroundColor: _selectedIndex > 0 
              ? const Color(0xFF496853)  // Green when on any tab
              : const Color(0xFF262932), // Gray when on home
          elevation: 8,
          shape: const CircleBorder(),
          child: AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * 3.14159, // Full rotation
                child: child,
              );
            },
            child: SvgPicture.asset(
              'assets/icons/nekogram.svg',
              width: 32,
              height: 32,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF262932),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItemSvg('shine.svg', 'shine-active.svg', 'Emoticons', 1),
              _buildNavItemSvg('leaf.svg', 'leaf-active.svg', 'Gif', 2),
              const SizedBox(width: 40),
              _buildNavItemSvg('catogram.svg', 'catogram-active.svg', 'Meme', 3),
              _buildNavItemSvg('heart.svg', 'heart-active.svg', 'Favorites', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : const Color(0xFF777A8D),
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItemSvg(String iconPath, String activeIconPath, String label, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      splashColor: Colors.transparent, // Remove white splash
      highlightColor: Colors.transparent, // Remove white highlight
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            isSelected ? 'assets/icons/$activeIconPath' : 'assets/icons/$iconPath',
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(
              isSelected ? const Color(0xFF496853) : const Color(0xFF777A8D),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: isSelected ? const Color(0xFF496853) : const Color(0xFF777A8D),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
