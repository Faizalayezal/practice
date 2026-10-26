class CategoryItemModel {
  final String id;
  final String title;
  final String imageUrl;

  CategoryItemModel({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory CategoryItemModel.fromJson(Map<String, dynamic> json) {
    return CategoryItemModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? '',
      imageUrl: json['image'] ?? json['image_url'] ?? '',
    );
  }
}

class ServiceProviderModel {
  final String id;
  final String name;
  final String imagePath;
  final double distance;
  final double rating;
  final int reviews;
  final int jobs;
  final List<String> services;

  ServiceProviderModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.distance,
    required this.rating,
    required this.reviews,
    required this.jobs,
    required this.services,
  });

  factory ServiceProviderModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedServices = [];
    if (json['services'] is List) {
      parsedServices =
          (json['services'] as List).map((e) => e.toString()).toList();
    } else if (json['service_names'] is String) {
      parsedServices = (json['service_names'] as String).split(',');
    }

    return ServiceProviderModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['provider_name'] ?? '',
      imagePath: json['profile_image'] ?? json['image'] ?? '',
      distance: (json['distance'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviews: json['total_reviews'] ?? json['reviews'] ?? 0,
      jobs: json['total_jobs'] ?? json['jobs'] ?? 0,
      services: parsedServices,
    );
  }
}

class HomeResponseModel {
  final List<CategoryItemModel> categories;
  final List<ServiceProviderModel> providers;

  HomeResponseModel({
    required this.categories,
    required this.providers,
  });

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    final List catList = data['categories'] ?? data['sub_categories'] ?? [];
    final List providerList =
        data['sponsor_providers'] ?? data['providers'] ?? [];

    return HomeResponseModel(
      categories:
          catList.map((e) => CategoryItemModel.fromJson(e)).toList(),
      providers: providerList
          .map((e) => ServiceProviderModel.fromJson(e))
          .toList(),
    );
  }
}
