import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiURL = '${StripeService.apiBase}/payment_intents';
  static String secret =
      'sk_test_51IOn9nG14A2ptjflIARjyaeYBe85a4Q3twRrODX9ZJ9jdWclUIr9F8jA33Dv8j2SOv1O4U2mXvsEMNmpYXZuU8uP002hoGOIuv';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-type': 'application/x-www-form-urlencoded',
  };

  static init() {
    StripePayment.setOptions(
      StripeOptions(
          publishableKey:
              "pk_test_51IOn9nG14A2ptjfl4T79pZ0YIve0zZaYoOjRANGgbDydxr6NH4UEmojoZg9j4tI1US1xlL0BVMJ4XvrHfid4zJ3r008Q5fTYM7",
          merchantId: 'Test',
          androidPayMode: 'test'),
    );
  }

  static Future<StripeTransactionResponse> payViaExistingCard(
      {String amount, String currency, CreditCard card}) async {
    try {
      var paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card));
      var paymentIntent =
          await StripeService.createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (response.status == 'succeded') {
        return new StripeTransactionResponse(
          message: 'Transaction succesful',
          success: true,
        );
      } else {
        return new StripeTransactionResponse(
          message: 'Transaction succesful',
          success: true,
        );
      }
    } on PlatformException catch (e) {
      return StripeService.getPlatformExceptionErrorResult(e);
    } catch (e) {
      return new StripeTransactionResponse(
        message: 'Transaction failed: ${e.toString()}',
        success: false,
      );
    }
  }

  static Future<StripeTransactionResponse> payViaNewCard(
      {String amount, String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var paymentIntent =
          await StripeService.createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (response.status == 'succeded') {
        return new StripeTransactionResponse(
          message: 'Transaction succesful',
          success: true,
        );
      } else {
        return new StripeTransactionResponse(
          message: 'Transaction succesful',
          success: true,
        );
      }
    } on PlatformException catch (e) {
      return StripeService.getPlatformExceptionErrorResult(e);
    } catch (e) {
      return new StripeTransactionResponse(
        message: 'Transaction failed: ${e.toString()}',
        success: false,
      );
    }
  }

  static getPlatformExceptionErrorResult(e) {
    String message = 'Something went wrong';
    if (e.code == 'cancelled') {
      message = 'Transaction cancelled';
    }
    return new StripeTransactionResponse(message: message, success: false);
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
        StripeService.paymentApiURL,
        body: body,
        headers: StripeService.headers,
      );
      return jsonDecode(response.body);
    } catch (e) {}
    return null;
  }
}
