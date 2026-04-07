class CommunityPost {
  final String id;
  final String authorName;
  final String authorLocation;
  final String content;
  final String? imageUrl;
  final int likes;
  final int comments;
  final DateTime timestamp;
  bool isLiked;

  CommunityPost({
    required this.id,
    required this.authorName,
    required this.authorLocation,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.timestamp,
    this.isLiked = false,
  });

  static List<CommunityPost> mockList() {
    return [
      CommunityPost(
        id: '1',
        authorName: 'Ramesh Yadav',
        authorLocation: 'Lucknow, UP',
        content:
            'My wheat yield increased by 20% after following NPK recommendations from Aahar! 🌾\nआहार की NPK सिफारिशों का पालन करने के बाद मेरी गेहूं की पैदावार 20% बढ़ गई!',
        likes: 24,
        comments: 8,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      CommunityPost(
        id: '2',
        authorName: 'Priya Sharma',
        authorLocation: 'Jaipur, Rajasthan',
        content:
            'Can anyone suggest the best time to apply DAP for mustard crop? Need advice.\nक्या कोई सरसों की फसल के लिए DAP डालने का सबसे अच्छा समय बता सकता है?',
        likes: 12,
        comments: 15,
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      CommunityPost(
        id: '3',
        authorName: 'Mohan Patel',
        authorLocation: 'Bhopal, MP',
        content:
            'Heavy rain damaged my soybean field. Government subsidy info would help.\nभारी बारिश से मेरे सोयाबीन का खेत खराब हो गया। सरकारी सब्सिडी की जानकारी से मदद मिलेगी।',
        likes: 45,
        comments: 22,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      CommunityPost(
        id: '4',
        authorName: 'Anita Devi',
        authorLocation: 'Patna, Bihar',
        content:
            'Tried bio-mulching as suggested in the alerts. Soil moisture improved significantly! 💧\nअलर्ट में सुझाए गए बायो-मल्चिंग को आजमाया। मिट्टी की नमी में काफी सुधार हुआ!',
        likes: 31,
        comments: 5,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }
}
