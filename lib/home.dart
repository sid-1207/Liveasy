import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './verify.dart';
import 'package:sms_autofill/sms_autofill.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController phoneNumberController = TextEditingController();
  String phoneNumber;
  String status;
  String countryCode="+91";
  AuthCredential phoneAuthCredential;
  var _firebaseUser;
  String verificationId;
  String verif;
  int code;

  @override
  void initState() {
    super.initState();
    _getFirebaseUser();
    
  }
_getsign()async{
 final signcode = await SmsAutoFill().getAppSignature;
    print(signcode);
}
  Future<void> _getFirebaseUser() async {
    this._firebaseUser = await FirebaseAuth.instance.currentUser;
    setState(() {
      status =
          (_firebaseUser == null) ? 'Not Logged In\n' : 'Already LoggedIn\n';
    });
  }

  void _handleError(e) {
    print(e.message);
    setState(() {
      status += e.message + '\n';
    });
  }

  Future<void> _submitPhoneNumber(String cc) async {
    /// NOTE: Either append your phone number country code or add in the code itself
    phoneNumber ="+91 "+ phoneNumberController.text.toString().trim();
    print(phoneNumber);
    /// The below functions are the callbacks
    void verificationCompleted(AuthCredential phoneAuthCredential) {
      print('verificationCompleted');
      setState(() {
        status += 'verificationCompleted\n';
      });
      this.phoneAuthCredential = phoneAuthCredential;
      print(phoneAuthCredential);
    }

    void verificationFailed(FirebaseAuthException error) {
      print('verificationFailed');
      _handleError(error);
    }

    void codeSent(String verificationId, [int code]) {
      print('codeSent');
      this.verificationId = verificationId;
      print(verificationId);
      verif = verificationId;
      this.code = code;
      print(code.toString());
      setState(() {
        status += 'Code Sent\n';
      });
    Navigator.of(context).push(
        MaterialPageRoute(builder: (builder) => Verify(phoneNumber, verif)));
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');
      setState(() {
        status += 'codeAutoRetrievalTimeout\n';
      });
      print(verificationId);
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,

      ///  only reads in `milliseconds`
      timeout: Duration(milliseconds: 10000),

      //Verification Completed
      verificationCompleted: verificationCompleted,

      /// Called when the verification is failed
      verificationFailed: verificationFailed,

      /// called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent,

      /// After automatic code retrival `timeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); 
 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.fromLTRB(16, 100, 16, 0),
      child: Center(
        child: Column(
          children: [
            Text(
              "Please enter your mobile number",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              "You'll receive a 4 digit code to verify text",
              style: TextStyle(color: Colors.grey,fontSize: 16),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(width: 1),
              ),
              child: Row(
                children: [
                  CountryListPick(
                      pickerBuilder: (context, CountryCode countryCode) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              countryCode.flagUri,
                              package: 'country_list_pick',
                            ),
                            SizedBox(width: 10),
                            SizedBox(width: 10),
                            Text(
                              countryCode.dialCode,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            Text("-",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20))
                          ],
                        );
                      },
                      theme: CountryTheme(
                        isShowFlag: true,
                        isShowTitle: true,
                        isShowCode: true,
                        isDownIcon: true,
                        showEnglishName: true,
                      ),
                      initialSelection: '+91',
                      onChanged: (CountryCode code) {
                        countryCode=code.dialCode;
                        print(code.name);
                        print(code.code);
                        print(code.dialCode);
                        print(code.flagUri);
                      },
                      useUiOverlay: true,
                      useSafeArea: false),
                  Container(
                    padding: EdgeInsets.all(4),
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      controller: phoneNumberController,
                      onTap: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
                      ),
                      onChanged: (value) {},
                      keyboardType: TextInputType.number,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    _getsign();
                    _submitPhoneNumber(countryCode);
                  },
                  child: Text(
                    "CONTINUE",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.indigo[900])),
                ))
          ],
        ),
      ),
    ));
  }
}
