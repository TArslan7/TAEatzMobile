import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/search_result_entity.dart';

part 'search_result_model.g.dart';

@JsonSerializable()
class SearchResultModel {
  final String id;
  final String title;
  final String subtitle;
  final String? imageUrl;
  @JsonKey(name: 'type')
  final String typeString;
  final Map<String, dynamic> metadata;
  final double? rating;
  final String? price;
  final List<String> tags;

  const SearchResultModel({
    required this.id,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    required this.typeString,
    this.metadata = const {},
    this.rating,
    this.price,
    this.tags = const [],
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultModelToJson(this);

  SearchResultEntity toEntity() {
    return SearchResultEntity(
      id: id,
      title: title,
      subtitle: subtitle,
      imageUrl: imageUrl,
      type: _stringToSearchResultType(typeString),
      metadata: metadata,
      rating: rating,
      price: price,
      tags: tags,
    );
  }

  SearchResultType _stringToSearchResultType(String type) {
    switch (type.toLowerCase()) {
      case 'restaurant':
        return SearchResultType.restaurant;
      case 'menu_item':
        return SearchResultType.menuItem;
      default:
        return SearchResultType.restaurant;
    }
  }

  factory SearchResultModel.fromEntity(SearchResultEntity entity) {
    return SearchResultModel(
      id: entity.id,
      title: entity.title,
      subtitle: entity.subtitle,
      imageUrl: entity.imageUrl,
      typeString: _searchResultTypeToString(entity.type),
      metadata: entity.metadata,
      rating: entity.rating,
      price: entity.price,
      tags: entity.tags,
    );
  }

  static String _searchResultTypeToString(SearchResultType type) {
    switch (type) {
      case SearchResultType.restaurant:
        return 'restaurant';
      case SearchResultType.menuItem:
        return 'menu_item';
    }
  }
}
