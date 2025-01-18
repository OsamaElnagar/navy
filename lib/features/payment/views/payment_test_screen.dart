import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payment_controller.dart';

class PaymentTestScreen extends GetView<PaymentController> {
  PaymentTestScreen({super.key});

  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Test'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Demo Product Card
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Demo Product',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Price: EGP 100',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'This is a demo product to test different payment methods.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Payment Methods Section
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Card Payment Button
            ElevatedButton.icon(
              onPressed: _processCardPayment,
              icon: const Icon(Icons.credit_card),
              label: const Text('Pay with Card'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 12),

            // Wallet Payment Section
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number (for wallet payment)',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _processWalletPayment,
              icon: const Icon(Icons.account_balance_wallet),
              label: const Text('Pay with Wallet'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 12),

            // Kiosk Payment Button
            ElevatedButton.icon(
              onPressed: _processKioskPayment,
              icon: const Icon(Icons.store),
              label: const Text('Pay at Kiosk'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processCardPayment() async {
    try {
      await controller.processCardPayment(
        '10000', // Amount in cents (EGP 100)
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to process card payment: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _processWalletPayment() async {
    if (_phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a phone number',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      await controller.processWalletPayment(
        '10000', // Amount in cents (EGP 100)
        _phoneController.text,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to process wallet payment: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _processKioskPayment() async {
    try {
      await controller.processKioskPayment(
        '10000', // Amount in cents (EGP 100)
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to process kiosk payment: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
