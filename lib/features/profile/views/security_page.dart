import 'package:flutter/material.dart';
import 'package:navy/components/common_container.dart';
import 'package:navy/components/widgets/section_title.dart';
import 'package:navy/features/profile/views/profile_page.dart';

import '../../../utils/gaps.dart';
import '../../../utils/responsive.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!Responsive.isMobile(context)) 25.h,
        Text(
          "Account Security",
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        gapH20,
        const CommonContainer(
          child: Column(
            children: [
              SectionTitle(title: 'Reset Your Password'),
              gapH16,
              TextFormFieldComponent(label: 'Old Password'),
              gapH8,
              TextFormFieldComponent(label: 'New Password'),
              gapH8,
              TextFormFieldComponent(label: 'Confirm New Password'),
              gapH8,
            ],
          ),
        ),
        gapH24,
        gapH24,
        CommonContainer(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                child: const Text('Discard Changes',
                    style: TextStyle(color: Colors.red)),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child:
                    const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
