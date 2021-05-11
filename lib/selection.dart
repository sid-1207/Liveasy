import 'package:flutter/material.dart';

class Selection extends StatefulWidget {
  @override
  _SelectionState createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  String character;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 200, 16, 200),
        child: Center(
          child: Column(
            children: [
              Text(
                "Please select your profile",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                ),
                child: RadioListTile(
                    activeColor: Colors.indigo[900],
                    title: Text("Shipper"),
                    subtitle: Text(
                        "Lorem ipsum dolor sit amet,consectetur adipiscing"),
                    value: "Shipper",
                    groupValue: character,
                    onChanged: (value) {
                      setState(() {
                        character = value;
                      });
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(border: Border.all(width: 1)),
                child: RadioListTile(
                    activeColor: Colors.indigo[900],
                    title: Text("Transporter"),
                    subtitle: Text(
                        "Lorem ipsum dolor sit amet,consectetur adipiscing"),
                    value: "Transporter",
                    groupValue: character,
                    onChanged: (value) {
                      setState(() {
                        character = value;
                      });
                    }),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "CONTINUE",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.indigo[900])),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
