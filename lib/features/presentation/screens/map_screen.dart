import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/helper/location_helper.dart';
import '../../../core/utils/app_color.dart';
import '../../business_logic/phone_auth/phone_auth_cubit.dart';
import '../widgets/my_drawer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();

  static Position? position;
  Completer<GoogleMapController> _mapController = Completer();

  static final CameraPosition _myCurrentPositionCameraPosition = CameraPosition(
    bearing: 0,
    tilt: 0,
    target: LatLng(position!.latitude, position!.longitude),
    zoom: 17,
  );

  Future<void> getMyCurrentLocation() async {
    position = await LocationHelper.getCurrentLocation().whenComplete(() {
      setState(() {});
    });
  }

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      initialCameraPosition: _myCurrentPositionCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
    );
  }

  SearchController searchController = SearchController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget buildNativeSearchBar() {
    return Positioned(
      top: 60,
      left: 16,
      right: 16,
      child: SearchAnchor(
        searchController: searchController,
        // The builder creates the actual SearchBar you see on screen
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            hintText: 'Find a place..',
            hintStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 18)),
            elevation: const WidgetStatePropertyAll(6),
            padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16.0)),
            textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 18)),
            leading: IconButton(
              icon: const Icon(Icons.menu, color: AppColor.blue),
              onPressed: () {
                // This opens the drawer!
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            trailing: [
              IconButton(
                icon: Icon(Icons.place, color: Colors.black.withOpacity(0.6)),
                onPressed: () {
                  // Action for trailing icon
                },
              ),
            ],
            // When tapped or typed in, we tell the anchor to open the dropdown view
            onTap: () => controller.openView(),
            onChanged: (query) {
              controller.openView();
              // Trigger your Google Places API call here based on the query!
            },
          );
        },

        // THIS is the equivalent of your old builder!
        // It builds the list of suggestions in the dropdown.
        suggestionsBuilder: (BuildContext context, SearchController controller) {
          final keyword = controller.value.text;

          // If the user hasn't typed anything, show an empty list (or recent searches)
          if (keyword.isEmpty) {
            return [];
          }

          // Return your list of Widgets here.
          // Usually, this is mapped from a list of Places API results.
          return [
            ListTile(
              leading: const Icon(Icons.location_on, color: AppColor.blue),
              title: Text(keyword),
              onTap: () {
                // When they tap a result, close the dropdown and set the text
                controller.closeView(keyword);
                // You would also move the map camera to this location here
              },
            ),
          ];
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getMyCurrentLocation();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          position != null
              ? buildMap()
              : Center(
                  child: CircularProgressIndicator(color: AppColor.blue),
                ),
         buildNativeSearchBar(),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 8, 30),
        child: FloatingActionButton(
          backgroundColor: AppColor.blue,
          onPressed: _goToMyCurrentLocation,
          child: Icon(Icons.place, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _goToMyCurrentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(_myCurrentPositionCameraPosition),
    );
  }
}
