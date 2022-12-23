class CategoriesResponse {
  final Categories? body;
  final String? status;
  final String? message;

  CategoriesResponse({
    this.body,
    this.message,
    this.status,
  });

  CategoriesResponse.fromJson(Map<String, dynamic> json)
      : body = json['body']!=null?Categories.fromJson(json['body']):null,
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

class Categories {
  final List<Category>? categories;
  Categories({
    this.categories,
  });

  Categories.fromJson(Map<String, dynamic> json)
      : categories = List.from(json['categories'])
            .map((e) => Category.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['categories'] = categories?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Category {
  final int? id;
  final String? name;
  final String? slug;
  final String? image;
  final String? createdAt;
  final String? updatedAt;

  Category({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        slug = json['slug'],
        image = json['image'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
