import 'dart:convert';

import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:flutter/material.dart';

class ARVRPage extends StatefulWidget {
  const ARVRPage({super.key, required this.title});

  final String title;

  @override
  State<ARVRPage> createState() => _ARVRPageState();
}

class _ARVRPageState extends State<ARVRPage> {
  late final DeepArController _controller;
  final String _assetEffectsPath = 'assets/models/';
  @override
  void initState() {
    _controller = DeepArController();
    _controller
        .initialize(
          androidLicenseKey:
              "f6e1355725889f37912c38748c9e6a737774831e1e67a1d8235b4ab645911f431d07c35cf4d3bf25",
          iosLicenseKey:
              "7194794d4e968d5ecbe426d334ad58e0a49e18174d597d4074840f3f4967e7df56f7e3304958f0d1",
          resolution: Resolution.high,
        )
        .then((value) => setState(() {}));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _initEffects();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.destroy();
    super.dispose();
  }

  /// Add effects which are rendered via DeepAR sdk
  void _initEffects() {
    // Either get all effects
    _getEffectsFromAssets(context).then((values) {});

    // OR

    // Only add specific effects
    // _effectsList.add(_assetEffectsPath+'burning_effect.deepar');
    // _effectsList.add(_assetEffectsPath+'flower_face.deepar');
    // _effectsList.add(_assetEffectsPath+'Hope.deepar');
    // _effectsList.add(_assetEffectsPath+'viking_helmet.deepar');
  }

  /// Get all deepar effects from assets
  ///
  Future<List<String>> _getEffectsFromAssets(BuildContext context) async {
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final filePaths = manifestMap.keys
        .where((path) => path.startsWith(_assetEffectsPath))
        .toList();
    return filePaths;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _controller.isInitialized
            ? DeepArPreview(_controller)
            : const Center(
                child: Text("Loading..."),
              ),
        _bottomMediaOptions(),
      ],
    );
  }

// prev, record, screenshot, next
  /// Sample option which can be performed
  Positioned _bottomMediaOptions() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              child: Text('Try on'),
              onPressed: () {
                // trimRight() is to remove any space from the right side
                // Example Rayban 5 -> Rayban5
                // Remove it if necessary
                _controller.switchEffect(
                    'assets/models/${widget.title.trimRight()}.deepar');
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            IconButton(
              onPressed: () {
                _controller.flipCamera();
              },
              iconSize: 50,
              color: Colors.red,
              icon: const Icon(Icons.cameraswitch),
            )
          ],
        ),
      ),
    );
  }
}
