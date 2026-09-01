import 'package:flutter/material.dart';
import '../models/hymn.dart';
import '../theme/app_theme.dart';

class QuickNumberDialog extends StatefulWidget {
  final List<Hymn> allHymns;
  final Function(Hymn) onHymnSelected;

  const QuickNumberDialog({
    super.key,
    required this.allHymns,
    required this.onHymnSelected,
  });

  @override
  State<QuickNumberDialog> createState() => _QuickNumberDialogState();
}

class _QuickNumberDialogState extends State<QuickNumberDialog> {
  String _enteredNumber = "";
  String? _errorMessage;

  void _onKeyPress(String digit) {
    if (_enteredNumber.length < 3) {
      setState(() {
        _enteredNumber += digit;
        _errorMessage = null;
      });
    }
  }

  void _onBackspace() {
    if (_enteredNumber.isNotEmpty) {
      setState(() {
        _enteredNumber = _enteredNumber.substring(0, _enteredNumber.length - 1);
        _errorMessage = null;
      });
    }
  }

  void _onClear() {
    setState(() {
      _enteredNumber = "";
      _errorMessage = null;
    });
  }

  void _submit() {
    if (_enteredNumber.isEmpty) return;
    int? numVal = int.tryParse(_enteredNumber);
    if (numVal == null || numVal < 1 || numVal > 700) {
      setState(() {
        _errorMessage = "Enter a valid number between 1 and 700";
      });
      return;
    }

    final found = widget.allHymns.firstWhere(
      (h) => h.id == numVal,
      orElse: () => widget.allHymns.first,
    );

    Navigator.of(context).pop();
    widget.onHymnSelected(found);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 320,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Jump to Hymn",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.cyanPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Number Display Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkBackground : AppTheme.cyanLight.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.cyanPrimary.withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  _enteredNumber.isEmpty ? "Tap number..." : _enteredNumber,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    color: _enteredNumber.isEmpty
                        ? Colors.grey
                        : AppTheme.cyanDark,
                  ),
                ),
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ],
            const SizedBox(height: 16),
            // Keypad Grid
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.4,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (int i = 1; i <= 9; i++)
                  _buildKeypadButton("$i", () => _onKeyPress("$i")),
                _buildKeypadButton("C", _onClear, color: Colors.orange.shade700),
                _buildKeypadButton("0", () => _onKeyPress("0")),
                _buildKeypadButton("⌫", _onBackspace, color: Colors.blueGrey),
              ],
            ),
            const SizedBox(height: 16),
            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.cyanPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _enteredNumber.isNotEmpty ? _submit : null,
                icon: const Icon(Icons.arrow_forward),
                label: const Text(
                  "OPEN HYMN",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String label, VoidCallback onTap, {Color? color}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: color ?? (isDark ? Colors.white10 : Colors.grey.shade100),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color != null
                  ? Colors.white
                  : (isDark ? Colors.white : AppTheme.cyanDark),
            ),
          ),
        ),
      ),
    );
  }
}
