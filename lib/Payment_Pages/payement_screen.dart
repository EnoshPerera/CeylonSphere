import 'package:flutter/material.dart';
import 'services/stripe_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String currency;
  final String bookingReference;

  const PaymentScreen({
    super.key,
    required this.amount,
    required this.currency,
    required this.bookingReference,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;
  String _paymentStatus = '';

  Future<void> _handlePayment() async {
    setState(() {
      _isProcessing = true;
      _paymentStatus = 'Processing payment...';
    });

    try {
      // Process payment with Stripe service
      await StripeService.instance.makePayment(
        amount: widget.amount,
        currency: widget.currency,
        bookingReference: widget.bookingReference,
      );

      setState(() {
        _paymentStatus = 'Payment successful!';
      });

      // Add a small delay to show success message
      await Future.delayed(const Duration(seconds: 1));

      // Return true to indicate payment success
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _paymentStatus = 'Payment failed: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Payment'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Reference: ${widget.bookingReference}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Amount to Pay: \$${widget.amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This is a 50% deposit to confirm your booking.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              'Payment Information:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '• You will be redirected to a secure payment page\n• All payment data is encrypted and secure\n• You will receive a receipt via email',
              style: TextStyle(fontSize: 14),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isProcessing ? null : _handlePayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : const Text('Pay Now', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 16),
            if (_paymentStatus.isNotEmpty)
              Text(
                _paymentStatus,
                style: TextStyle(
                  color: _paymentStatus.contains('successful')
                      ? Colors.green
                      : _paymentStatus.contains('Processing')
                          ? Colors.blue
                          : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
