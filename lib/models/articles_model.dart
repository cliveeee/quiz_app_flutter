class ArticleModel {
  final String image;
  final String title;
  final String readingtime;
  final String timeposted;
  final String comments;

  ArticleModel({
    required this.image,
    required this.title,
    required this.readingtime,
    required this.timeposted,
    required this.comments,
  });

  static final List<ArticleModel> articles = [
    ArticleModel(
      image: 'images/campus.jpg',
      title:
          'A Day in the Life at North Metropolitan TAFE: Student Experiences',
      readingtime: '6 min read',
      timeposted: '3 days ago',
      comments: '25',
    ),
    ArticleModel(
      image: 'images/it_class.jpg',
      title: 'Top 5 IT Courses to Study at North Metropolitan TAFE in 2024',
      readingtime: '7 min read',
      timeposted: '1 week ago',
      comments: '15',
    ),
    ArticleModel(
      image: 'images/graduation.jpg',
      title:
          'Success Stories: How North Metropolitan TAFE Grads Are Shaping the Tech Industry',
      readingtime: '8 min read',
      timeposted: '2 weeks ago',
      comments: '30',
    ),
    ArticleModel(
      image: 'images/campus_tour.jpg',
      title:
          'Exploring North Metropolitan TAFE: A Campus Tour for New Students',
      readingtime: '4 min read',
      timeposted: '5 hours ago',
      comments: '12',
    ),
  ];
}
