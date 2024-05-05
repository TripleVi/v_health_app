import "package:bottom_sheet/bottom_sheet.dart" as bs;
import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";


import "../../../../core/resources/style.dart";
import "../../../../domain/entities/photo.dart";
import "../../../../domain/entities/post.dart";
import "../../../widgets/image_page.dart";
import "../../../widgets/app_bar.dart";
import "../../../widgets/loading_indicator.dart";
import "../cubit/map_cubit.dart";

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)!.settings.arguments as Post;
    return BlocProvider<MapCubit>(
      create: (context) => MapCubit(post),
      child: const MapView(),
    );
  }
}

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.get(title: "Route taken"),
      backgroundColor: AppStyle.backgroundColor,
      body: BlocConsumer<MapCubit, MapState>(
        listener: (context, state) {
          if(state is MapStateLoaded && state.photoTapped != null) {
            _openImageView(context, state.photoTapped!);
          }
        },
        builder: (context, state) {
          if(state is MapStateLoading) {
            return const AppLoadingIndicator();
          }
          if(state is MapStateError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning_rounded, 
                    size: 68.0, 
                    color: AppStyle.primaryColor,
                  ),
                  Text("Oops, something went wrong!", style: AppStyle.caption1()),
                ],
              ),
            );
          }
          if(state is MapStateLoaded) {
            return _mainSection(context, state);
          }
          return const SizedBox();
        },
      ) ,
    );
  }

  Widget _mainSection(BuildContext context, MapStateLoaded state) {
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
              _photoGalleryBtn(context, state),
              const SizedBox(height: 12.0),
              _photoVisibilityBtn(context, state)
            ],
          ),
        ),
      ],
    );
  }

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
      onMapCreated: context.read<MapCubit>().onMapCreated,
    );
  }

  Widget _locationBtn(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            color: AppStyle.dropShadowColor,
          ),
        ],
      ),
      child: IconButton(
        onPressed: context.read<MapCubit>().viewRouteTaken,
        iconSize: 24.0,
        color: AppStyle.primaryColor,
        icon: const Icon(Icons.my_location_rounded),
      ),
    );
  }

  Widget _photoVisibilityBtn(BuildContext context, MapStateLoaded state) {
    return Container(
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            color: AppStyle.dropShadowColor,
          ),
        ],
      ),
      child: IconButton(
        onPressed: context.read<MapCubit>().toggleMarkersVisible,
        iconSize: 24.0,
        color: AppStyle.primaryColor,
        icon: state.markersVisible 
            ? const Icon(Icons.visibility_rounded)
            : const Icon(Icons.visibility_off_rounded)
      ),
    );
  }

  Widget _photoGalleryBtn(BuildContext context, MapStateLoaded state) {
    return Container(
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            color: AppStyle.dropShadowColor,
          ),
        ],
      ),
      child: IconButton(
        onPressed: () => _showPhotos(context, state),
        iconSize: 24.0,
        color: AppStyle.primaryColor,
        icon: const Icon(Icons.photo_library_outlined),
      ),
    );
  }

  void _showPhotos(BuildContext mapContext, MapStateLoaded state) async {
    await bs.showFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.5,
      maxHeight: 1,
      isModal: false,
      bottomSheetBorderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppStyle.borderRadius),
      ),
      bottomSheetColor: AppStyle.surfaceColor,
      context: mapContext,
      anchors: [0, 0.5, 1],
      isSafeArea: true,
      useRootScaffold: false,
      builder: (context, scrollController, bottomSheetOffset) {
        final size = MediaQuery.of(context).size;
        final photos = state.photos;
        return SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                color: AppStyle.surfaceColor,
                child: const Icon(
                  Icons.grid_on_outlined, 
                  size: 24.0, 
                  color: AppStyle.secondaryIconColor,
                ),
              ),
              SizedBox(
                height: bottomSheetOffset * (size.height-32-16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 0.0,
                    mainAxisSpacing: 0.0,
                    crossAxisCount: 3,
                  ),
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    return _buildGridViewItem(
                      context: context, 
                      photo: photos[index], 
                      mapContext: mapContext,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGridViewItem({
    required BuildContext context, 
    required BuildContext mapContext,
    required Photo photo, 
  }) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: () {
              _openImageView(context, photo);
            },
            child: CachedNetworkImage(
              imageUrl: photo.photoUrl,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              progressIndicatorBuilder: (context, url, download) => Center(
                child: CircularProgressIndicator(value: download.progress)
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        Positioned(
          top: 4.0,
          right: 4.0,
          child: GestureDetector(
            onTap: () => mapContext.read<MapCubit>().showPhotoLocation(photo),
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                color: AppStyle.pBtnTextColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on,
                color: AppStyle.pBtnBgColor,
                size: 18.0,
              ),
            ),
          ),
        )
      ],
    );
  }

  void _openImageView(BuildContext context, Photo photo) {
    Navigator.push<void>(context, MaterialPageRoute(
      builder: (context) => ImageView(
        url: photo.photoUrl,
        onEdited: (originalFile, editedBytes) {},
        onDelete: () {
          // context.read<MapCubit>().deletePhoto();
        },
        onSave: () {},
      ),
    ));
  }
}
