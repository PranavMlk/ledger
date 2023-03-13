import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/db_helper.dart';
import '../models/transaction_model.dart';
import '../widget/dailogue_confirm.dart';

class Incomes extends StatefulWidget {
  const Incomes({Key? key}) : super(key: key);

  @override
  State<Incomes> createState() => _IncomesState();
}

class _IncomesState extends State<Incomes> {

  late Box box;
  late SharedPreferences preferences;
  DbHelper dbHelper = DbHelper();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: FutureBuilder<List<TransactionModel>>(
          future:fetch(),
          builder: (context, snapshot) {
            if (snapshot.hasError){
              return Center(child: Text("Error!"),);
            }
            if (snapshot.hasData){
              if(snapshot.data!.isEmpty)
              {}
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child:Column(
                      children: [
                        Text('Your Incomes'),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length + 1,
                          itemBuilder: (context, index) {
                            TransactionModel dataAtIndex;
                            try {
                              dataAtIndex = snapshot.data![index];
                            } catch (e) {
                              return Container();
                            }
                            if(dataAtIndex.type== "Income"){
                              return IncomeTile(dataAtIndex.amount, dataAtIndex.note,
                                  dataAtIndex.date,index);
                            }
                          }
                  ),
                      ],
                    ),
                  )
                  ]
              );
            }
            else{
              return Center(child: Text("Error!"),);

            }

          }
      ),);
  }

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
