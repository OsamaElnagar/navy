import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/components/common_container.dart';
import 'package:navy/utils/gaps.dart';
import 'package:shimmer/shimmer.dart';

class GeneralInfoShimmer extends StatelessWidget {
  const GeneralInfoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      width: Get.width,
      height: Get.height,
      hasDecoImage: false,
      alignment: Alignment.center,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar shimmer
            Container(
              width: 170,
              height: 170,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            gapH8,
            // Name shimmer
            Container(
              width: 150,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            gapH8,
            // Bio shimmer
            Container(
              width: 200,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            gapH16,
            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                3,
                (index) => _buildStatColumnShimmer(),
              ),
            ),
            gapH16,
            // User details expansion shimmer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumnShimmer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        gapH4,
        Container(
          width: 60,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
