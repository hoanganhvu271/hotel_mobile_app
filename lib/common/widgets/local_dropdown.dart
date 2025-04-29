import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_app/features/booking/services/district_service.dart';
import '../../features/booking/services/city_service.dart';

class Local extends StatefulWidget {
  @override
  _LocalState createState() => _LocalState();
}

class _LocalState extends State<Local> {
  List<String> cities = [];
  String? selectedCity;
  List<String> districts = [];
  String? selectedDistrict;

  @override
  void initState() {
    super.initState();
    loadCities();
  }

  Future<void> loadCities() async {
    try {
      List<String> data = await fetchCities();
      print('Fetched cities: $data');
      setState(() {
        cities = data;

        selectedCity = data.isNotEmpty ? data[0] : null;
      });
    } catch (e) {
      print('Error loading cities: $e');
    }
  }

  Future<void> loadDistricts() async {
    try {
      List<String> data = await fetchDistricts();
      print('Fetched districts: $data');
      setState(() {
        cities = data;

        selectedCity = data.isNotEmpty ? data[0] : null;
      });
    } catch (e) {
      print('Error loading districts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Row(
            children: [
              Text(
                'Thành phố:',
                style: TextStyle(
                  color: Color(0xFF65462D),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 20),
              DropdownButton<String>(
                value: selectedCity,
                items: cities.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCity = newValue!;
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Row(
            children: [
              Text(
                'Khu vực:',
                style: TextStyle(
                  color: Color(0xFF65462D),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 20),
              Container(
                width: 216,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFCAC4D0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: SizedBox(),
                  value: 'All',
                  items: ['All'].map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
