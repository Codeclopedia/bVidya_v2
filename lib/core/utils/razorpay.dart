import 'package:dio/dio.dart';

import '../../data/models/response/profile/payment_success_response.dart';
import '../../data/network/dio_services.dart';
import '../constants.dart';
import '../utils.dart';

Future<PaymentSuccessModel> getpaymentSuccessDetails(
    String orderId, String paymentId, String signature) async {
  Dio _dio = DioServices.instance.dio;

  final user = await getMeAsUser();

  _dio.options.headers['X-Auth-Token'] = user?.authToken;
  final data = {
    'razorpay_order_id': orderId,
    'razorpay_payment_id': paymentId,
    'razorpay_signature': signature
  };

  try {
    final response =
        await _dio.post(baseUrlApi + ApiList.getpaymentRecord, data: data);

    if (response.statusCode == 200) {
      return PaymentSuccessModel.fromJson(response.data);
    } else {
      return PaymentSuccessModel(
        status: 'error',
      );
    }
  } catch (e) {
    print("error $e");
    return PaymentSuccessModel(status: 'error');
  }
}

// handlePaymentSuccess(PaymentSuccessResponse response, WidgetRef ref) {
//   final data = {
//     'orderId': response.orderId,
//     'paymentId': response.paymentId,
//     'signature': response.signature
//   };
//   // print("response from successful payment $response");
//   final res = ref.read(paymentSuccessProvider(data));
// }

// handlePaymentError(PaymentFailureResponse response) {
//   print(response.message);
// }

// handleExternalWallet(ExternalWalletResponse response) {
//   print(response);
// }
