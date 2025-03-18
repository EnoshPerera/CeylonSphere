import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'consts.dart'; // Ensure you have the Stripe keys here
import 'services/stripe_service.dart'; // Use the StripeService class from earlier

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String currency;
  final String bookingReference;

  const PaymentScreen({
    Key? key,
    required this.amount,
    required this.currency,
    required this.bookingReference,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;
  String _paymentStatus = '';

  Future<void> _handlePayment() async {
    setState(() {
      _isProcessing = true;
      _paymentStatus = 'Processing...';
    });

    try {
      // Process payment with Stripe service
      await StripeService.instance.makePayment(
        amount: widget.amount,
        currency: widget.currency,
      );

      setState(() {
        _paymentStatus = 'Payment successful!';
      });

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
        title: Text('Payment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Reference: ${widget.bookingReference}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Amount to Pay: \$${widget.amount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isProcessing ? null : _handlePayment,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: _isProcessing
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Pay Now'),
            ),
            SizedBox(height: 16),
            if (_paymentStatus.isNotEmpty)
              Text(
                _paymentStatus,
                style: TextStyle(
                  color: _paymentStatus.contains('successful')
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}