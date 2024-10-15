class CourseModel {
  final String image;
  final String title;
  final double rating;
  final String duration;
  final String price;

  CourseModel({
    required this.image,
    required this.title,
    required this.rating,
    required this.duration,
    required this.price,
  });

  static final List<CourseModel> courses = [
    CourseModel(
      image: 'images/programming.jpg',
      title: 'Programming',
      rating: 4.8,
      duration: '6 - 12months',
      price: '\$324.00',
    ),
    CourseModel(
      image: 'images/web.jpg',
      title: 'Web Development',
      rating: 4.7,
      duration: '6 - 12months',
      price: '\$324.00',
    ),
    CourseModel(
      image: 'images/networking.jpg',
      title: 'Computer Networking)',
      rating: 4.9,
      duration: '6 - 12months',
      price: '\$299.00',
    ),
  ];
}
