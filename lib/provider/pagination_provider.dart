

import 'package:flutter/material.dart';
import 'package:pixel_assignment/service/api.dart';

class DataPagination with ChangeNotifier{

    List usersData = [];
    List allData = [];
    void fetchPaginationData()async{
        List fetchedData = await getData(0,10);
        if(fetchedData.isNotEmpty == true){
            usersData.addAll(fetchedData);
            allData.addAll(fetchedData);
        }
        notifyListeners();
    }

    void filterByGender(String val){
        List filterData = [];
        for(int i=0;i<allData.length;i++){
            if(allData[i]['gender'] == val){
              filterData.add(allData[i]);
            }
        }
        usersData = filterData;
        notifyListeners();
    }


    void reverseId(){
       List reverse=[];
      
       int len = usersData.length;
      for(int i=len-1;i>=0;i--){
          reverse.add( usersData[i]);
      }
      usersData=reverse;
      notifyListeners();
    }

  bool isAscending = true;
  bool sortByName = false;

    void sortUsersByName(bool isAscending) {
    isAscending = isAscending;
    sortByName = true;
    sortUsersByName1();
    notifyListeners();
    
  }

  void sortUsersByName1() {
    usersData.sort((a, b) {
      String nameA = '${a['firstName']} ${a['maidenName']} ${a['lastName']}';
      String nameB = '${b['firstName']} ${b['maidenName']} ${b['lastName']}';
      int result = nameA.compareTo(nameB);
      return isAscending ? result : -result;
        
    });
  
}
}