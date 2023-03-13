import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:ledger/pages/expense_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/db_helper.dart';
import '../models/transaction_model.dart';
import '../widget/dailogue_confirm.dart';
import 'add_transaction.dart';
import 'income_page.dart';





class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}
class _HomepageState extends State<Homepage> {

  late Box box;
  late SharedPreferences preferences;
  DbHelper dbHelper = DbHelper();
  Map? data;
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;

  DateTime today = DateTime.now();
  DateTime now = DateTime.now();
  int index = 1;
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

  @override
  void initState() {
    super.initState();
    getPreference();
    box = Hive.box('money');
    fetch();
  }

  getPreference() async {
    preferences = await SharedPreferences.getInstance();
  }


  Future<List<TransactionModel>> fetch() async {
    if (box.values.isEmpty) {
      return Future.value([]);
    } else {
      // return Future.value(box.toMap());
      List<TransactionModel> items = [];
      box.toMap().values.forEach((element) {
        // print(element);
        items.add(
          TransactionModel(
            element['amount'] as int,
            element['note'],
            element['date'] as DateTime,
            element['type'],
          ),
        );
      });
      return items;
    }
  }

  getTotalBalance(List<TransactionModel> entiredata)
  {
    totalExpense=0;
    totalIncome=0;
    totalBalance=0;

    for (TransactionModel data in entiredata) {
      if (data.date.month == today.month)
        if( data.type == "Income") {
          totalBalance+=data.amount;
          totalIncome+=data.amount;
        }
        else {
          totalBalance-=data.amount;
          totalExpense+= data.amount;

        }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      appBar: AppBar(
        title: Text('Cashbook'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: <Color>[
                  Colors.black,
                  Colors.red]),
          ),
        ),
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

      //backgroundColor: Color(0xffe2e7ef),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.black,
            Colors.red
          ]),
          borderRadius: BorderRadius.circular(12)
        ),
        child: FloatingActionButton(onPressed: (){

          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddTransaction()
            ,),
          ).whenComplete(() {
            setState(() {});
          });
        },
          child: Icon(Icons.add,size: 32.0,),

          backgroundColor: Colors.transparent,
        ),
      ),
      body: FutureBuilder<List<TransactionModel>>(
          future:fetch(),
          builder: (context, snapshot) {
            if (snapshot.hasError){
              return Center(child: Text("Error!"),);
            }
            if (snapshot.hasData){
              if(snapshot.data!.isEmpty)
              {
                return Center(child: Text("Please add your transactions!",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15
                  ),
                ),);
              }
              getTotalBalance(snapshot.data!);
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Welcome",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.white
                            ),
                          ),
                          Container(
                            child:Row(
                              children: [
                                TextButton(
                                    onPressed: (){
                                      Navigator.push(context, PageRouteBuilder(
                                          pageBuilder: (_,__,___)=>Incomes()));
                                    },
                                    child: Text('Incomes',
                                      style: TextStyle(
                                        color: Colors.green
                                      ),
                                    ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.white
                                  )
                                ),
                                SizedBox(width: 5,),
                                TextButton(
                                    onPressed: (){
                                      Navigator.push(context, PageRouteBuilder(
                                          pageBuilder: (_,__,___)=>Expenses()));
                                    },
                                    child: Text('Expenses',),
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.white
                                    )
                                )
                              ],
                            ),
                          )
                        ]
                    ),
                  ),

                  Container(

                    width: MediaQuery.of(context).size.width *0.9,
                    margin: EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [
                        Colors.black,
                        Colors.red
                      ],),
                          borderRadius: BorderRadius.all(Radius.circular(24.0))
                      ),


                      padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 8.0),
                      child: Column(children: [
                        Text("Total Balance", textAlign: TextAlign.center,style: TextStyle
                          (fontSize: 22.0, color: Colors.white)
                          ,),

                        SizedBox(
                          height: 12.0,
                        ),

                        Text("$totalBalance Rs ", textAlign: TextAlign.center,style: TextStyle
                          (fontSize: 26.0, color: Colors.white)
                          ,),
                        SizedBox(
                          height: 12.0,
                        ),
                        Padding(padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              cardIncome(totalIncome.toString()
                              ),
                              cardExpense(totalExpense.toString())
                            ],
                          ),

                        )

                      ],),
                    ),
                  ),


                  /////
                  ////
                  ////
                  Padding(
                    padding: const EdgeInsets.all(
                      12.0,
                    ),
                    child: Text(
                      "Recent Transactions",
                      style: TextStyle(
                        fontSize: 26.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),

                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length + 1,
                      itemBuilder: (context, index) {
                        TransactionModel dataAtIndex;
                        try {
                          // dataAtIndex = snapshot.data![index];
                          dataAtIndex = snapshot.data![index];
                        } catch (e) {
                          // deleteAt deletes that key and value,
                          // hence makign it null here., as we still build on the length.
                          return Container();
                        }



                        if(dataAtIndex.type== "Income"){
                          return IncomeTile(dataAtIndex.amount, dataAtIndex.note,
                              dataAtIndex.date,index);
                        }
                        else {
                          return expenseTile(dataAtIndex.amount, dataAtIndex.note
                              ,dataAtIndex.date,index);
                        }

                      }
                  ),
                  SizedBox(
                    height: 60.0,
                  ),

                ],
              );
            }
            else{
              return Center(child: Text("Error!"),);

            }

          }
      ),
    );
  }


  Widget cardIncome(String value){
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          padding: EdgeInsets.all(6.0
          ),
          child: Icon(Icons.arrow_upward,
            size: 28.0,color: Colors.green[700],

          ),
          margin: EdgeInsets.only(right: 8.0),

        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Income",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white70,

              ),
            ),
            Text(
              "$value Rs " ,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }









  ///////////////



  Widget cardExpense(String value){
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          padding: EdgeInsets.all(6.0
          ),
          child: Icon(Icons.arrow_downward,
            size: 28.0,color: Colors.red[700],

          ),
          margin: EdgeInsets.only(right: 8.0),

        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Expense",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white70,

              ),
            ),
            Text(
              "$value Rs",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }



/////////////
  Widget expenseTile(int value, String note, DateTime date,int index){
    return InkWell(
      onLongPress: () async {
        bool? answer = await showConfirmDialog(
          context,
          "WARNING",
          "This will delete this expense record. This action is irreversible. Do you want to continue ?",
        );
        if (answer != null && answer) {
          await dbHelper.deleteData(index);
          setState(() {});
        }
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.redAccent,
            Colors.red
          ]
        ),
            borderRadius: BorderRadius.circular(8.0) ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_circle_down_outlined,
                      size: 28.0,
                      color: Colors.red[100],
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text("Expense",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    )

                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text("${date.day} ${months[date.month -1]} ${date.year}",
                    style: TextStyle(
                      color: Colors.grey[800],
                      // fontSize: 24.0,
                      // fontWeight: FontWeight.w700

                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(" - $value Rs",style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.w700,
                ),
                ),
                Text(note,style: TextStyle(
                    color: Colors.grey[800]
                  // fontSize: 24.0,
                  // fontWeight: FontWeight.w700,
                ),
                ),
              ],
            )
          ],
        ),


      ),
    );
  }

////////////////

  Widget IncomeTile(int value, String note,DateTime date, int index){
    return InkWell(
      onLongPress: () async {
        bool? answer = await showConfirmDialog(
          context,
          "WARNING",
          "This will delete this expense record. This action is irreversible. Do you want to continue ?",
        );
        if (answer != null && answer) {
          await dbHelper.deleteData(index);
          setState(() {});
        }
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.greenAccent,
            Colors.green
          ]),
            borderRadius: BorderRadius.circular(8.0) ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_circle_up_outlined,
                      size: 28.0,
                      color: Colors.green[800],
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text("Income",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    )

                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text("${date.day} ${months[date.month -1]} ${date.year}",
                    style: TextStyle(
                      color: Colors.grey[800],
                      // fontSize: 24.0,
                      // fontWeight: FontWeight.w700

                    ),
                  ),
                ),

              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(" + $value Rs",
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700),
                ),
                Text(note,
                  style: TextStyle(
                    color: Colors.grey[800],
                    // fontSize: 24.0,
                    // fontWeight: FontWeight.w700

                  ),
                ),
              ],
            )
          ],
        ),


      ),

    );

  }




}