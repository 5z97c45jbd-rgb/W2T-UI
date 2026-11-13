import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:latlong2/latlong.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/data/models/tracked_order.dart';
import 'package:w2t_mobile/features/home/widgets/track_order/track_order_chrome.dart';

class TrackRouteMap extends StatefulWidget {
  const TrackRouteMap({
    super.key,
    required this.order,
    this.compact = false,
    this.showLocate = false,
  });

  final TrackedOrder order;
  final bool compact;
  final bool showLocate;

  @override
  State<TrackRouteMap> createState() => _TrackRouteMapState();
}

class _TrackRouteMapState extends State<TrackRouteMap> {
  gmaps.GoogleMapController? _googleController;
  late final MapController _fallbackController;

  @override
  void initState() {
    super.initState();
    _fallbackController = MapController();
  }

  @override
  void dispose() {
    _googleController?.dispose();
    _fallbackController.dispose();
    super.dispose();
  }

  TrackedOrder get _order => widget.order;

  List<LatLng> get _fitPoints {
    if (_order.route.length >= 2) return _order.route;
    return [
      _order.restaurantPoint,
      _order.riderPoint,
      _order.destinationPoint,
    ];
  }

  gmaps.LatLng _toGoogle(LatLng point) =>
      gmaps.LatLng(point.latitude, point.longitude);

  gmaps.LatLngBounds _googleBounds() {
    final points = _fitPoints;
    var minLat = points.first.latitude;
    var maxLat = points.first.latitude;
    var minLng = points.first.longitude;
    var maxLng = points.first.longitude;
    for (final point in points) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }
    return gmaps.LatLngBounds(
      southwest: gmaps.LatLng(minLat, minLng),
      northeast: gmaps.LatLng(maxLat, maxLng),
    );
  }

  CameraFit get _fallbackFit {
    final padding = widget.compact
        ? const EdgeInsets.all(28)
        : const EdgeInsets.fromLTRB(36, 56, 36, 28);
    return CameraFit.coordinates(
      coordinates: _fitPoints,
      padding: padding,
      maxZoom: widget.compact ? 13.8 : 14.6,
    );
  }

  Future<void> _fitRoute() async {
    final google = _googleController;
    if (google != null) {
      await google.animateCamera(
        gmaps.CameraUpdate.newLatLngBounds(
          _googleBounds(),
          widget.compact ? 32 : 56,
        ),
      );
      return;
    }
    _fallbackController.fitCamera(_fallbackFit);
  }

  Set<gmaps.Marker> get _googleMarkers {
    final liveEta = !widget.compact && _order.isLive;
    return {
      gmaps.Marker(
        markerId: const gmaps.MarkerId('restaurant'),
        position: _toGoogle(_order.restaurantPoint),
        icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
          gmaps.BitmapDescriptor.hueOrange,
        ),
        infoWindow: gmaps.InfoWindow(title: _order.merchantName),
      ),
      gmaps.Marker(
        markerId: const gmaps.MarkerId('home'),
        position: _toGoogle(_order.destinationPoint),
        icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
          gmaps.BitmapDescriptor.hueAzure,
        ),
        infoWindow: gmaps.InfoWindow(
          title: 'Your location',
          snippet: _order.destinationLabel,
        ),
      ),
      gmaps.Marker(
        markerId: const gmaps.MarkerId('rider'),
        position: _toGoogle(_order.riderPoint),
        icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
          gmaps.BitmapDescriptor.hueBlue,
        ),
        infoWindow: gmaps.InfoWindow(
          title: liveEta
              ? 'Arriving in ${_order.etaLabel}'
              : _order.partner.name,
        ),
      ),
    };
  }

  Set<gmaps.Polyline> get _googlePolylines {
    return {
      gmaps.Polyline(
        polylineId: const gmaps.PolylineId('route'),
        points: _fitPoints.map(_toGoogle).toList(growable: false),
        color: TrackOrderStyle.routeBlue,
        width: widget.compact ? 4 : 5,
      ),
    };
  }

  Widget _googleMap() {
    final compact = widget.compact;
    return gmaps.GoogleMap(
      initialCameraPosition: gmaps.CameraPosition(
        target: _toGoogle(_order.riderPoint),
        zoom: compact ? 13.2 : 13.6,
      ),
      markers: _googleMarkers,
      polylines: _googlePolylines,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      zoomControlsEnabled: !compact,
      liteModeEnabled: compact,
      scrollGesturesEnabled: !compact,
      zoomGesturesEnabled: !compact,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      onMapCreated: (controller) {
        _googleController = controller;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _fitRoute();
        });
      },
    );
  }

  Widget _fallbackMap() {
    final compact = widget.compact;
    return FlutterMap(
      mapController: _fallbackController,
      options: MapOptions(
        initialCameraFit: _fallbackFit,
        minZoom: 11,
        maxZoom: 18,
        backgroundColor: const Color(0xFFE8EEF2),
        interactionOptions: InteractionOptions(
          flags: compact
              ? InteractiveFlag.none
              : InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        keepAlive: true,
      ),
      children: [
        PolylineLayer(
          polylines: [
            Polyline(
              points: _fitPoints,
              strokeWidth: compact ? 4 : 5,
              color: TrackOrderStyle.routeBlue,
              borderStrokeWidth: 2,
              borderColor: Colors.white,
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: _order.restaurantPoint,
              width: compact ? 30 : 38,
              height: compact ? 30 : 38,
              alignment: Alignment.bottomCenter,
              child: _PinMarker(
                color: TrackOrderStyle.restaurantOrange,
                icon: Icons.restaurant_rounded,
                size: compact ? 30 : 38,
              ),
            ),
            Marker(
              point: _order.destinationPoint,
              width: compact ? 30 : 38,
              height: compact ? 30 : 38,
              alignment: Alignment.bottomCenter,
              child: _PinMarker(
                color: TrackOrderStyle.homeBlue,
                icon: Icons.home_rounded,
                size: compact ? 30 : 38,
              ),
            ),
            Marker(
              point: _order.riderPoint,
              width: compact ? 44 : 148,
              height: compact ? 44 : 86,
              alignment: Alignment.bottomCenter,
              child: _RiderMarker(
                compact: compact,
                etaLabel: compact || !_order.isLive ? null : _order.etaLabel,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final map = _isWidgetTest || kIsWeb ? _fallbackMap() : _googleMap();
    return Stack(
      key: ValueKey(_order.id),
      fit: StackFit.expand,
      children: [
        IgnorePointer(ignoring: widget.compact, child: map),
        if (widget.showLocate)
          Positioned(
            top: 12,
            right: 12,
            child: Material(
              color: AppColors.white,
              shape: const CircleBorder(),
              elevation: 2,
              shadowColor: Colors.black26,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _fitRoute,
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.my_location_rounded,
                    size: 18,
                    color: TrackOrderStyle.navy,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

bool get _isWidgetTest {
  final name = WidgetsBinding.instance.runtimeType.toString();
  return name.contains('TestWidgetsFlutter');
}

class _PinMarker extends StatelessWidget {
  const _PinMarker({
    required this.color,
    required this.icon,
    required this.size,
  });

  final Color color;
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: size * 0.48),
    );
  }
}

class _RiderMarker extends StatelessWidget {
  const _RiderMarker({required this.compact, this.etaLabel});

  final bool compact;
  final String? etaLabel;

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: compact ? 36 : 42,
      height: compact ? 36 : 42,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.delivery_dining_rounded,
        color: TrackOrderStyle.homeBlue,
        size: compact ? 20 : 24,
      ),
    );

    if (etaLabel == null) return avatar;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: TrackOrderStyle.homeBlue,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            'Arriving in\n$etaLabel',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 11,
              height: 1.15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 6),
        avatar,
      ],
    );
  }
}
