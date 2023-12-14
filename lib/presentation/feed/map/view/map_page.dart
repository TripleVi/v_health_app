import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/resources/colors.dart';
import '../../../../core/resources/style.dart';
import '../../../../domain/entities/post.dart';
import '../../../camera/views/camera_page.dart';
import '../../../widgets/appBar.dart';
import '../../../widgets/back_btn.dart';
import '../cubit/map_cubit.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)!.settings.arguments as Post;
    return BlocProvider<MapCubit>(
      create: (context) => MapCubit(post),
      child: MapView(),
    );
  }
}

class MapView extends StatelessWidget {
  PersistentBottomSheetController<void>? _btmSheetController;
  MapView({super.key});

  Widget _googleMapWidget({
    required BuildContext context,
    required Set<Polyline> polylines,
    required Set<Marker> markers,
  }) {
    return GoogleMap(
      onTap: (argument) {},
      polylines: polylines,
      mapType: MapType.normal,
      markers: markers,
      initialCameraPosition: const CameraPosition(
        target: LatLng(0.0, 0.0),
        zoom: 18.0,
        tilt: 10.0,
      ),
      onMapCreated: (GoogleMapController controller) {
        context.read<MapCubit>().onMapCreated(controller);
      },
    );
  }

  Widget _locationBtn(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            color: AppColor.dropShadowColor,
          ),
        ],
      ),
      child: IconButton(
        onPressed: () => context.read<MapCubit>().viewRouteTaken(),
        iconSize: 32.0,
        color: AppColor.primaryColor,
        icon: const Icon(Icons.my_location_rounded),
      ),
    );
  }

  Widget _cameraBtn(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            color: AppColor.dropShadowColor,
          ),
        ],
      ),
      child: IconButton(
        onPressed: () => _showPhotoSelection(context),
        iconSize: 32.0,
        color: AppColor.primaryColor,
        icon: const Icon(Icons.camera_alt_outlined),
      ),
    );
  }

  Widget _photoSelectionItem({
    required String title,
    required IconData iconData,
    Color? iconColor,
    required void Function() onTap,
  }) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: AppStyle.horizontalPadding,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppStyle.horizontalPadding,
      ),
      iconColor: iconColor ?? Colors.grey.shade500,
      leading: Icon(
        iconData,
        size: 28.0,
      ),
      title: Text(
        title,
        style: AppStyle.heading_2(),
      ),
    );
  }

  Future<void> _showPhotoSelection(BuildContext context) {
    return showModalBottomSheet<void>(
      constraints: const BoxConstraints(
        minHeight: 200.0,
      ),
      backgroundColor: AppColor.backgroundColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppStyle.borderRadius),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppStyle.horizontalPadding,
            vertical: 4.0,
          ),
          child: Column(
            children: [
              _photoSelectionItem(
                onTap: () async {
                  Navigator.pop<void>(context);
                },
                title: "Choose from library",
                iconData: Icons.photo_outlined,
              ),
              _photoSelectionItem(
                onTap: () {
                  Navigator.pop<void>(context);
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const CameraPage()),
                  );
                },
                title: "Take picture",
                iconData: Icons.camera_alt_outlined,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _photoListView(MapSuccess state) {
    final photos = state.photos;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0
      ),
      itemCount: 5,
      itemBuilder: (context, index) {
        // final photo = photos[index];
        return Card(
          margin: const EdgeInsets.only(top: 20),
          clipBehavior: Clip.hardEdge,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              debugPrint('Card tapped.');
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                    imageUrl: "http://via.placeholder.com/350x150",
                    width: 100,
                    height: 100,
                    filterQuality: FilterQuality.high,
                    progressIndicatorBuilder: (context, url, downloadProgress) => 
                            CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "The CachedNetworkImage can be used directly or through the ImageProvider. Both the CachedNetworkImage as CachedNetworkImageProvider have minimal support for web. It currently doesn't include caching.",
                      style: AppStyle.paragraph(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  void _showPhotosTaken(BuildContext context, MapSuccess state) {
    final size = MediaQuery.of(context).size;
    _btmSheetController = Scaffold.of(context).showBottomSheet<void>(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        maxHeight: size.height,
      ),
      backgroundColor: Colors.yellow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.0),
        ),
      ),
      (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            closeBtn(() {
              Navigator.pop(context);
            }),
            Expanded(
              child: _photoListView(state)
            ),
          ],
        );
      },
    );
  }

  Widget _photoBtn(BuildContext context, MapSuccess state) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            color: AppColor.dropShadowColor,
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {
          _btmSheetController == null 
              ? _showPhotosTaken(context, state) 
              : Navigator.pop<void>(context);
        },
        iconSize: 32.0,
        color: AppColor.primaryColor,
        icon: const Icon(Icons.photo_library_outlined),
      ),
    );
  }

  Widget _photosVisibility(BuildContext context, MapSuccess state) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            color: AppColor.dropShadowColor,
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {

        },
        iconSize: 32.0,
        color: AppColor.primaryColor,
        icon: const Icon(Icons.visibility_rounded),
      ),
    );
  }

  Widget _mainSection(BuildContext context, MapSuccess state) {
    return Stack(
      children: [
        _googleMapWidget(
          context: context,
          polylines: state.polylines,
          markers: state.markers,
        ),
        Align(
          alignment: const Alignment(0.9, -0.9),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _locationBtn(context),
              const SizedBox(height: 12.0),
              _photoBtn(context, state),
              const SizedBox(height: 12.0),
              _cameraBtn(context),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.get(
        title: "",
        leading: backBtn(() => Navigator.pop(context)),
      ),
      body: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          if(state is MapSuccess) {
            return _mainSection(context, state);
          }
          return const SizedBox();
        },
      ),
    );
  }
}
