import 'package:flutter/material.dart';

import '../../core/data/filter_provider.dart';
import '../../core/theme/app_colors.dart';

/// Filter selector: intensity slider + category tabs + filter thumbnails.
class FilterSelector extends StatelessWidget {
  final String selectedFilterName;
  final double filterIntensity;
  final String selectedCategory;
  final ImageProvider? previewImage;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<FilterItem> onFilterSelected;
  final ValueChanged<double> onIntensityChange;

  const FilterSelector({
    super.key,
    required this.selectedFilterName,
    required this.filterIntensity,
    required this.selectedCategory,
    required this.previewImage,
    required this.onCategorySelected,
    required this.onFilterSelected,
    required this.onIntensityChange,
  });

  @override
  Widget build(BuildContext context) {
    final list = FilterProvider.allFilters
        .where((f) => f.category == selectedCategory || f.name == 'Original')
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedFilterName != 'Original') ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text('Intensity', style: TextStyle(fontSize: 12)),
          ),
          Slider(
            value: filterIntensity.clamp(0, 1),
            onChanged: onIntensityChange,
          ),
          const SizedBox(height: 6),
        ],
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final category in FilterProvider.categories)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () => onCategorySelected(category),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: selectedCategory == category
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: selectedCategory == category
                                ? primaryPink
                                : Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: 2,
                          width: 40,
                          color: selectedCategory == category
                              ? primaryPink
                              : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final filter = list[i];
              final isSelected = filter.name == selectedFilterName;
              return GestureDetector(
                onTap: () => onFilterSelected(filter),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.withValues(alpha: 0.3),
                        border: isSelected
                            ? Border.all(color: filterSelectedBorder, width: 2)
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: previewImage != null
                            ? Image(
                                image: previewImage!,
                                fit: BoxFit.cover,
                                colorBlendMode: BlendMode.color,
                                color: Colors.white.withValues(alpha: 0),
                              )
                            : const SizedBox(),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      filter.name,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected ? primaryPink : Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
