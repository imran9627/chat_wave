import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  OTPScreenState createState() => OTPScreenState();
}

class OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController1 = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();
  final TextEditingController _otpController5 = TextEditingController();
  final TextEditingController _otpController6 = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildOTPDigitField(1, _otpController1),
                  buildOTPDigitField(2, _otpController2),
                  buildOTPDigitField(3, _otpController3),
                  buildOTPDigitField(4, _otpController4),
                  buildOTPDigitField(5, _otpController5),
                  buildOTPDigitField(6, _otpController6),
                ],
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Validate OTP
                  String otp = '${_otpController1.text}${_otpController2.text}${_otpController3.text}${_otpController4.text}${_otpController5.text}$_otpController6';
                },
                child: Text('Verify'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOTPDigitField(int digitIndex, TextEditingController controller) {
    return SizedBox(
      width: 50.0,
      child: TextField(
        controller: controller,
        //focusNode: _otpFocusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (digitIndex < 6) {
              FocusScope.of(context).requestFocus(FocusNode());
              //_otpController.text = value;
              controller.text += value;
              print('.........Value......${controller.text}');
            } else {
              controller.text = value;
              FocusScope.of(context).requestFocus(FocusNode());
            }
          }
        },
      ),
    );
  }

}


