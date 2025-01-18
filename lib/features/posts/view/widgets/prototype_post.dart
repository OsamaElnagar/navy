import 'package:flutter/material.dart';
import 'package:navy/utils/gaps.dart';
import 'package:timeago/timeago.dart' as timeago;

class PrototypePost extends StatelessWidget {
  const PrototypePost({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=1',
                  ),
                ),
                gapW16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        timeago.format(DateTime.now()
                            .subtract(const Duration(minutes: 30))),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Just finished building an amazing Flutter app! 🚀 The community is incredible, and the widgets make everything so much easier. #FlutterDev #MobileApp',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          gapH16,
          Image.network(
            'https://picsum.photos/seed/flutter/800/400',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.favorite_border,
                  label: '1.2K',
                  onPressed: () {},
                ),
                _buildActionButton(
                  context,
                  icon: Icons.comment_outlined,
                  label: '234',
                  onPressed: () {},
                ),
                _buildActionButton(
                  context,
                  icon: Icons.share_outlined,
                  label: '46',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20),
            gapW8,
            Text(label),
          ],
        ),
      ),
    );
  }
}
