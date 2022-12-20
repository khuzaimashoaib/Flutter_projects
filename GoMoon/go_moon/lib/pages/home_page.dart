import 'package:flutter/material.dart';
import 'package:go_moon/widgets/custom_dropdownbutton_widget.dart';

class HomePage extends StatelessWidget {
  
  late double _deviceHeight, _deviceWidth;
  
  HomePage({Key? key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: _deviceHeight,
          width: _deviceWidth,
          padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.10),
          child: Stack(
            children: [
              Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,  
            children: [
              _pageTitle(),
              _bookRideWidget(),
            ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child:_astroImageWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pageTitle() {
    return Text("#GoMoon",
    style: TextStyle(
      color: Colors.white,
      fontSize: 70,
      fontWeight: FontWeight.w800,
      ),
    );
  }
  
  Widget _astroImageWidget(){
    return Container(
      height:_deviceHeight * 0.50,
      width: _deviceWidth * 0.65,
      decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("assets/images/astro_moon.png"))
        ),
      );
  }

  Widget _desDropdownWidget() {
    return CustomDropDownButtonClass(
      values: [
    'Gulberg station',
    'WaterPump Station',
    'Sarena Station', ],
      width: _deviceWidth );

  } 

  Widget _bookRideWidget(){
    return Container(
      height: _deviceHeight * 0.25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _desDropdownWidget(),
          _travellerInfoWidget(),
          _rideButton(),
        ],

      ),);
  }

  Widget _travellerInfoWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomDropDownButtonClass(
          values: [
        '1', '2', '3', '4', ], 
          width: _deviceWidth * 0.38),
          CustomDropDownButtonClass(
          values: [
        'Economy', 'Business', 'First Class', 'Private', ], 
          width: _deviceWidth * 0.38),
      ],
    );
  }

  Widget _rideButton(){
    return Container(
      margin: EdgeInsets.only(bottom: _deviceWidth * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), 
      ),
      width: _deviceWidth,
      child: MaterialButton(onPressed: () {},
      child: const Text(
        'Book Ride!', 
        style: TextStyle(
          color: Colors.black),
        ),
      ),
    );
  }

}