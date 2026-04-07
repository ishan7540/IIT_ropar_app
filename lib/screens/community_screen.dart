import 'package:flutter/material.dart';
import 'package:aahar_app/theme.dart';
import 'package:aahar_app/models/community_post.dart';
import 'package:intl/intl.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<CommunityPost> _posts = CommunityPost.mockList();
  final _postController = TextEditingController();

  void _addPost() {
    if (_postController.text.trim().isEmpty) return;
    setState(() {
      _posts.insert(
        0,
        CommunityPost(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          authorName: 'Suresh Kumar',
          authorLocation: 'Varanasi, UP',
          content: _postController.text,
          likes: 0,
          comments: 0,
          timestamp: DateTime.now(),
        ),
      );
      _postController.clear();
    });
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Community / किसान समुदाय',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${_posts.length} posts • Farmer Connect',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
        itemCount: _posts.length,
        separatorBuilder: (_, a) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _buildPostCard(context, _posts[index]);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreatePostSheet(context),
        icon: const Icon(Icons.edit),
        label: const Text('Post'),
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, CommunityPost post) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.subtleShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Row
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor:
                    AppTheme.primaryContainer.withValues(alpha: 0.15),
                child: Text(
                  post.authorName[0],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 12, color: AppTheme.onSurfaceVariant),
                        const SizedBox(width: 2),
                        Text(
                          post.authorLocation,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTime(post.timestamp),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert,
                    color: AppTheme.onSurfaceVariant, size: 20),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Content
          Text(
            post.content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 14),

          // Action Row
          Row(
            children: [
              _buildActionButton(
                context,
                post.isLiked ? Icons.favorite : Icons.favorite_border,
                '${post.likes}',
                post.isLiked ? AppTheme.error : AppTheme.onSurfaceVariant,
                () {
                  setState(() {
                    post.isLiked = !post.isLiked;
                  });
                },
              ),
              const SizedBox(width: 20),
              _buildActionButton(
                context,
                Icons.chat_bubble_outline,
                '${post.comments}',
                AppTheme.onSurfaceVariant,
                () {},
              ),
              const SizedBox(width: 20),
              _buildActionButton(
                context,
                Icons.share_outlined,
                'Share',
                AppTheme.onSurfaceVariant,
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  void _showCreatePostSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Create Post / पोस्ट बनाएं',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _postController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText:
                    'Share with the community...\nसमुदाय के साथ साझा करें...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.image,
                      color: AppTheme.primaryContainer),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt,
                      color: AppTheme.primaryContainer),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ElevatedButton(
                    onPressed: _addPost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      minimumSize: const Size(100, 44),
                    ),
                    child: const Text('Post'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('MMM d').format(dt);
  }
}
