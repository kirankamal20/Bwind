import 'dart:math';
 
import 'package:distance_edu/Model/EmailResponse.dart';
import 'package:distance_edu/Model/Userbase.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Email {
  static Future<EmailResponse> sendMail(String email) async {
    if (await Userbase.isEmailRegistered(email)) {
      String username = 'mrkingmoradiya@gmail.com'; //Email
      String password = 'libvygktmttbftgv'; //App Password
      String otp = generateOTP();

      final smtpServer = gmail(username, password);

      final message = Message()
        ..from = Address(username, 'E-Learning')
        ..recipients.add(email)
        ..subject = 'Password Reset'
        // ..text = 'Your Bwind app reset password OTP is $OTP'
        ..html =
            "<h1>Password Reset</h1>\n<p>Your Elearning app reset password OTP is $otp</p>";
      try {
        final sendReport = await send(message, smtpServer);
        return EmailResponse(data: otp, msg: "Email Sent", code: true);
      } on MailerException catch (e) {
        print('Message not sent.');
        print(e);
        return EmailResponse(data: null, msg: "Somting is wrong", code: false);
      }
    } else {
      return EmailResponse(
          data: null, msg: "Email not registered", code: false);
    }
  }

  static String generateOTP() {
    var random = Random();
    int OTP = random.nextInt(900000) + 100000;
    return OTP.toString();
  }
}
