import 'package:flutter/material.dart';

class CustomStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final List<String> labels;

  const CustomStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onPrevious,
    this.onNext,
    this.labels = const ['Personal Info', 'Credentials', 'Additional Info'],
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Card(
        elevation: 4,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalSteps * 2 - 1, (index) {
              // If index is even, render step circle
              if (index % 2 == 0) {
                final stepIndex = index ~/ 2;
                final bool isActive = stepIndex <= currentStep;
                final bool isCompleted = stepIndex < currentStep;
                final bool canNavigate = stepIndex != currentStep;

                return Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: canNavigate
                            ? () {
                                if (stepIndex < currentStep) {
                                  onPrevious?.call();
                                } else if (stepIndex > currentStep) {
                                  onNext?.call();
                                }
                              }
                            : null,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isActive ? Colors.blue : Colors.grey.shade300,
                            border: Border.all(
                              color:
                                  isActive ? Colors.blue : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: isCompleted
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : Text(
                                    '${stepIndex + 1}',
                                    style: TextStyle(
                                      color: isActive
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        labels[stepIndex],
                        style: TextStyle(
                          color: isActive ? Colors.blue : Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }
              // If index is odd, render connecting line
              return Expanded(
                child: Container(
                  height: 2,
                  color: index ~/ 2 < currentStep
                      ? Colors.blue
                      : Colors.grey.shade300,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
