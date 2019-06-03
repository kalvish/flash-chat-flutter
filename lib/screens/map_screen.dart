import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flash_chat/services/location.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map_screen';
  @override
  _MapScreenState createState() => _MapScreenState();
}

typedef Marker MarkerUpdateAction(Marker marker);

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController googleMapController;
  Location location;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;

  static LatLng center = const LatLng(6.8874854, 79.91237009999998);

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(6.8874854, 79.91237009999998),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(6.8874854, 79.91237009999998),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              setState(() {
                googleMapController = controller;
              });
              _goToUserLocation();
            },
//            markers: _createMarker(),
            markers: Set<Marker>.of(markers.values),
          ),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  FlatButton(
                    onPressed: _add,
                    child: const Text('Add'),
                    color: Colors.green,
                  ),
                  FlatButton(
                    onPressed: _remove,
                    child: const Text('Remove'),
                    color: Colors.green,
                  ),
                  FlatButton(
                    child: const Text('change info'),
                    onPressed: _changeInfo,
                    color: Colors.green,
                  ),
                  FlatButton(
                    child: const Text('change info anchor'),
                    onPressed: _changeInfoAnchor,
                    color: Colors.green,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  FlatButton(
                    child: const Text('chng alpha'),
                    onPressed: _changeAlpha,
                  ),
                  FlatButton(
                    child: const Text('chng anchor'),
                    onPressed: _changeAnchor,
                  ),
                  FlatButton(
                    child: const Text('tgl draggable'),
                    onPressed: _toggleDraggable,
                  ),
                  FlatButton(
                    child: const Text('tlg flat'),
                    onPressed: _toggleFlat,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  FlatButton(
                    child: const Text('chng pos'),
                    onPressed: _changePosition,
                  ),
                  FlatButton(
                    child: const Text('chng rot'),
                    onPressed: _changeRotation,
                  ),
                  FlatButton(
                    child: const Text('tgl visible'),
                    onPressed: _toggleVisible,
                  ),
                  FlatButton(
                    child: const Text('chng zIndex'),
                    onPressed: _changeZIndex,
                  ),
                ],
              ),
            ],
          ),
//          Positioned(child: FlatButton(onPressed: _add
//          , child: Icon(Icons.pin_drop),
//          color: Colors.green,)),
        ],
////      floatingActionButton: FloatingActionButton.extended(
////        onPressed: _goToTheLake,
////        label: Text('To the lake!'),
////        icon: Icon(Icons.directions_boat),
////      ),
      ),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 300.0,
            height: 200.0,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                setState(() {
                  googleMapController = controller;
                });
                _goToUserLocation();
              },
              // TODO(iskakaushik): Remove this when collection literals makes it to stable.
              // https://github.com/flutter/flutter/issues/28312
              // ignore: prefer_collection_literals
              markers: Set<Marker>.of(markers.values),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('add'),
                          onPressed: _add,
                        ),
                        FlatButton(
                          child: const Text('remove'),
                          onPressed: _remove,
                        ),
                        FlatButton(
                          child: const Text('change info'),
                          onPressed: _changeInfo,
                        ),
                        FlatButton(
                          child: const Text('change info anchor'),
                          onPressed: _changeInfoAnchor,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('change alpha'),
                          onPressed: _changeAlpha,
                        ),
                        FlatButton(
                          child: const Text('change anchor'),
                          onPressed: _changeAnchor,
                        ),
                        FlatButton(
                          child: const Text('toggle draggable'),
                          onPressed: _toggleDraggable,
                        ),
                        FlatButton(
                          child: const Text('toggle flat'),
                          onPressed: _toggleFlat,
                        ),
                        FlatButton(
                          child: const Text('change position'),
                          onPressed: _changePosition,
                        ),
                        FlatButton(
                          child: const Text('change rotation'),
                          onPressed: _changeRotation,
                        ),
                        FlatButton(
                          child: const Text('toggle visible'),
                          onPressed: _toggleVisible,
                        ),
                        FlatButton(
                          child: const Text('change zIndex'),
                          onPressed: _changeZIndex,
                        ),
                        // A breaking change to the ImageStreamListener API affects this sample.
                        // I've updates the sample to use the new API, but as we cannot use the new
                        // API before it makes it to stable I'm commenting out this sample for now
                        // TODO(amirh): uncomment this one the ImageStream API change makes it to stable.
                        // https://github.com/flutter/flutter/issues/33438
                        //
                        // FlatButton(
                        //   child: const Text('set marker icon'),
                        //   onPressed: () {
                        //     _getAssetIcon(context).then(
                        //       (BitmapDescriptor icon) {
                        //         _setMarkerIcon(icon);
                        //       },
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<void> _goToUserLocation() async {
    location = await Location().geoLocation();
    if (location != null) {
      setState(() {
        center = LatLng(location.latitude, location.longitude);
      });

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(location.latitude, location.longitude),
          zoom: 19.151926040649414)));
    }
  }

  Set<Marker> _createMarker() {
    // TODO(iskakaushik): Remove this when collection literals makes it to stable.
    // https://github.com/flutter/flutter/issues/28312
    // ignore: prefer_collection_literals
    return <Marker>[
      Marker(
        markerId: MarkerId("marker_1"),
        position: LatLng(37.43296265331129, -122.08832357078792),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: 'My marker'),
      ),
    ].toSet();
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  void _add() {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        center.latitude + sin(_markerIdCounter * pi / 6.0) / 20.0,
        center.longitude + cos(_markerIdCounter * pi / 6.0) / 20.0,
      ),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
        _onMarkerTapped(markerId);
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _remove() {
    setState(() {
      if (markers.containsKey(selectedMarker)) {
        markers.remove(selectedMarker);
      }
    });
  }

  void _changePosition() {
    final Marker marker = markers[selectedMarker];
    final LatLng current = marker.position;
    final Offset offset = Offset(
      center.latitude - current.latitude,
      center.longitude - current.longitude,
    );
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        positionParam: LatLng(
          center.latitude + offset.dy,
          center.longitude + offset.dx,
        ),
      );
    });
  }

  void _changeAnchor() {
    final Marker marker = markers[selectedMarker];
    final Offset currentAnchor = marker.anchor;
    final Offset newAnchor = Offset(1.0 - currentAnchor.dy, currentAnchor.dx);
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        anchorParam: newAnchor,
      );
    });
  }

  Future<void> _changeInfoAnchor() async {
    final Marker marker = markers[selectedMarker];
    final Offset currentAnchor = marker.infoWindow.anchor;
    final Offset newAnchor = Offset(1.0 - currentAnchor.dy, currentAnchor.dx);
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        infoWindowParam: marker.infoWindow.copyWith(
          anchorParam: newAnchor,
        ),
      );
    });
  }

  Future<void> _toggleDraggable() async {
    final Marker marker = markers[selectedMarker];
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        draggableParam: !marker.draggable,
      );
    });
  }

  Future<void> _toggleFlat() async {
    final Marker marker = markers[selectedMarker];
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        flatParam: !marker.flat,
      );
    });
  }

  Future<void> _changeInfo() async {
    final Marker marker = markers[selectedMarker];
    final String newSnippet = marker.infoWindow.snippet + '*';
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        infoWindowParam: marker.infoWindow.copyWith(
          snippetParam: newSnippet,
        ),
      );
    });
  }

  Future<void> _changeAlpha() async {
    final Marker marker = markers[selectedMarker];
    final double current = marker.alpha;
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        alphaParam: current < 0.1 ? 1.0 : current * 0.75,
      );
    });
  }

  Future<void> _changeRotation() async {
    final Marker marker = markers[selectedMarker];
    final double current = marker.rotation;
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        rotationParam: current == 330.0 ? 0.0 : current + 30.0,
      );
    });
  }

  Future<void> _toggleVisible() async {
    final Marker marker = markers[selectedMarker];
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        visibleParam: !marker.visible,
      );
    });
  }

  Future<void> _changeZIndex() async {
    final Marker marker = markers[selectedMarker];
    final double current = marker.zIndex;
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        zIndexParam: current == 12.0 ? 0.0 : current + 1.0,
      );
    });
  }
}
