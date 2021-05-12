import 'package:flutter/material.dart';
import './home.dart';

class LanguageSelect extends StatefulWidget {
  @override
  _LanguageSelectState createState() => _LanguageSelectState();
}

class _LanguageSelectState extends State<LanguageSelect> {
  String dropdownValue = 'English';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(64, 100, 64,100),
          child: Column(
            children: [
              Text(
                "Please select your language",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                "You can change the language at any time",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border:Border.all(width: 1)
                ),
                width: double.infinity,
                  child: Center(
                    child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_drop_down_circle_sharp),
                iconSize: 24,
                elevation: 16,
                underline: Container(
                    height: 2,
                ),
                onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                },
                items: <String>['English', 'Hindi', 'Gujarati', 'Marathi']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                }).toList(),
              ),
                  )),
               SizedBox(
              height: 20,
            ),
            Container(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                       Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (builder) =>HomePage()));
                  },
                  child: Text(
                    "NEXT",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.indigo[900])),
                ))
            ],
          ),
        ),
      ),
    );
  }
}
