import 'package:flutter/material.dart';

import 'package:ccquarters/common/widgets/always_visible_label.dart';

class IconOptionCombo extends StatefulWidget {
  const IconOptionCombo({
    Key? key,
    this.iconsSize,
    this.children,
    this.background,
    this.foreground,
  }) : super(key: key);

  final double? iconsSize;
  final Color? background;
  final Color? foreground;
  final List<Widget>? children;

  @override
  State<IconOptionCombo> createState() => _IconOptionComboState();
}

class _IconOptionComboState extends State<IconOptionCombo> {
  final _layerLink = LayerLink();
  OverlayEntry? overlayEntry;
  bool isOpened = false;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        children: [
          _buildDropdownButton(context),
        ],
      ),
    );
  }

  Widget _buildOptions(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.deferToChild,
      onPointerUp: (details) {
        setState(() {
          _hideOverlay();
        });
      },
      child: Column(
        children: widget.children ?? [],
      ),
    );
  }

  Widget _buildDropdownButton(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      iconSize: widget.iconsSize,
      visualDensity: VisualDensity.compact,
      onPressed: () {
        setState(() {
          if (overlayEntry == null) {
            createOverlay(context);
          } else {
            _hideOverlay();
          }
        });
      },
      icon: Icon(
        isOpened ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        color: !isOpened && widget.foreground != null
            ? widget.foreground
            : Colors.white,
        size: widget.iconsSize ?? 16,
        shadows: [
          Shadow(blurRadius: 32, color: widget.background ?? Colors.black54)
        ],
      ),
    );
  }

  Widget _buildDropdown(BuildContext context) {
    return AlwaysVisibleLabel(
      stretch: false,
      borderRadius: BorderRadius.circular(24),
      background: Colors.transparent,
      padding: EdgeInsets.zero,
      child: AnimatedContainer(
        onEnd: () {
          if (!isOpened) {
            _removeOverlay();
          }
        },
        duration: const Duration(milliseconds: 200),
        color:
            isOpened ? widget.background ?? Colors.black54 : Colors.transparent,
        child: AnimatedSize(
          alignment: Alignment.topRight,
          reverseDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 200),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDropdownButton(context),
              if (isOpened) _buildOptions(context),
            ],
          ),
        ),
      ),
    );
  }

  void createOverlay(BuildContext context) {
    overlayEntry = OverlayEntry(
      builder: (context) => IconButtonTheme(
        data: IconButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            foregroundColor: MaterialStateProperty.all<Color>(
              widget.foreground ?? Colors.white,
            ),
            visualDensity: VisualDensity.compact,
            iconSize: MaterialStateProperty.all<double>(
              widget.iconsSize ?? 16,
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.zero,
            ),
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: (details) {
                  _hideOverlay();
                },
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              followerAnchor: Alignment.topLeft,
              targetAnchor: Alignment.topLeft,
              child: Align(
                alignment: Alignment.topLeft,
                child: _buildDropdown(context),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOverlay();
    });
  }

  void _showOverlay() {
    setState(() {
      isOpened = true;
      overlayEntry?.markNeedsBuild();
    });
  }

  void _hideOverlay() {
    setState(() {
      isOpened = false;
      overlayEntry?.markNeedsBuild();
    });
  }

  void _removeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }
}
