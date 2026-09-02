import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/hymns_data.dart';
import '../models/hymn.dart';
import '../theme/app_theme.dart';
import '../widgets/banner_ad_footer.dart';
import '../widgets/hymn_card.dart';
import '../widgets/quick_number_dialog.dart';
import 'hymn_detail_screen.dart';
import 'mass_program_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Hymn> _allHymns;
  late List<Hymn> _filteredHymns;
  String _selectedCategory = "All";
  String _searchQuery = "";
  bool _isGridView = false;
  bool _showOnlyFavorites = false;

  @override
  void initState() {
    super.initState();
    _allHymns = HymnsData.getAllHymns();
    _applyFilters();
    _checkAndShowAdNoticeDialog();
  }

  void _checkAndShowAdNoticeDialog() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasSeen = prefs.getBool("has_seen_ad_notice_popup") ?? false;
    if (!hasSeen && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAdNoticePopup(prefs);
      });
    }
  }

  void _showAdNoticePopup(SharedPreferences prefs) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.volunteer_activism, color: AppTheme.cyanPrimary),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "App Support & Ads Notice",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: const Text(
          "Welcome to Rejoice in the Lord Catholic Hymnbook!\n\nTo help maintain this application, support future updates, and keep all 700 hymns free for everyone, non-intrusive banner ads are shown at the bottom of pages, and full-screen ads are strictly limited to 2 per day.\n\nThank you for your support!",
          style: TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cyanPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                await prefs.setBool("has_seen_ad_notice_popup", true);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                "OK, I UNDERSTAND",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    setState(() {
      _filteredHymns = _allHymns.where((hymn) {
        // Category Filter
        if (_selectedCategory != "All" && hymn.category != _selectedCategory) {
          return false;
        }
        // Favorites Filter
        if (_showOnlyFavorites && !hymn.isFavorite) {
          return false;
        }
        // Search Query Filter (Number or Title)
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase().trim();
          final matchesNumber = hymn.number == query || hymn.number.contains(query);
          final matchesTitle = hymn.title.toLowerCase().contains(query);
          final matchesCategory = hymn.category.toLowerCase().contains(query);
          if (!matchesNumber && !matchesTitle && !matchesCategory) {
            return false;
          }
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavorite(Hymn hymn) {
    setState(() {
      hymn.isFavorite = !hymn.isFavorite;
      _applyFilters();
    });
  }

  void _openQuickJumpDialog() {
    showDialog(
      context: context,
      builder: (context) => QuickNumberDialog(
        allHymns: _allHymns,
        onHymnSelected: (hymn) {
          _openHymnDetail(hymn);
        },
      ),
    );
  }

  void _openHymnDetail(Hymn hymn) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HymnDetailScreen(
          hymn: hymn,
          allHymns: _allHymns,
          onToggleFavorite: _toggleFavorite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                'assets/images/cover.jpg',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.menu_book, color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "REJOICE IN THE LORD",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  "3rd Edition • Catholic Hymns",
                  style: TextStyle(fontSize: 10, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          // Order of Mass Action
          IconButton(
            icon: const Icon(Icons.church_outlined),
            tooltip: "Order of Mass",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MassProgramScreen(
                    allHymns: _allHymns,
                    onToggleFavorite: _toggleFavorite,
                  ),
                ),
              );
            },
          ),
          // Favorites Toggle Filter
          IconButton(
            icon: Icon(
              _showOnlyFavorites ? Icons.favorite : Icons.favorite_border,
              color: _showOnlyFavorites ? Colors.redAccent : Colors.white,
            ),
            tooltip: _showOnlyFavorites ? "Show All Hymns" : "Show Favorites Only",
            onPressed: () {
              setState(() {
                _showOnlyFavorites = !_showOnlyFavorites;
                _applyFilters();
              });
            },
          ),
          // View Mode Switcher (List vs Grid)
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            tooltip: _isGridView ? "List View" : "Grid View",
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header Container
          Container(
            color: isDark ? AppTheme.darkSurface : AppTheme.cyanLight.withValues(alpha: 0.3),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Column(
              children: [
                // Search Input Field
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search by Hymn # (1-700) or Title...",
                    prefixIcon: const Icon(Icons.search, color: AppTheme.cyanPrimary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchQuery = "";
                                _applyFilters();
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? AppTheme.darkBackground : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppTheme.cyanPrimary, width: 2),
                    ),
                  ),
                  onChanged: (val) {
                    _searchQuery = val;
                    _applyFilters();
                  },
                ),
                const SizedBox(height: 10),
                // Category Filter Chips Carousel
                SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: HymnsData.categories.length,
                    itemBuilder: (context, index) {
                      final category = HymnsData.categories[index];
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          selectedColor: AppTheme.cyanPrimary,
                          backgroundColor: isDark ? Colors.white10 : Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.white70 : AppTheme.cyanDark),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 12,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedCategory = category;
                                _applyFilters();
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Count & Status Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _showOnlyFavorites
                      ? "Favorite Hymns (${_filteredHymns.length})"
                      : "Showing ${_filteredHymns.length} Hymns (1 - 700)",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : Colors.blueGrey,
                  ),
                ),
                if (_selectedCategory != "All" || _showOnlyFavorites || _searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = "All";
                        _showOnlyFavorites = false;
                        _searchQuery = "";
                        _applyFilters();
                      });
                    },
                    child: const Text(
                      "Reset Filters",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.cyanPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Main Hymn List / Grid Display
          Expanded(
            child: _filteredHymns.isEmpty
                ? _buildEmptyState()
                : _isGridView
                    ? _buildGridView()
                    : _buildListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openQuickJumpDialog,
        icon: const Icon(Icons.dialpad),
        label: const Text(
          "JUMP #",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: const BannerAdFooter(),
    );

  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _filteredHymns.length,
      padding: const EdgeInsets.only(bottom: 80),
      itemBuilder: (context, index) {
        final hymn = _filteredHymns[index];
        return HymnListTile(
          hymn: hymn,
          onTap: () => _openHymnDetail(hymn),
          onFavoriteToggle: () => _toggleFavorite(hymn),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: _filteredHymns.length,
      itemBuilder: (context, index) {
        final hymn = _filteredHymns[index];
        return HymnGridTile(
          hymn: hymn,
          onTap: () => _openHymnDetail(hymn),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            "No Hymns Found",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Try searching a different number or keyword",
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
