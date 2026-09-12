import '../engine/color_matrix.dart';

class FilterItem {
  final String name, category;
  final List<double> matrix;
  const FilterItem(this.name, this.category, this.matrix);
}

class FilterProvider {
  static const categories = ['Portrait', 'Scenery', 'Vintage', 'Artistic', 'Digicam'];

  static final allFilters = <FilterItem>[
    // Portrait
    FilterItem('Original', 'Portrait', CM.identity),
    FilterItem('Soft Glow', 'Portrait', [
      1.1, 0, 0, 0, 10, //
      0, 1.05, 0, 0, 5, //
      0, 0, 1.05, 0, 5, //
      0, 0, 0, 1, 0,
    ]),
    FilterItem('Vivid', 'Portrait', CM.saturation(1.5)),
    FilterItem('Mono', 'Portrait', CM.saturation(0)),
    // Digicam (Y2K Camera FX)
    FilterItem('G7X Flash', 'Digicam', [
      1.25, 0, 0, 0, 18, //
      0, 1.15, 0, 0, 12, //
      0, 0, 1.0, 0, 5, //
      0, 0, 0, 1, 0,
    ]),
    FilterItem('Ricoh GR', 'Digicam', [
      1.3, 0.1, 0, 0, -10, //
      0.1, 1.1, 0, 0, -5, //
      0, 0.1, 0.9, 0, -10, //
      0, 0, 0, 1, 0,
    ]),
    FilterItem('Cool Flash', 'Digicam', [
      0.95, 0, 0, 0, 5, //
      0, 1.05, 0, 0, 10, //
      0, 0, 1.3, 0, 25, //
      0, 0, 0, 1, 0,
    ]),
    FilterItem('Sunset Flare', 'Digicam', [
      1.35, 0.1, 0, 0, 25, //
      0.1, 1.05, 0, 0, 10, //
      0, 0, 0.75, 0, -15, //
      0, 0, 0, 1, 0,
    ]),
    // Scenery
    FilterItem('Golden Hour', 'Scenery', [
      1.2, 0, 0, 0, 20, //
      0, 1.0, 0, 0, 0, //
      0, 0, 0.8, 0, -10, //
      0, 0, 0, 1, 0,
    ]),
    FilterItem('Cool Deep', 'Scenery', [
      0.8, 0, 0, 0, 0, //
      0, 1.0, 0, 0, 5, //
      0, 0, 1.3, 0, 20, //
      0, 0, 0, 1, 0,
    ]),
    FilterItem('Warm Sun', 'Scenery', [
      1.1, 0, 0, 0, 0, //
      0, 1, 0, 0, 0, //
      0, 0, 0.9, 0, 0, //
      0, 0, 0, 1, 0,
    ]),
    // Vintage
    FilterItem('Sepia', 'Vintage', [
      0.393, 0.769, 0.189, 0, 0, //
      0.349, 0.686, 0.168, 0, 0, //
      0.272, 0.534, 0.131, 0, 0, //
      0, 0, 0, 1, 0,
    ]),
    FilterItem('Retro 1970', 'Vintage', [
      1.1, 0, 0, 0, 0, //
      0, 1.1, 0, 0, 0, //
      0, 0, 0.8, 0, 0, //
      0, 0, 0, 1, 0,
    ]),
    FilterItem('Old Film', 'Vintage', [
      0.9, 0, 0, 0, 0, //
      0, 0.8, 0, 0, 0, //
      0, 0, 0.5, 0, 0, //
      0, 0, 0, 1, 0,
    ]),
    // Artistic
    FilterItem('Cyberpunk', 'Artistic', [
      1.5, 0, 0, 0, 20, //
      0, 0.5, 0, 0, -20, //
      0, 0, 2.0, 0, 40, //
      0, 0, 0, 1, 0,
    ]),
    FilterItem('Forest', 'Artistic', [
      0.6, 0, 0, 0, -10, //
      0, 1.4, 0, 0, 20, //
      0, 0, 0.6, 0, -10, //
      0, 0, 0, 1, 0,
    ]),
    FilterItem('Night Vision', 'Artistic', [
      0.1, 0.4, 0.1, 0, 0, //
      0.3, 1.0, 0.3, 0, 0, //
      0.1, 0.4, 0.1, 0, 0, //
      0, 0, 0, 1, 0,
    ]),
    FilterItem('Invert', 'Artistic', [
      -1, 0, 0, 0, 255, //
      0, -1, 0, 0, 255, //
      0, 0, -1, 0, 255, //
      0, 0, 0, 1, 0,
    ]),
    FilterItem('Midnight', 'Scenery', [
      0.5, 0, 0, 0, -20, //
      0, 0.6, 0, 0, -10, //
      0, 0, 1.2, 0, 20, //
      0, 0, 0, 1, 0,
    ]),
    FilterItem('Dreamy', 'Portrait', [
      1.2, 0.1, 0.1, 0, 10, //
      0.1, 1.1, 0.1, 0, 10, //
      0.1, 0.1, 1.3, 0, 10, //
      0, 0, 0, 1, 0,
    ]),
    FilterItem('Glow', 'Artistic', [
      1.2, 0, 0, 0, 20, //
      0, 1.2, 0, 0, 20, //
      0, 0, 1.2, 0, 20, //
      0, 0, 0, 1, 0,
    ]),
  ];

  static FilterItem? byName(String name) =>
      allFilters.where((f) => f.name == name).firstOrNull;
}
