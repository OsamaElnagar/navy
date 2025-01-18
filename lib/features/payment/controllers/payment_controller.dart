import 'package:get/get.dart';
import 'package:navy/components/custom_snackbar.dart';
import '../../../services/payments/payment_service_interface.dart';

class PaymentController extends GetxController {
  final PaymentServiceInterface _paymentService =
      Get.find<PaymentServiceInterface>();

  @override
  void onInit() {
    super.onInit();
    initializePayment();
  }

  Future<void> initializePayment() async {
    await _paymentService.initialize();
  }

  Future<Map<String, dynamic>> processCardPayment(
    String amount,
  ) async {
    return await _paymentService.processPayment(
      amount: amount,
      paymentMethod: 'card',
      paymentData: {
        'context': Get.context,
        'onPayment': (response) {
          if (response.success) {
            customSnackBar(
              'Your payment has been processed successfully.',
              isError: false,
            );
          } else {
            customSnackBar('Your payment has failed. Please try again.');
          }
        },
      },
    );
  }

  Future<Map<String, dynamic>> processWalletPayment(
    String amount,
    String phoneNumber,
  ) async {
    return await _paymentService.processPayment(
      amount: amount,
      paymentMethod: 'wallet',
      paymentData: {
        'context': Get.context,
        'phoneNumber': phoneNumber,
        'onPayment': (response) {
          // Handle payment response
        },
      },
    );
  }

  Future<Map<String, dynamic>> processKioskPayment(
    String amount,
  ) async {
    return await _paymentService.processPayment(
      amount: amount,
      paymentMethod: 'kiosk',
      paymentData: {
        'context': Get.context,
        'onPayment': (response) {
          if (response.success) {
            customSnackBar(
              'Please pay at nearest Aman/Masary outlet using reference: ${response.billReference}',
              isError: false,
            );
          } else {
            customSnackBar(
                'Failed to generate kiosk payment. Please try again.');
          }
        },
      },
    );
  }
}
