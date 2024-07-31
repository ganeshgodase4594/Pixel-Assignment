import 'package:flutter/material.dart';
import 'package:pixel_assignment/provider/pagination_provider.dart';
import 'package:pixel_assignment/service/api.dart';
import 'package:provider/provider.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  String? selectedCountry;
  String? selectedGender;

  bool isAscending = true;

  late Future<List<dynamic>> futureUsers;

  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    futureUsers = getData(10, 0);
    _scrollController.addListener(loadMaxextentData);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void loadMaxextentData() {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      Provider.of<DataPagination>(context, listen: false).fetchPaginationData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No employees found'));
          } else {
            if (snapshot.hasData) {
              List data = snapshot.data!;
              Provider.of<DataPagination>(context, listen: false).usersData =
                  data;

              Provider.of<DataPagination>(context, listen: false).allData =
                  data;

              return Scaffold(
                  body: Column(
                children: [
                  Row(
                    children: [
                      // const SizedBox(width: 1300,),
                      const Spacer(),
                      Container(
                        //margin: EdgeInsets.all(10),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            //color: Colors.blue,
                            border: Border.all(
                                color: const Color(0x60313030), width: 2)),
                        child: DropdownButton<String>(
                            value: selectedCountry,
                            hint: const Text('Country'),
                            items: const [
                              DropdownMenuItem<String>(
                                value: 'United States',
                                child: Text('United States'),
                              ),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCountry = newValue;
                              });
                            }),
                      ),

                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            //color: Colors.blue,
                            border: Border.all(
                                color: const Color(0x60313030), width: 2)),
                        child: DropdownButton<String>(
                            value: selectedGender,
                            hint: const Text('Gender'),
                            items: const [
                              DropdownMenuItem<String>(
                                value: 'male',
                                child: Text('Male'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'female',
                                child: Text('Female'),
                              ),
                            ],
                            onChanged: (String? newValue) {
                              selectedGender = newValue;
                              Provider.of<DataPagination>(context,
                                      listen: false)
                                  .filterByGender(selectedGender!);
                            }),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Consumer<DataPagination>(
                      builder: (context, value, child) {
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return DataTable(
                                columns: [
                                  DataColumn(
                                    label: Row(children: [
                                      const Text("ID"),
                                      GestureDetector(
                                          onTap: () {
                                            Provider.of<DataPagination>(context,
                                                    listen: false)
                                                .reverseId();
                                          },
                                          child: const Icon(
                                            Icons.arrow_upward,
                                            color:
                                                Color.fromARGB(255, 59, 58, 58),
                                          )),
                                      GestureDetector(
                                          onTap: () {
                                            Provider.of<DataPagination>(context,
                                                    listen: false)
                                                .reverseId();
                                          },
                                          child: const Icon(
                                            Icons.arrow_downward,
                                            color: Colors.red,
                                          ))
                                    ]),
                                  ),
                                  const DataColumn(label: Text("Image")),
                                  DataColumn(
                                      label: Row(
                                    children: [
                                      Row(children: [
                                        const Text("Full Name"),
                                        GestureDetector(
                                            onTap: () {
                                            
                                              //isAscending=false;
                                            },
                                            child: const Icon(
                                              Icons.arrow_upward,
                                              color: Color.fromARGB(
                                                  255, 59, 58, 58),
                                            )),
                                        GestureDetector(
                                            onTap: () {},
                                            child: const Icon(
                                              Icons.arrow_downward,
                                              color: Colors.red,
                                            ))
                                      ]),
                                    ],
                                  )),
                                  const DataColumn(label: Text("Demography")),
                                  const DataColumn(label: Text("Designation")),
                                  const DataColumn(label: Text("Location")),
                                ],
                                rows: List.generate(
                                  value.usersData.length + 1,
                                  (index) {
                                    if (index < value.usersData.length) {
                                      return DataRow(cells: [
                                        DataCell(Text((value.usersData[index]
                                                ['id'])
                                            .toString())),
                                        DataCell(Image.network(
                                            value.usersData[index]['image'])),
                                        DataCell(Text(
                                            '${value.usersData[index]['firstName']} ${value.usersData[index]['maidenName']} ${value.usersData[index]['lastName']}')),
                                        DataCell(Text(
                                            '${value.usersData[index]['gender']} / ${value.usersData[index]['age']}')),
                                        DataCell(Text(value.usersData[index]
                                            ['company']['title'])),
                                        DataCell(Text(
                                            '${value.usersData[index]['company']['address']['state']} ,${value.usersData[index]['company']['address']['country']}')),
                                      ]);
                                    } else {
                                      return const DataRow(cells: [
                                        DataCell(Text("")),
                                        DataCell(Text("")),
                                        DataCell(Text("")),
                                        DataCell(CircularProgressIndicator()),
                                        DataCell(Text("")),
                                        DataCell(Text("")),
                                      ]);
                                    }
                                  },
                                ));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ));
            } else {
              return const Scaffold();
            }
          }
        },
      ),
    );
  }
}
