import 'package:flutter/material.dart';
import '../models/hymn.dart';
import '../theme/app_theme.dart';
import 'hymn_detail_screen.dart';

class MassProgramScreen extends StatefulWidget {
  final List<Hymn> allHymns;
  final Function(Hymn) onToggleFavorite;

  const MassProgramScreen({
    super.key,
    required this.allHymns,
    required this.onToggleFavorite,
  });

  @override
  State<MassProgramScreen> createState() => _MassProgramScreenState();
}

class _MassProgramScreenState extends State<MassProgramScreen> {
  Hymn? _entranceHymn;
  Hymn? _offertoryHymn;
  Hymn? _communionHymn;
  Hymn? _recessionalHymn;

  @override
  void initState() {
    super.initState();
    // Default preset picks for demo
    _entranceHymn = widget.allHymns.firstWhere((h) => h.id == 1, orElse: () => widget.allHymns[0]);
    _offertoryHymn = widget.allHymns.firstWhere((h) => h.id == 50, orElse: () => widget.allHymns[1]);
    _communionHymn = widget.allHymns.firstWhere((h) => h.id == 100, orElse: () => widget.allHymns[2]);
    _recessionalHymn = widget.allHymns.firstWhere((h) => h.id == 300, orElse: () => widget.allHymns[3]);
  }

  void _pickHymnForSlot(String slotName, Function(Hymn) onSelected) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        String searchQuery = "";
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = widget.allHymns.where((h) {
              final q = searchQuery.toLowerCase();
              return h.number.contains(q) || h.title.toLowerCase().contains(q) || h.category.toLowerCase().contains(q);
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Select $slotName",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.cyanPrimary),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search by number or title...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onChanged: (val) {
                      setModalState(() {
                        searchQuery = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.cyanPrimary,
                            child: Text(
                              item.number,
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Text(item.category),
                          onTap: () {
                            onSelected(item);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order of Mass"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Reset Mass Builder",
            onPressed: () {
              setState(() {
                _entranceHymn = null;
                _offertoryHymn = null;
                _communionHymn = null;
                _recessionalHymn = null;
              });
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.cyanPrimary, AppTheme.cyanDark],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.church, size: 40, color: Colors.white),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Sunday Mass Hymn Order",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Prepare liturgy songs for Choir & Congregation",
                        style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _buildSlotCard(
            title: "Entrance Hymn",
            subtitle: "Processional Song",
            icon: Icons.door_front_door_outlined,
            selectedHymn: _entranceHymn,
            onPick: () => _pickHymnForSlot("Entrance Hymn", (h) => setState(() => _entranceHymn = h)),
          ),
          const SizedBox(height: 12),
          _buildSlotCard(
            title: "Offertory Hymn",
            subtitle: "Preparation of the Gifts",
            icon: Icons.volunteer_activism_outlined,
            selectedHymn: _offertoryHymn,
            onPick: () => _pickHymnForSlot("Offertory Hymn", (h) => setState(() => _offertoryHymn = h)),
          ),
          const SizedBox(height: 12),
          _buildSlotCard(
            title: "Communion Hymn",
            subtitle: "Holy Eucharist",
            icon: Icons.local_dining_outlined,
            selectedHymn: _communionHymn,
            onPick: () => _pickHymnForSlot("Communion Hymn", (h) => setState(() => _communionHymn = h)),
          ),
          const SizedBox(height: 12),
          _buildSlotCard(
            title: "Recessional Hymn",
            subtitle: "Concluding Song",
            icon: Icons.exit_to_app,
            selectedHymn: _recessionalHymn,
            onPick: () => _pickHymnForSlot("Recessional Hymn", (h) => setState(() => _recessionalHymn = h)),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Hymn? selectedHymn,
    required VoidCallback onPick,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.cyanPrimary, size: 22),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                  ],
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onPick,
                  icon: const Icon(Icons.edit_note, size: 18),
                  label: Text(selectedHymn == null ? "Select" : "Change"),
                ),
              ],
            ),
            if (selectedHymn != null) ...[
              const Divider(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.cyanPrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      selectedHymn.number,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                title: Text(
                  selectedHymn.title,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                subtitle: Text(selectedHymn.category),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HymnDetailScreen(
                        hymn: selectedHymn,
                        allHymns: widget.allHymns,
                        onToggleFavorite: widget.onToggleFavorite,
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
