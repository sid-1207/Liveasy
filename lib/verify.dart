import 'package:flutter/material.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './selection.dart';

class Verify extends StatefulWidget {
  String phoneNumber;
  String verificationId;
  Verify(this.phoneNumber, this.verificationId);
  static const routeName = 'verify';
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  String otp;
  int code;
  String verif;
  String verificationId;
  AuthCredential phoneAuthCredential;
  var _firebaseUser;
  String status;
  @override
  void initState() {
    super.initState();
    _getFirebaseUser();
  }

  void _handleError(e) {
    print(e.message);
    setState(() {
      status += e.message + '\n';
    });
  }

  Future<void> _getFirebaseUser() async {
    this._firebaseUser = await FirebaseAuth.instance.currentUser;
    setState(() {
      status =
          (_firebaseUser == null) ? 'Not Logged In\n' : 'Already LoggedIn\n';
    });
  }

  Future<void> _login() async {
    /// `AuthCredential`(`phoneAuthCredential`) is needed for the signIn method
    /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
    try {
      await FirebaseAuth.instance
          .signInWithCredential(this.phoneAuthCredential)
          .then((UserCredential authRes) {
        print(authRes);
        _firebaseUser = authRes.user;
        print(_firebaseUser.toString());
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (builder) => Selection()));
      }).catchError((e) => _handleError(e));
      setState(() {
        status += 'Signed In\n';
      });
    } catch (e) {
      _handleError(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(
            height: 20,
            child: Center(
                child: Text(
              "Invalid",
              style: TextStyle(color: Colors.white),
            ))),
        backgroundColor: Colors.black,
      ));
    }
  }

  void _submitOTP(String otp) {
    String smsCode = otp;
    this.phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: smsCode);
    _login();
  }


   Future<void> _submitPhoneNumber(String cc) async {
    /// Either append your phone number country code or add in the code itself
    String phoneNumber = widget.phoneNumber;
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
    Navigator.of(context).pushReplacement(
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

      /// only reads in `milliseconds`
      timeout: Duration(milliseconds: 10000),

    //verification completed
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
              "Verify Phone",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Code is sent to ${widget.phoneNumber}",
              style: TextStyle(color: Colors.grey[800], fontSize: 16),
            ),
            SizedBox(
              height: 30,
            ),
            PinEntryTextField(
              fields: 6,
              showFieldAsBox: true,
              onSubmit: (String pin) {
                otp = pin;
                print(otp);
              },
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive the code? ",
                  style: TextStyle(color: Colors.grey[800], fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Request Again",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    _submitOTP(otp);
                  },
                  child: Text(
                    "VERIFY AND CONTINUE",
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
