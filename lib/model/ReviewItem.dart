class ReviewItem {
  final int id;
  final String userName;
  final String userImage;
  final double rating;
  final String comment;
  final String date;

  ReviewItem({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory ReviewItem.fromJson(Map<String, dynamic> json) {
    return ReviewItem(
      id: json['id'] ?? 0,
      userName: json['user_name'] ?? json['name'] ?? '',
      userImage: json['user_image'] ?? json['profile_image'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? json['review'] ?? '',
      date: json['date'] ?? json['created_at'] ?? '',
    );
  }
}

class ProviderReviewResponse {
  final List<ReviewItem> reviews;
  final int currentPage;
  final int totalPages;
  final int totalReviews;

  ProviderReviewResponse({
    required this.reviews,
    required this.currentPage,
    required this.totalPages,
    required this.totalReviews,
  });

  factory ProviderReviewResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final List list = data['reviews'] ?? data['data'] ?? [];

    return ProviderReviewResponse(
      reviews: list.map((e) => ReviewItem.fromJson(e)).toList(),
      currentPage: data['current_page'] ?? data['page'] ?? 1,
      totalPages: data['total_pages'] ?? data['last_page'] ?? 1,
      totalReviews: data['total'] ?? data['total_reviews'] ?? list.length,
    );
  }
}