import 'package:flutter/material.dart';
import '../models/hymn.dart';
import '../theme/app_theme.dart';
import '../widgets/banner_ad_footer.dart';


class HymnDetailScreen extends StatefulWidget {
  final Hymn hymn;
  final List<Hymn> allHymns;
  final Function(Hymn) onToggleFavorite;

  const HymnDetailScreen({
    super.key,
    required this.hymn,
    required this.allHymns,
    required this.onToggleFavorite,
  });

  @override
  State<HymnDetailScreen> createState() => _HymnDetailScreenState();
}

class _HymnDetailScreenState extends State<HymnDetailScreen> {
  late Hymn _currentHymn;
  double _fontSize = 18.0;

  @override
  void initState() {
    super.initState();
    _currentHymn = widget.hymn;
  }

  void _navigateToHymnOffset(int delta) {
    int currentIndex = widget.allHymns.indexWhere((h) => h.id == _currentHymn.id);
    if (currentIndex != -1) {
      int newIndex = currentIndex + delta;
      if (newIndex >= 0 && newIndex < widget.allHymns.length) {
        setState(() {
          _currentHymn = widget.allHymns[newIndex];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    int currentIndex = widget.allHymns.indexWhere((h) => h.id == _currentHymn.id);
    bool hasPrev = currentIndex > 0;
    bool hasNext = currentIndex < widget.allHymns.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text("Hymn #${_currentHymn.number}"),
        actions: [
          IconButton(
            icon: Icon(_fontSize > 18 ? Icons.text_fields : Icons.format_size),
            tooltip: "Adjust Font Size",
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setModalState) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      height: 160,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Font Size: ${_fontSize.toInt()} pt",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              const Text("A", style: TextStyle(fontSize: 14)),
                              Expanded(
                                child: Slider(
                                  value: _fontSize,
                                  min: 14.0,
                                  max: 30.0,
                                  divisions: 8,
                                  activeColor: AppTheme.cyanPrimary,
                                  onChanged: (val) {
                                    setModalState(() {
                                      _fontSize = val;
                                    });
                                    setState(() {
                                      _fontSize = val;
                                    });
                                  },
                                ),
                              ),
                              const Text("A", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              _currentHymn.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _currentHymn.isFavorite ? Colors.redAccent : Colors.white,
            ),
            onPressed: () {
              widget.onToggleFavorite(_currentHymn);
              setState(() {
                _currentHymn.isFavorite = !_currentHymn.isFavorite;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Info Bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurface : AppTheme.cyanLight.withValues(alpha: 0.4),
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.cyanPrimary.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    _currentHymn.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.cyanDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      Chip(
                        label: Text(_currentHymn.category),
                        visualDensity: VisualDensity.compact,
                      ),
                      if (_currentHymn.keySignature != null)
                        Chip(
                          avatar: const Icon(Icons.music_note, size: 16, color: AppTheme.cyanPrimary),
                          label: Text("Key: ${_currentHymn.keySignature}"),
                          visualDensity: VisualDensity.compact,
                        ),
                      if (_currentHymn.tune != null)
                        Chip(
                          avatar: const Icon(Icons.tune, size: 16, color: AppTheme.goldAccent),
                          label: Text("Tune: ${_currentHymn.tune}"),
                          visualDensity: VisualDensity.compact,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Hymn Text Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Optional Refrain at top if applicable
                  if (_currentHymn.refrain != null) ...[
                    _buildRefrainCard(_currentHymn.refrain!, isDark),
                    const SizedBox(height: 20),
                  ],
                  // Stanzas
                  for (int i = 0; i < _currentHymn.stanzas.length; i++) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SelectableText(
                        _currentHymn.stanzas[i],
                        style: TextStyle(
                          fontSize: _fontSize,
                          height: 1.6,
                          color: isDark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
                          fontFamily: 'serif',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Bottom Prev / Next Navigation Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: hasPrev ? () => _navigateToHymnOffset(-1) : null,
                    icon: const Icon(Icons.arrow_back_ios, size: 16),
                    label: Text(
                      hasPrev ? "Hymn #${widget.allHymns[currentIndex - 1].number}" : "Start",
                    ),
                  ),
                  Text(
                    "${currentIndex + 1} of ${widget.allHymns.length}",
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                  TextButton.icon(
                    onPressed: hasNext ? () => _navigateToHymnOffset(1) : null,
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                    label: Text(
                      hasNext ? "Hymn #${widget.allHymns[currentIndex + 1].number}" : "End",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BannerAdFooter(),
    );
  }


  Widget _buildRefrainCard(String refrainText, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.goldAccent.withValues(alpha: 0.15) : const Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.goldAccent.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.repeat, size: 18, color: AppTheme.goldAccent),
              const SizedBox(width: 6),
              Text(
                "REFRAIN / CHORUS",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: isDark ? AppTheme.goldAccent : Colors.brown.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            refrainText,
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: FontWeight.w600,
              height: 1.5,
              fontStyle: FontStyle.italic,
              color: isDark ? Colors.white : Colors.brown.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
