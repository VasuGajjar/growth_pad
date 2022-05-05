import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  static final _razorpay = Razorpay();
  // TODO: razorpay credentials are required
  static const RAZOR_PAY_KEY_ID = '';
  static const RAZOR_PAY_SECRET_KEY = '';

  static Future<void> present({
    required double amount,
    required String name,
    required String description,
    required void Function(PaymentSuccessResponse response) onPaymentSuccess,
    required void Function(PaymentFailureResponse response) onPaymentError,
    required void Function(ExternalWalletResponse response) onExternalWallet,
  }) async {
    var options = {
      'key': RAZOR_PAY_KEY_ID,
      'amount': amount * 100,
      'name': name,
      'description': description,
      // 'transfers': [
      //   {
      //     'account': account,
      //     'amount': amount * 100,
      //   },
      // ],
    };

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
      _razorpay.clear();
      onPaymentSuccess(response);
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (response) {
      _razorpay.clear();
      onPaymentError(response);
    });
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (response) {
      _razorpay.clear();
      onExternalWallet(response);
    });

    _razorpay.open(options);
  }
}
