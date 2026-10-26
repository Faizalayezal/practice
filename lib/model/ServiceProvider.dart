class ServiceProvider {
  final String id;
  final String name;
  final String imagePath;
  final double distance;
  final double rating;
  final int reviews;
  final int jobs;
  final List<String> services;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.distance,
    required this.rating,
    required this.reviews,
    required this.jobs,
    required this.services,
  });
}

final List<ServiceProvider> provider = [
  ServiceProvider(
    id: '1',
    name: 'Matthew Dwyer',
    imagePath:
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=200&auto=format&fit=crop',
    distance: 0.0,
    rating: 5.0,
    reviews: 2,
    jobs: 2,
    services: ['Industrial Cleaning', 'Deep cleaning', 'Commercial Cleaning'],
  ),
  ServiceProvider(
    id: '2',
    name: 'Gin Marie',
    imagePath:
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop',
    distance: 6.5,
    rating: 4.5,
    reviews: 33,
    jobs: 42,
    services: ['Deep cleaning', 'Industrial Cleaning'],
  ),
  ServiceProvider(
    id: '3',
    name: 'Jeffrey Dahmer',
    imagePath:
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200&auto=format&fit=crop',
    distance: 0.1,
    rating: 0,
    reviews: 0,
    jobs: 7,
    services: ['Deep cleaning', 'Industrial Cleaning'],
  ),
];


class CategoryData {
  final String imageURl;
  final String title;

  CategoryData({required this.imageURl, required this.title});
}



final List<CategoryData> categoryList = [
  CategoryData(
    imageURl:
        'https://images.unsplash.com/photo-1581578731548-c64695cc6952?q=80&w=200&auto=format&fit=crop',
    title: 'Industrial\nCleaning',
  ),
  CategoryData(
    imageURl:
        'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?q=80&w=200&auto=format&fit=crop',
    title: 'Deep cleaning',
  ),
  CategoryData(
    imageURl:
        'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?q=80&w=200&auto=format&fit=crop',
    title: 'Commercial\nCleaning',
  ),
];



class MainCategoryPackageData {
  final String title;
  bool? isSelected=false;
  final List<PackageData> packageData;

  MainCategoryPackageData({required this.title, required this.packageData,this.isSelected});
}

class PackageData {
  final String title;
  final String description;
  final String amount;
  String count;
  bool? isAdd;

  PackageData({
    required this.title,
    required this.description,
    required this.amount,
    required this.count,
    this.isAdd = false,
  });
}

final List<MainCategoryPackageData> mainCategoryPackageList = [
  MainCategoryPackageData(
    title: 'Commercial Cleaning',
    isSelected: true,
    packageData: [
      PackageData(
        title: 'Monthly Package',
        description:
        'Regular, multiple visits per week for a high level of cleanliness and attention to detail.',
        amount: '1200.00',
        count: '1',
        isAdd: false,
      ),
      PackageData(
        title: 'Standard Cleaning',
        description:
        'A balanced cleaning service for your entire home, perfect for regular maintenance.',
        amount: '100.00',
        count: '0',
        isAdd: false,
      ),
    ],
  ),

  MainCategoryPackageData(
    title: 'Industrial Cleaning',
    isSelected: false,
    packageData: [
      PackageData(
        title: 'Industrial Deep Cleaning',
        description:
        'Professional cleaning for industrial spaces with detailed attention.',
        amount: '1500.00',
        count: '0',
        isAdd: false,
      ),
      PackageData(
        title: 'Factory Cleaning',
        description:
        'Complete cleaning service for factories and industrial facilities.',
        amount: '800.00',
        count: '0',
        isAdd: false,
      ),
    ],
  ),

  MainCategoryPackageData(
    title: 'Deep Cleaning',
    isSelected: false,
    packageData: [
      PackageData(
        title: 'Full Home Deep Cleaning',
        description:
        'Detailed deep cleaning service for your entire home.',
        amount: '500.00',
        count: '0',
        isAdd: false,
      ),
      PackageData(
        title: 'Kitchen Deep Cleaning',
        description:
        'Thorough cleaning of kitchen surfaces, cabinets and appliances.',
        amount: '200.00',
        count: '0',
        isAdd: false,
      ),
    ],
  ),
];

class GridImage {
  final String imageURl;

  GridImage({required this.imageURl});
}



final List<GridImage> gridList = [
  GridImage(
    imageURl:
    'https://images.unsplash.com/photo-1581578731548-c64695cc6952?q=80&w=200&auto=format&fit=crop',
  ),
  GridImage(
    imageURl:
    'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?q=80&w=200&auto=format&fit=crop',
  ),
  GridImage(
    imageURl:
    'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?q=80&w=200&auto=format&fit=crop',
  ),
];