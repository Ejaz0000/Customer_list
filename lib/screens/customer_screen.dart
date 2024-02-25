import 'dart:convert';

import 'package:customer_viewer/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/authentication.dart';
import '../api/customer.dart';
import 'package:http/http.dart' as http;

class CustomerScreenState extends ChangeNotifier {
  final String? token;
  int _currentPage = 1;
  int totalPages = 4;
  int get currentPage => _currentPage;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Customer> _customers = [];
  List<Customer> get customers => _customers;

  String? _error;
  String? get error => _error;

  CustomerScreenState({required this.token}) {
    fetchCustomers();
  }

  void fetchCustomers() async {
    try {
      _isLoading = true;
      notifyListeners();
      final url = Uri.parse(
          'https://www.pqstec.com/InvoiceApps/Values/GetCustomerList?searchquery=&pageNo=$_currentPage&pageSize=10&SortyBy=Balance');
      final response = await http.get(
        url,
        headers: {'Authorization': '$token'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> customerData = data['CustomerList'];
        List<Customer> customers =
            customerData.map((json) => Customer.fromJson(json)).toList();
        _customers = customers;
        _error = null;
      } else {
        throw Exception('Failed to load customers');
      }
    } catch (error) {
      _error = 'Failed to load customers. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      fetchCustomers();
    }
  }

  void nextPage() {
    if (_currentPage < 4) {
      _currentPage++;
      fetchCustomers();
    }
  }
}

class CustomerListPage extends StatelessWidget {
  static const String idScreen = "customer";
  @override
  Widget build(BuildContext context) {
    final authentication = Provider.of<Authentication>(context);
    final token = authentication.token;
    return ChangeNotifierProvider(
      create: (context) => CustomerScreenState(token: token),
      child: _CustomerListPage(),
    );
  }
}

class _CustomerListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authentication = Provider.of<Authentication>(context);
    final token = authentication.token;
    var customerPageState = Provider.of<CustomerScreenState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customer List',
          style: TextStyle(color: Colors.grey[300], fontFamily: "Brand Bold"),
        ),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            onPressed: () {
              authentication.token = null;
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.idScreen, (route) => false);
            },
            icon: Icon(Icons.logout, color: Colors.grey[300]),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
            gradient: RadialGradient(
          radius: 0.8,
          colors: [Colors.blueGrey[400]!, Colors.blueGrey[600]!],
        )),
        child: customerPageState.error != null
            ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error,color: Colors.red,),
                    SizedBox(width: 2,),
                    Text(
                      customerPageState.error!,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontFamily: "Brand Bold"),
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            width: 114,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'Page 0${customerPageState.currentPage}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: "Brand Bold"),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              "Tap on the arrow icon to see more details",
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 12,
                                  fontFamily: "Brand-Regular"),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: customerPageState.customers.length,
                          itemBuilder: (context, index) {
                            final customer = customerPageState.customers[index];
                            String totaldue = "Empty";
                            if (customer.due != null) {
                              totaldue = (customer.due).toString();
                            }
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey[800]!,
                                      blurRadius:
                                          3.0,
                                      spreadRadius:
                                          1.0,
                                      offset: Offset(
                                        1.0,
                                        1.0,
                                      ),
                                    ),
                                  ],
                                  color: Colors.blueGrey),
                              child: ExpansionTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.blueGrey[700],
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: customer.imageUrl != null
                                        ? NetworkImage(
                                            "https://www.pqstec.com/InvoiceApps" +
                                                customer.imageUrl!)
                                        : AssetImage(
                                                'images/placeholder_image.png')
                                            as ImageProvider,
                                  ),
                                ),
                                title: Text(
                                  customer.name ?? 'Unknown',
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 14,
                                      fontFamily: "Brand Bold"),
                                ),
                                subtitle: Text(
                                  customer.email ?? 'No email',
                                  style: TextStyle(
                                      color: Colors.blueGrey[700],
                                      fontSize: 12,
                                      fontFamily: "Brand Bold"),
                                ),
                                children: [
                                  Container(
                                    height: 2,
                                    margin: EdgeInsets.only(left: 35),
                                    width: (MediaQuery.of(context).size.width) *
                                        0.65,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 75),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Phone       : ',
                                          style: TextStyle(
                                              color: Colors.grey[300],
                                              fontSize: 12,
                                              fontFamily: "Brand-Regular"),
                                        ),
                                        Text(
                                          customer.phone ?? 'Empty',
                                          style: TextStyle(
                                              color: Colors.grey[300],
                                              fontSize: 12,
                                              fontFamily: "Brand-Regular"),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 75),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total Due : ',
                                          style: TextStyle(
                                              color: Colors.grey[300],
                                              fontSize: 12,
                                              fontFamily: "Brand-Regular"),
                                        ),
                                        Text(
                                          totaldue,
                                          style: TextStyle(
                                              color: Colors.grey[300],
                                              fontSize: 12,
                                              fontFamily: "Brand-Regular"),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 75),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Address    : ',
                                          style: TextStyle(
                                              color: Colors.grey[300],
                                              fontSize: 12,
                                              fontFamily: "Brand-Regular"),
                                        ),
                                        Flexible(
                                            child: Text(
                                          customer.address ?? 'Empty',
                                          style: TextStyle(
                                              color: Colors.grey[300],
                                              fontSize: 12,
                                              fontFamily: "Brand-Regular"),
                                        ))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  if (customerPageState.isLoading)
                    Center(
                      child: CircularProgressIndicator(
                          color: Colors.blueGrey[200]),
                    ),
                ],
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        shadowColor: Colors.blueGrey[900],
        color: Colors.blueGrey[600],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 40,
              width: 45,
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30),
              ),
              child: IconButton(
                onPressed: customerPageState.previousPage,
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.blueGrey[600],
                ),
              ),
            ),
            Row(
              children: [
                for (int i = 1; i <= customerPageState.totalPages; i++)
                  Container(
                    height: 40,
                    width: 45,
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    decoration: BoxDecoration(
                      color: i == customerPageState.currentPage
                          ? Colors.grey[800]
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextButton(
                      onPressed: () {
                        customerPageState._currentPage = i;
                        customerPageState.fetchCustomers();
                      },
                      child: Text(
                        '$i',
                        style: TextStyle(
                            color: i == customerPageState.currentPage
                                ? Colors.grey[300]
                                : Colors.grey[800],
                            fontFamily: "Brand Bold"),
                      ),
                    ),
                  ),
              ],
            ),
            Container(
              height: 40,
              width: 45,
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30),
              ),
              child: IconButton(
                onPressed: customerPageState.nextPage,
                icon: Icon(
                  Icons.chevron_right,
                  color: Colors.blueGrey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
