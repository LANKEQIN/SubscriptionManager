import 'package:flutter/material.dart';

class IconPicker extends StatefulWidget {
  final IconData? selectedIcon;
  final Function(IconData) onIconSelected;

  const IconPicker({
    super.key,
    this.selectedIcon,
    required this.onIconSelected,
  });

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  // 图标选项
  final List<IconData> _iconOptions = [
    Icons.music_note,
    Icons.movie,
    Icons.games,
    Icons.phone_iphone,
    Icons.computer,
    Icons.tv,
    Icons.book,
    Icons.fitness_center,
    Icons.fastfood,
    Icons.local_shipping,
    Icons.home,
    Icons.account_balance,
  ];

  void _showIconPickerDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        '选择图标',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 64,
                        childAspectRatio: 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _iconOptions.length,
                      itemBuilder: (context, index) {
                        final icon = _iconOptions[index];
                        return InkWell(
                          onTap: () {
                            widget.onIconSelected(icon);
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: icon == widget.selectedIcon
                                  ? Theme.of(context).colorScheme.primaryContainer
                                  : Theme.of(context).colorScheme.surface,
                            ),
                            child: Icon(
                              icon,
                              size: 32,
                              color: icon == widget.selectedIcon
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).iconTheme.color,
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('图标选择', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            _showIconPickerDialog(context);
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              widget.selectedIcon ?? Icons.help_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            widget.selectedIcon != null ? '已选择图标' : '请选择图标',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            overflow: TextOverflow.fade,
          ),
        ),
      ],
    );
  }
}