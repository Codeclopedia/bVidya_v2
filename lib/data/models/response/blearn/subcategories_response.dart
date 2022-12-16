class SubCategoriesResponse {
  final SubCategories? body;
  final String? status;
  final String? message;

  SubCategoriesResponse({
    this.body,
    this.message,
    this.status,
  });

  SubCategoriesResponse.fromJson(Map<String, dynamic> json)
      : body = SubCategories.fromJson(json['body']),
        status = json['status'],
        message = json['message'];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['body'] = body?.toJson();
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class SubCategories {
  final List<SubCategory>? subcategories;
  SubCategories({
    this.subcategories,
  });

  SubCategories.fromJson(Map<String, dynamic> json)
      : subcategories = List.from(json['subcategories'])
            .map((e) => SubCategory.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['subcategories'] = subcategories?.map((e) => e.toJson()).toList();
    return data;
  }
}

class SubCategory {
  SubCategory({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.userId,
    required this.description,
    required this.image,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
  });
  final int? id;
  final String? name;
  final int? categoryId;
  final int? userId;
  final String? description;
  final String? image;
  final String? slug;
  final String? createdAt;
  final String? updatedAt;

  SubCategory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        categoryId = json['category_id'],
        userId = json['user_id'],
        description = json['description'],
        image = json['image'],
        slug = json['slug'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category_id'] = categoryId;
    data['user_id'] = userId;
    data['description'] = description;
    data['image'] = image;
    data['slug'] = slug;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
