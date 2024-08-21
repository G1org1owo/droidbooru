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

  void _onScaleStart(ScaleStartDetails details) {
      _previousScale = _matrix.getMaxScaleOnAxis();
      if(details.pointerCount == 2) {
        _origin = _calculateOrigin(_previousScale, details.focalPoint);
      }

      widget._onScaleStart?.call(details);
  }
  void _onScaleUpdate(ScaleUpdateDetails details) {
      if(details.pointerCount == 1) {
        _applyPan(details.focalPointDelta);
        return;
      }

      if(details.pointerCount > 2) return;

      /* TODO: if widget._maxScale is 0, allow infinite zooming or up to 1.5x
               the screen size relative to the smallest dimension of the image
      */
      double newScale = _previousScale * details.scale;
      if(newScale > widget._maxScale) {
        newScale = widget._maxScale;
      } else if (newScale < widget._minScale) {
        newScale = widget._minScale;
      }

      _applyScale(newScale, _origin!);

      widget._onScaleUpdate?.call(ScaleUpdateDetails(
        focalPoint: details.focalPoint,
        localFocalPoint: details.localFocalPoint,
        scale: newScale,
        rotation: details.rotation,
        pointerCount: details.pointerCount,
        focalPointDelta: details.focalPoint,
        sourceTimeStamp: details.sourceTimeStamp
      ));
  }
  void _onScaleEnd(ScaleEndDetails details) {
      _previousScale = 0;
      if(details.pointerCount == 0) {
        // TODO: add velocity-based panning when releasing the drag
        _origin = null;
      }
      widget._onScaleEnd?.call(details);
  }

  void _onDoubleTapDown(TapDownDetails details) {
      double scale = _matrix.getMaxScaleOnAxis() % widget._maxScale + widget._minScale;

      // TODO: add zoom-in animation for double tap
      _applyScale(
        scale,
        _calculateOrigin(scale, details.localPosition),
      );
  }

  Offset _calculateOrigin(double scale, Offset focalPoint) {
    Size screenSize = MediaQuery.sizeOf(context);
    Size renderedSize = _getRenderedSize(
        screenSize,
        Size(post.width.toDouble(), post.height.toDouble())
    );

    double dx = renderedSize.width * scale >= screenSize.width ?
      focalPoint.dx : screenSize.width/2;

    double dy = renderedSize.height * scale >= screenSize.height ?
      focalPoint.dy : screenSize.height/2;

    return Offset(dx, dy);
  }
  Size _getRenderedSize(Size containerSize, Size imageSize) {
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
  Matrix4 _recalculateOffset(double scale, Matrix4 matrix, Size screenSize, Size renderedSize) {
    Matrix4 newMatrix = matrix.clone();

    // If the previous calculations end up not being centered, fix the offset
    // to avoid zooming towards the black bars (this is the only reason
    // I had to rewrite InteractiveViewer from scratch)
    if (renderedSize.width/2 * scale + newMatrix.row0.w <= renderedSize.width/2) {
      newMatrix.setEntry(0, 3, (renderedSize.width - renderedSize.width * scale) / 2);
    } else if (-renderedSize.width/2 * scale + newMatrix.row0.w >= -renderedSize.width/2) {
      newMatrix.setEntry(0, 3, (renderedSize.width * scale - renderedSize.width) / 2);
    } else if (renderedSize.width/2 * scale + newMatrix.row0.w <= screenSize.width/2) {
      newMatrix.setEntry(0, 3, 0.0);
    }

    if (renderedSize.height/2 * scale + newMatrix.row1.w <= renderedSize.height/2) {
      newMatrix.setEntry(1, 3, (renderedSize.height - renderedSize.height * scale) / 2);
    } else if (-renderedSize.height/2 * scale + newMatrix.row1.w >= -renderedSize.height/2) {
      newMatrix.setEntry(1, 3, (renderedSize.height * scale - renderedSize.height) / 2);
    } else if (renderedSize.height/2 * scale + newMatrix.row1.w <= screenSize.height/2) {
      newMatrix.setEntry(1, 3, 0.0);
    }

    return newMatrix;
  }

  void _applyScale(double newScale, Offset origin) async {
    Size screenSize = MediaQuery.sizeOf(context);
    Size renderedSize = _getRenderedSize(
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

    newMatrix = _recalculateOffset(newScale, newMatrix, screenSize, renderedSize);

    setState(() {
      _matrix = newMatrix;
    });
  }
  void _applyPan(Offset delta) {
    Matrix4 newMatrix = _matrix.clone();

    newMatrix.setEntry(0, 3, _matrix.row0.w + delta.dx);
    newMatrix.setEntry(1, 3, _matrix.row1.w + delta.dy);

    Size screenSize = MediaQuery.sizeOf(context);
    Size renderedSize = _getRenderedSize(
        screenSize,
        Size(post.width.toDouble(), post.height.toDouble())
    );

    double scale = _matrix.getMaxScaleOnAxis();

    newMatrix = _recalculateOffset(scale, newMatrix, screenSize, renderedSize);

    setState(() {
      _matrix = newMatrix;
    });
  }
}