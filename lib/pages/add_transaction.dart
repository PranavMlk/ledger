import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ledger/static.dart' as Static;
import 'package:flutter/foundation.dart';
import '../controller/db_helper.dart';



class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {

  //

  int? amonunt;
  String note="Milk";
  String types="income";
  DateTime sdate = DateTime.now();
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: sdate,
        firstDate: DateTime(1990, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != sdate) {
      setState(() {
        sdate = picked;
      });
    }
  }


  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade700,
        appBar: AppBar(
          toolbarHeight: 0.0,
        ),
        persistentFooterButtons: [

          Container(

            width: 900,
            child: Text(
              '©Pranav',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
        body: ListView(
          padding: EdgeInsets.all(12.0),
          children: [
            SizedBox(
              height: 20.0,
            ),
            Text("Add Transaction",
              textAlign: TextAlign.center,

              style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            //
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.black,
                        Colors.red
                      ]),
                      borderRadius: BorderRadius.circular(16.0)
                  ),

                  padding: EdgeInsets.all(12.0),
                  child:
                  Icon(Icons.attach_money,size: 24.0,color: Colors.white,),

                ),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(

                  child:
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Rs",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 24.0,
                      color: Colors.white
                    ),
                    onChanged: (val) {
                      try{
                        amonunt = int.parse(val);

                      }
                      catch(e) {}

                    },

                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly

                    ],
                    keyboardType: TextInputType.number,

                  ),

                ),


              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.black,
                        Colors.red
                      ]),
                      borderRadius: BorderRadius.circular(16.0)
                  ),

                  padding: EdgeInsets.all(12.0),
                  child:
                  Icon(Icons.description,size: 24.0,color: Colors.white,),

                ),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(

                  child:
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Note of Transaction",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 24.0,
                      color: Colors.white
                    ),
                    onChanged: (val){
                      note=val;
                    },


                  ),

                ),


              ],
            ),

            SizedBox(
              height: 20.0,
            ),

            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.black,
                        Colors.red
                      ]),
                      borderRadius: BorderRadius.circular(16.0)
                  ),

                  padding: EdgeInsets.all(12.0),
                  child:
                  Icon(Icons.moving_sharp,size: 24.0,color: Colors.white,
                  ),

                ),

                SizedBox(
                  width: 12.0,
                ),

                ChoiceChip(label: Text("Income",   style: TextStyle(
                  fontSize: 16.0, color:  types == "Income" ? Colors.white:Colors.white,
                ),),

                  selectedColor: Colors.green,
                  selected: types == "Income" ? true:false ,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        types = "Income";
                        if (note.isEmpty || note == "Expense") {
                          note = 'Income';
                        }
                      });
                    }
                  },),


                SizedBox(
                  width: 12.0,
                ),

                ChoiceChip(label: Text("Expense",   style: TextStyle(
                  fontSize: 16.0, color:  types == "Income" ? Colors.white:Colors.white,
                ),),

                  selectedColor: Colors.red,
                  selected: types == "Expense" ? true:false ,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        types = "Expense";
                        if (note.isEmpty || note == "Expense") {
                          note = 'Expense';
                        }
                      });
                    }
                  },),




              ],
            ),

            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: 50.0,
              child:
              TextButton(
                onPressed: () {
                  _selectDate(context);
                },
                style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.black,
                          Colors.red
                        ]),
                        borderRadius: BorderRadius.circular(
                          16.0,
                        ),
                      ),
                      padding: EdgeInsets.all(
                        12.0,
                      ),
                      child: Icon(
                        Icons.date_range,
                        size: 24.0,
                        // color: Colors.grey[700],
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),

                    Text(
                      "${sdate.day} ${months[sdate.month - 1]}",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ],

                ),
              ),
            ),

            SizedBox(
              height: 20.0,
            ),

            SizedBox(
              height:50.0,
              child:
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.black,
                    Colors.red
                  ]),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: ElevatedButton(onPressed: () {
                  if (amonunt != null) {
                    DbHelper dbHelper = DbHelper();
                    dbHelper.addData(amonunt!, sdate, types, note);

                    Navigator.of(context).pop();
                  }
                  else {
                    print("Not ");
                  }
                }, child: Text("Add",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                  ),

                ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    onSurface: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                ),
              ),
            )
          ],
        )
    );
  }
}