import '../../shared/app_images.dart';

enum ElementCategory {
  nightlife('Ocio nocturno', AppImages.canaryNight),
  gaming('Videojuegos', AppImages.profile);

  const ElementCategory(this.label, this.image);
  final String label;
  final String image;
}

class PortfolioElement {
  const PortfolioElement({
    required this.name,
    required this.description,
    required this.category,
  });

  final String name;
  final String description;
  final ElementCategory category;
}
