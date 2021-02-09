import 'package:flutter/material.dart';
import 'package:flutter_sqflite_jsondata/provider/employee_api_provider.dart';
import 'package:flutter_sqflite_jsondata/provider/employeedb_provider.dart';

class Employ extends StatefulWidget {
  const Employ ({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Employ> {
  var isLoading = false;
  var id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api to sqlite'),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10.0,left: 65),
            child: IconButton(
              icon: Icon(Icons.settings_input_antenna),
              onPressed: () async {
                await _loadFromApi();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await _deleteData();
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
            child: CircularProgressIndicator(),
      )
          : _buildEmployeeListView(),
    );
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });
    var apiProvider = EmployeeApiProvider();
    await apiProvider.getAllEmployees();
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }
  _deleteData() async {
    setState(() {
      isLoading = true;
    });
    await DBProvider.db.deleteAllEmployees();
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });
    print('All employees deleted');
  }

  updateUserDetails() async {
    setState(() {
      isLoading = true;
    });

    // var apiProvider = EmployeeApiProvider();
    // await apiProvider.getAllEmployees();
    await DBProvider.db.updateUsers();
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _buildEmployeeListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllEmployees(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {

          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black12,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 5,
                child: Column(
                  children: [
                    Container(
                      child: Text("User Details",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  Column(
                      children: [
                        Text( "Name: ${snapshot.data[index].name}"),

                        Text( "User Name: ${snapshot.data[index].username}"),

                        Text( "Email: ${snapshot.data[index].email}"),

                        Text( "Phone: ${snapshot.data[index].phone}"),

                        Text( "City: ${snapshot.data[index].address.city}"),

                        Text( "Zipcode: ${snapshot.data[index].address.zipcode}"),

                        RaisedButton(
                            child: Text('Update'),
                            onPressed:() {
                              updateUserDetails();},

                        )
                      ],
                    )
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
  void update() async {
    // row to update

    Map<String, dynamic> employee = {
      DBProvider.id  : 'id',
      DBProvider.name : 'name',

    };
    var db;
    final rowsAffected = await db.update(employee);
    print('updated $rowsAffected row(s)');
  }

}

