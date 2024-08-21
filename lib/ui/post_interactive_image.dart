import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import '../model/base/post.dart';

class PostInteractiveImage extends StatefulWidget {
  final Post _post;
  final BoxFit _fit;
  final double _minScale;
  final double _maxScale;

  final void Function(ScaleStartDetails)? _onScaleStart;
  final void Function(ScaleUpdateDetails)? _onScaleUpdate;
  final void Function(ScaleEndDetails)? _onScaleEnd;

  const PostInteractiveImage({required Post post, BoxFit fit = BoxFit.none,
    double minScale = 1.0, double maxScale = 1.5,
    void Function(ScaleStartDetails)? onScaleStart,
    void Function(ScaleUpdateDetails)? onScaleUpdate,
    void Function(ScaleEndDetails)? onScaleEnd, super.key}) :
        _post = post,
        _fit = fit,
        _minScale = minScale,
        _maxScale = maxScale,
        _onScaleStart = onScaleStart,
        _onScaleUpdate = onScaleUpdate,
        _onScaleEnd = onScaleEnd;

  @override
  State<StatefulWidget> createState() => _PostInteractiveImageState();
}

class _PostInteractiveImageState extends State<PostInteractiveImage> {
  Matrix4 _matrix = Matrix4.diagonal3(Vector3.all(1));
  double _previousScale = 0;
  Offset? _origin;

  Post get post => widget._post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      onDoubleTapDown: _onDoubleTapDown,
      child: Transform(
        transform: _matrix,
        alignment: FractionalOffset.center,
        child: FadeInImage(
          placeholder: NetworkImage(post.previewUrl),
          image: NetworkImage(post.sampleUrl),
          fit: widget._fit,
          fadeOutDuration: const Duration(milliseconds: 5),
          fadeInDuration: const Duration(milliseconds: 5),
        ),
      ),
    );
  }

  void _onScaleStart(details) {
      _previousScale = _matrix.getMaxScaleOnAxis();
      if(details.pointerCount == 2) {
        _origin = calculateOrigin(_previousScale, details.focalPoint);
      }

      widget._onScaleStart?.call(details);
    }

  void _onScaleUpdate(details) {
      if(details.pointerCount != 2) return;

      double newScale = _previousScale * details.scale;
      if(newScale > widget._maxScale) {
        newScale = widget._maxScale;
      } else if (newScale < widget._minScale) {
        newScale = widget._minScale;
      }

      applyScale(newScale, _origin!);
      widget._onScaleUpdate?.call(details);
    }

  void _onScaleEnd(details) {
      _previousScale = 0;
      if(details.pointerCount == 0) {
        _origin = null;
      }
      widget._onScaleEnd?.call(details);
    }

  void _onDoubleTapDown(details) {
      double scale = _matrix.getMaxScaleOnAxis() % widget._maxScale + widget._minScale;

      // TODO: add zoom-in animation for double tap
      applyScale(
        scale,
        calculateOrigin(scale, details.localPosition),
      );
    }

  Offset calculateOrigin(double scale, Offset focalPoint) {
    Size screenSize = MediaQuery.sizeOf(context);
    Size renderedSize = getRenderedSize(
        screenSize,
        Size(post.width.toDouble(), post.height.toDouble())
    );

    double dx = renderedSize.width * scale >= screenSize.width ?
      focalPoint.dx : screenSize.width/2;

    double dy = renderedSize.height * scale >= screenSize.height ?
      focalPoint.dy : screenSize.height/2;

    return Offset(dx, dy);
  }

  Size getRenderedSize(Size containerSize, Size imageSize) {
    double renderedWidth = 0;
    double renderedHeight = 0;

    if((imageSize.aspectRatio > containerSize.aspectRatio)) {
      renderedWidth = containerSize.width;
      renderedHeight = containerSize.width / imageSize.aspectRatio;
    } else {
      renderedWidth = containerSize.height * imageSize.aspectRatio;
      renderedHeight = containerSize.height;
    }

    return Size(renderedWidth, renderedHeight);
  }

  void applyScale(double newScale, Offset origin) async {
    Size screenSize = MediaQuery.sizeOf(context);
    Size renderedSize = getRenderedSize(
        screenSize,
        Size(post.width.toDouble(), post.height.toDouble())
    );

    origin = Offset(
      screenSize.width/2 - origin.dx,
      screenSize.height/2 - origin.dy
    );

    double previousScale = _matrix.getMaxScaleOnAxis();

    // Several matrix operations pre-multiplied to cut down on elaboration costs
    // In order:
    // - translate by -origin.dx, -origin.dy;
    // - scale by 1/previousScale
    // - scale by newScale
    // - translate by origin.dx, origin.dy
    //
    // Here be dragons:
    Matrix4 newMatrix = _matrix.clone()
      ..multiply(Matrix4(
        newScale/previousScale, 0, 0, 0,
        0, newScale/previousScale, 0, 0,
        0, 0, newScale/previousScale, 0,
        origin.dx * newScale/previousScale - origin.dx, 0, 0, 1
      ));

    // If the previous calculations end up not being centered, fix the offset
    // to avoid zooming towards the black bars (this is the only reason
    // I had to rewrite InteractiveViewer from scratch)
    if (renderedSize.width/2 * newScale + newMatrix.row0.w <= renderedSize.width/2) {
      newMatrix.setEntry(0, 3, (renderedSize.width - renderedSize.width * newScale) / 2);
    } else if (-renderedSize.width/2 * newScale + newMatrix.row0.w >= -renderedSize.width/2) {
      newMatrix.setEntry(0, 3, (renderedSize.width * newScale - renderedSize.width) / 2);
    } else if (renderedSize.width/2 * newScale + newMatrix.row0.w <= screenSize.width/2) {
      newMatrix.setEntry(0, 3, 0.0);
    }

    if (renderedSize.height/2 * newScale + newMatrix.row1.w <= renderedSize.height/2) {
      newMatrix.setEntry(1, 3, (renderedSize.height - renderedSize.height * newScale) / 2);
    } else if (-renderedSize.height/2 * newScale + newMatrix.row1.w >= -renderedSize.height/2) {
      newMatrix.setEntry(1, 3, (renderedSize.height * newScale - renderedSize.height) / 2);
    } else if (renderedSize.height/2 * newScale + newMatrix.row1.w <= screenSize.height/2) {
      newMatrix.setEntry(1, 3, 0.0);
    }

    setState(() {
      _matrix = newMatrix;
    });
  }
}