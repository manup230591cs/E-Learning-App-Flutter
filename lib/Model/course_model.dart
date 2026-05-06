class CourseModel {
  final String? id;
  final String cover;
  final String duration;
  final List<String> instructors;
  final String title;
  final String description;
  final double price;

  CourseModel({
    this.id,
    required this.cover,
    required this.duration,
    required this.instructors,
    required this.title,
    this.description = 'No description available', // Default value
    this.price = 0.0, // Default value
  });

  String get documentId {
    final trimmedId = id?.trim();
    if (trimmedId != null && trimmedId.isNotEmpty) {
      return trimmedId;
    }

    final titleId = title
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');

    return titleId.isNotEmpty ? titleId : 'course';
  }

  // fromJSON constructor with default values
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final instructorValue = json['instructor'] ?? json['instructors'];
    List<String> parsedInstructors;

    if (instructorValue is List) {
      parsedInstructors =
          instructorValue.map((item) => item.toString()).toList();
    } else if (instructorValue is String && instructorValue.trim().isNotEmpty) {
      parsedInstructors =
          instructorValue.split(',').map((item) => item.trim()).toList();
    } else {
      parsedInstructors = const ['Instructor'];
    }

    parsedInstructors = parsedInstructors
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
    if (parsedInstructors.isEmpty) {
      parsedInstructors = const ['Instructor'];
    }

    final priceValue = json['price'];
    final double parsedPrice;

    if (priceValue is num) {
      parsedPrice = priceValue.toDouble();
    } else if (priceValue is String) {
      parsedPrice =
          double.tryParse(priceValue.replaceAll(RegExp(r'[^0-9.]'), '')) ??
              0.0;
    } else {
      parsedPrice = 0.0;
    }

    return CourseModel(
      id: json['id']?.toString(),
      cover: json['cover']?.toString() ?? '',
      duration: json['duration']?.toString() ?? 'Self paced',
      instructors: parsedInstructors,
      title: json['title']?.toString() ?? 'Untitled Course',
      description: json['description']?.toString() ??
          'No description available', // Default value
      price: parsedPrice,
    );
  }

  // toJSON method for converting the object back to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cover': cover,
      'duration': duration,
      'instructor': instructors,
      'title': title,
      'description': description,
      'price': price,
    };
  }
}
