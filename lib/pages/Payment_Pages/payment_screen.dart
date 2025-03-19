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
    Key? key,
    required this.child,
    this.onDismiss,
  }) : super(key: key);

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
      onDismiss: barrierDismissible ? () => Navigator.of(context).pop(false) : null,
      child: PaymentDialog(
        amount: amount,
        currency: currency,
        bookingReference: bookingReference,
      ),
    ),
  );
}

enum PaymentState {
  initial,
  processing,
  success,
  failure
}

class PaymentDialog extends StatefulWidget {
  final double amount;
  final String currency;
  final String bookingReference;

  const PaymentDialog({
    Key? key,
    required this.amount,
    required this.currency,
    required this.bookingReference,
  }) : super(key: key);

  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> with SingleTickerProviderStateMixin {
  PaymentState _paymentState = PaymentState.initial;
  String _errorMessage = '';
  Timer? _autoCloseTimer;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handlePayment() async {
    // Guard against multiple taps
    if (_paymentState == PaymentState.processing) return;

    setState(() {
      _paymentState = PaymentState.processing;
    });

    try {
      // Simulate network delay
      await Future.delayed(Duration(seconds: 2));

      // Process payment with Stripe service
      await StripeService.instance.makePayment(
        amount: widget.amount,
        currency: widget.currency,
      );

      // Check if widget is still mounted before updating state
      if (!mounted) return;

      setState(() {
        _paymentState = PaymentState.success;
      });

      // Auto-close after success
      _autoCloseTimer = Timer(Duration(milliseconds: 1800), () {
        if (mounted) {
          _closeWithAnimation(true);
        }
      });
    } catch (e) {
      // Check if widget is still mounted before updating state
      if (!mounted) return;

      setState(() {
        _paymentState = PaymentState.failure;
        _errorMessage = e.toString();
      });
    }
  }

  void _closeWithAnimation(bool result) {
    _animationController.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Material(
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
                  if (_paymentState != PaymentState.processing)
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.grey),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      splashRadius: 24,
                      onPressed: () => _closeWithAnimation(false),
                    ),
                ],
              ),
              SizedBox(height: 16),
              _buildInfoRow('Booking Reference', widget.bookingReference),
              SizedBox(height: 12),
              _buildInfoRow('Amount to Pay', '\$${widget.amount.toStringAsFixed(2)}'),
              SizedBox(height: 24),

              // Payment Action Button or Status
              if (_paymentState == PaymentState.initial)
                _buildPayButton(),
              if (_paymentState == PaymentState.processing)
                _buildProcessingState(),
              if (_paymentState == PaymentState.success)
                _buildSuccessState(),
              if (_paymentState == PaymentState.failure)
                _buildFailureState(),

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

  Widget _buildProcessingState() {
    return Container(
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade700),
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Processing...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    return Container(
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 12),
            Text(
              'Payment Successful',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFailureState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 12),
                Text(
                  'Payment Failed',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorMessage,
              style: TextStyle(color: Colors.red.shade800, fontSize: 14),
            ),
          ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _handlePayment,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 48),
            backgroundColor: Colors.grey.shade200,
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text('Try Again'),
        ),
      ],
    );
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