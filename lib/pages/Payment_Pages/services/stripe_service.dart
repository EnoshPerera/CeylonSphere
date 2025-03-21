import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import '../consts.dart';

class StripeService {
  // Singleton pattern
  StripeService._(); // Private constructor
  static final StripeService instance = StripeService._();

  Future<void> makePayment({
    required double amount,
    required String currency,
  }) async {
    try {
      print('Creating payment intent...');
      final String? paymentIntentClientSecret = await _createPaymentIntent(
        amount: amount,
        currency: currency,
      );

      if (paymentIntentClientSecret == null) {
        print('Failed to create payment intent');
        throw Exception('Failed to create payment intent');
      }

      print('Initializing payment sheet...');
      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: 'Ceylon Sphere',
        ),
      );

      print('Presenting payment sheet...');
      await stripe.Stripe.instance.presentPaymentSheet();

      print('Confirming payment...');
      await stripe.Stripe.instance.confirmPaymentSheetPayment();

      print('Payment successful!');
    } on stripe.StripeException catch (e) {
      print('Stripe Error: ${e.error.localizedMessage}');
      rethrow;
    } catch (e) {
      print('Unexpected Error: $e');
      rethrow;
    }
  }

  Future<String?> _createPaymentIntent({
    required double amount,
    required String currency,
  }) async {
    try {
      final dio = Dio();

      final Map<String, dynamic> data = {
        'amount': _calculateAmount(amount),
        'currency': currency,
      };

      final response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.data != null) {
        print('Payment Intent Created: ${response.data}');
        return response.data['client_secret'];
      }
      return null;
    } catch (error) {
      print('Error creating payment intent: $error');
      return null;
    }
  }

  // Helper method to convert amount to cents
  String _calculateAmount(double amount) {
    final calculatedAmount = (amount * 100).toInt();
    return calculatedAmount.toString();
  }
}