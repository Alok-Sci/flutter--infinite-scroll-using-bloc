class ProductResponseModel {
  List<Product>? products;
  int? total;
  int? skip;
  int? limit;

  ProductResponseModel({
    this.products,
    this.total,
    this.skip,
    this.limit,
  });

  ProductResponseModel.fromJson(Map<String, dynamic> json) {
    products = (json['products'] as List).map((v) => Product.fromJson(v)).toList();
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() => {
        'products': this.products?.map((v) => v.toJson()).toList(),
        'total': this.total,
        'skip': this.skip,
        'limit': this.limit,
      };
}

class Product {
  int? id;
  String? title;
  String? description;
  num? price;
  dynamic discountPercentage;
  dynamic rating;
  int? stock;
  String? brand;
  String? category;
  String? thumbnail;
  List<String>? images;

  Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.discountPercentage,
    this.rating,
    this.stock,
    this.brand,
    this.category,
    this.thumbnail,
    this.images,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    discountPercentage = json['discountPercentage'];
    rating = json['rating'];
    stock = json['stock'];
    brand = json['brand'];
    category = json['category'];
    thumbnail = json['thumbnail'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'title': this.title,
        'description': this.description,
        'price': this.price,
        'discountPercentage': this.discountPercentage,
        'rating': this.rating,
        'stock': this.stock,
        'brand': this.brand,
        'category': this.category,
        'thumbnail': this.thumbnail,
        'images': this.images
      };
}
