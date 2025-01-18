abstract class PaymentServiceInterface {
  Future<void> initialize();

  Future<Map<String, dynamic>> processPayment({
    required String amount,
    required String paymentMethod,
    required Map<String, dynamic> paymentData,
  });

  Future<Map<String, dynamic>> getTransactionStatus(String transactionId);
}
