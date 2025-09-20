import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  bool _cameraPermissionGranted = false;
  bool _locationPermissionGranted = false;
  bool _permissionsInitialized = false;

  bool get cameraPermissionGranted => _cameraPermissionGranted;
  bool get locationPermissionGranted => _locationPermissionGranted;
  bool get permissionsInitialized => _permissionsInitialized;

  Future<void> initializePermissions() async {
    if (_permissionsInitialized) return;

    print('PermissionService: Initializing permissions...');

    // Request camera permission
    final cameraStatus = await Permission.camera.status;
    if (cameraStatus.isDenied) {
      _cameraPermissionGranted = await _requestCameraPermission();
    } else {
      _cameraPermissionGranted = cameraStatus.isGranted;
    }

    // Request location permission
    final locationStatus = await Permission.location.status;
    if (locationStatus.isDenied) {
      _locationPermissionGranted = await _requestLocationPermission();
    } else {
      _locationPermissionGranted = locationStatus.isGranted;
    }

    _permissionsInitialized = true;
    print(
      'PermissionService: Permissions initialized - Camera: $_cameraPermissionGranted, Location: $_locationPermissionGranted',
    );
  }

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    final granted = status.isGranted;
    print('PermissionService: Camera permission result: $granted');
    return granted;
  }

  Future<bool> _requestLocationPermission() async {
    final status = await Permission.location.request();
    final granted = status.isGranted;
    print('PermissionService: Location permission result: $granted');
    return granted;
  }

  Future<bool> requestCameraPermission() async {
    final granted = await _requestCameraPermission();
    _cameraPermissionGranted = granted;
    return granted;
  }

  Future<bool> requestLocationPermission() async {
    final granted = await _requestLocationPermission();
    _locationPermissionGranted = granted;
    return granted;
  }

  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  void showPermissionDialog(BuildContext context, String permissionType) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Izin $permissionType Diperlukan',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Aplikasi memerlukan akses $permissionType untuk fitur yang optimal. Silakan aktifkan izin di pengaturan.',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Buka Pengaturan'),
            ),
          ],
        );
      },
    );
  }

  void resetPermissions() {
    _cameraPermissionGranted = false;
    _locationPermissionGranted = false;
    _permissionsInitialized = false;
  }
}
