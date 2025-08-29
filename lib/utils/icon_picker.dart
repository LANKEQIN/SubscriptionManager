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
  // 常用图标列表
  final List<IconData> _commonIcons = [
    Icons.subscriptions_outlined,
    Icons.video_library_outlined,
    Icons.music_note_outlined,
    Icons.book_outlined,
    Icons.phone_iphone_outlined,
    Icons.computer_outlined,
    Icons.cloud_outlined,
    Icons.games_outlined,
    Icons.movie_outlined,
    Icons.tv_outlined,
    Icons.sports_esports_outlined,
    Icons.shopping_cart_outlined,
    Icons.fastfood_outlined,
    Icons.local_gas_station_outlined,
    Icons.directions_car_outlined,
    Icons.home_outlined,
    Icons.pets_outlined,
    Icons.health_and_safety_outlined,
    Icons.fitness_center_outlined,
    Icons.business_outlined,
  ];

  IconData? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.selectedIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '选择图标',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _commonIcons.length,
            itemBuilder: (context, index) {
              final icon = _commonIcons[index];
              final isSelected = _selectedIcon == icon;
              
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = icon;
                    });
                    widget.onIconSelected(icon);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Theme.of(context).colorScheme.primary 
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected 
                            ? Theme.of(context).colorScheme.primary 
                            : Theme.of(context).dividerColor,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected 
                          ? Theme.of(context).colorScheme.onPrimary 
                          : Theme.of(context).colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
