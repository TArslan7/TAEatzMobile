import 'package:equatable/equatable.dart';

enum SearchResultType { restaurant, menuItem }

class SearchResultEntity extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String? imageUrl;
  final SearchResultType type;
  final Map<String, dynamic> metadata;
  final double? rating;
  final String? price;
  final List<String> tags;

  const SearchResultEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    required this.type,
    this.metadata = const {},
    this.rating,
    this.price,
    this.tags = const [],
  });

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        imageUrl,
        type,
        metadata,
        rating,
        price,
        tags,
      ];

  SearchResultEntity copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? imageUrl,
    SearchResultType? type,
    Map<String, dynamic>? metadata,
    double? rating,
    String? price,
    List<String>? tags,
  }) {
    return SearchResultEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      tags: tags ?? this.tags,
    );
  }
}
