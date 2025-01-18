import 'dart:developer';

import 'package:easy_paymob/easy_payment.dart';
import 'package:flutter/material.dart';
import '../../utils/app_constants.dart';
import './payment_service_interface.dart';

class PaymobService implements PaymentServiceInterface {
  final EasyPaymob _paymentClient = EasyPaymob.instance;

  @override
  Future<void> initialize() async {
    log('Start Easy paymob initialize');

    await _paymentClient.initialize(
      apiKey: PaymentConfig.paymobApiKey,
      integrationCardID: PaymentConfig.paymobCardIntegrationId,
      integrationCashID: PaymentConfig.paymobWalletIntegrationId,
      integrationKioskID: PaymentConfig.paymobKioskIntegrationId,
      iFrameID: PaymentConfig.paymobIframeId,
    );
    log('End Easy paymob initialize');
  }

  @override
  Future<Map<String, dynamic>> processPayment({
    required String amount,
    required String paymentMethod,
    required Map<String, dynamic> paymentData,
  }) async {
    EasyPaymobResponse? response;

    switch (paymentMethod) {
      case 'card':
        response = await _processCardPayment(amount, paymentData);
        break;
      case 'wallet':
        response = await _processWalletPayment(amount, paymentData);
        break;
      case 'kiosk':
        response = await _processKioskPayment(amount, paymentData);
        break;
      default:
        throw Exception('Unsupported payment method');
    }

    return _formatResponse(response);
  }

  @override
  Future<Map<String, dynamic>> getTransactionStatus(
      String transactionId) async {
    final response = await _paymentClient.getTransactionStatus(
      transactionId: transactionId,
    );
    return _formatResponse(response);
  }

  Future<EasyPaymobResponse?> _processCardPayment(
    String amount,
    Map<String, dynamic> paymentData,
  ) async {
    return await _paymentClient.payWithCard(
      context: paymentData['context'] as BuildContext,
      amountInCents: amount,
      onPayment: paymentData['onPayment'],
    );
  }

  Future<EasyPaymobResponse?> _processWalletPayment(
    String amount,
    Map<String, dynamic> paymentData,
  ) async {
    return await _paymentClient.payWithWallet(
      context: paymentData['context'] as BuildContext,
      amountInCents: amount,
      phoneNumber: paymentData['phoneNumber'] as String,
      onPayment: paymentData['onPayment'],
    );
  }

  Future<EasyPaymobResponse?> _processKioskPayment(
    String amount,
    Map<String, dynamic> paymentData,
  ) async {
    return await _paymentClient.payWithKiosk(
      amountInCents: amount,
      onPayment: paymentData['onPayment'],
    );
  }

  Map<String, dynamic> _formatResponse(EasyPaymobResponse? response) {
    if (response == null) {
      return {
        'success': false,
        'message': 'Payment processing failed',
      };
    }

    return {
      'success': response.success,
      'pending': response.pending,
      'transactionId': response.transactionID,
      'responseCode': response.responseCode,
      'message': response.message,
      'type': response.type,
      'billReference': response.billReference,
    };
  }
}
