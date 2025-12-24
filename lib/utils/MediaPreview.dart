import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:typed_data';

class MediaPreview extends StatefulWidget {
  final String url;
  final double width;
  final double height;
  final bool isVideo;

  const MediaPreview({
    required this.url,
    required this.width,
    required this.height,
    this.isVideo = false,
    Key? key,
  }) : super(key: key);

  @override
  State<MediaPreview> createState() => _MediaPreviewState();
}

class _MediaPreviewState extends State<MediaPreview> {
  Uint8List? thumbnail;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _generateThumbnail();
    } else {
      loading = false;
    }
  }

  Future<void> _generateThumbnail() async {
    try {
      final thumb = await VideoThumbnail.thumbnailData(
        video: widget.url,
        imageFormat: ImageFormat.JPEG,
        maxWidth: widget.width.toInt(),
        quality: 75,
      );
      if (mounted) {
        setState(() {
          thumbnail = thumb;
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (loading) {
      child = Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[300],
      );
    } else if (widget.isVideo && thumbnail != null) {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.memory(
          thumbnail!,
          width: widget.width,
          height: widget.height,
          fit: BoxFit.fill,
        ),
      );
    } else {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          widget.url,
          width: widget.width,
          height: widget.height,
          fit: BoxFit.fill,
          errorBuilder: (c, o, s) {
            return Image.asset(
              "assets/images/common/ic_message_no.png",
              width: widget.width,
              height: widget.height,
              fit: BoxFit.fill,
            );
          },
        ),
      );
    }

    return child;
  }
}
