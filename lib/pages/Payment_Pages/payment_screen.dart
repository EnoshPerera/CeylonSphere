import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'consts.dart';
import 'services/stripe_service.dart';

class PopupOverlay extends StatelessWidget {
  final Widget child;
  final VoidCallback? onDismiss;

  const PopupOverlay({
    super.key,
    required this.child,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blurred background overlay
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
        ),
        // Animation for the popup appearance
        TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Center(child: child),
        ),
      ],
    );
  }
}

Future<bool?> showPaymentPopup(
    BuildContext context, {
      required double amount,
      required String currency,
      required String bookingReference,
      bool barrierDismissible = true,
    }) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (context) => PopupOverlay(
      onDismiss:
      barrierDismissible ? () => Navigator.of(context).pop(false) : null,
      child: PaymentDialog(
        amount: amount,
        currency: currency,
        bookingReference: bookingReference,
      ),
    ),
  );
}

class PaymentDialog extends StatefulWidget {
  final double amount;
  final String currency;
  final String bookingReference;

  const PaymentDialog({
    super.key,
    required this.amount,
    required this.currency,
    required this.bookingReference,
  });

  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 400),
        padding: EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 30.0,
              spreadRadius: 1.0,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Details',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade800,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  splashRadius: 24,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildInfoRow('Booking Reference', widget.bookingReference),
            SizedBox(height: 12),
            _buildInfoRow(
                'Amount to Pay', '\$${widget.amount.toStringAsFixed(2)}'),
            SizedBox(height: 24),
            _buildPayButton(),
            SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock, size: 16, color: Colors.grey.shade700),
                  SizedBox(width: 6),
                  Text(
                    'Secured by Stripe',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayButton() {
    return ElevatedButton(
      onPressed: _handlePayment,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 56),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
      ),
      child: Text(
        'Pay Now',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _handlePayment() async {
    try {

      // Close the popup dialog after 5 seconds
      Navigator.of(context).pop();

      // Step 1: Process payment with Stripe service
      final paymentResult = await StripeService.instance.makePayment(
        amount: widget.amount,
        currency: widget.currency,
      );

      // Step 2: Save payment details to backend (Firestore or your backend)
      await _savePaymentToBackend(
          widget.bookingReference,
          widget.amount,
          widget.currency,
          paymentResult['paymentIntentId'],
          paymentResult['status']);

      // Step 3: Navigate to the map page after successful payment
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      // If payment fails, navigate to the map page
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  // Save payment details to backend (Firestore or your backend)
  Future<void> _savePaymentToBackend(String bookingReference, double amount,
      String currency, String paymentIntentId, String status) async {
    try {
      final firestore = FirebaseFirestore.instance;

      final paymentDetails = {
        'bookingReference': bookingReference,
        'amount': amount,
        'currency': currency,
        'status': status,
        'paymentIntentId': paymentIntentId,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await firestore
          .collection('payments')
          .doc(bookingReference)
          .set(paymentDetails);
    } catch (e) {
      throw Exception("Failed to save payment details to backend");
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}