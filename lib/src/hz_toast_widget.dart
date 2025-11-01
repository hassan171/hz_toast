import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hz_toast/hz_toast.dart';

class HzToastWidget extends StatelessWidget {
  final double? topSpacing;
  final double? spacing;
  const HzToastWidget({super.key, this.topSpacing, this.spacing});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return ValueListenableBuilder<List<HzToastData>>(
      valueListenable: HzToast.toasts,
      builder: (context, toasts, child) {
        return Stack(
          children: [
            for (int i = 0; i < toasts.length; i++)
              AnimatedPositioned(
                key: ValueKey('position_${toasts[i].id}'),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                // top: (topSpacing ?? 20) + (i * 50),
                top: (topSpacing ?? 20) +
                    toasts.sublist(0, i).fold<double>(
                          0,
                          (previousValue, element) =>
                              previousValue +
                              (spacing ?? 0) + //default vertical padding
                              (element.margin?.vertical ?? 0) +
                              48, //approx height of each toast
                        ),
                right: 0,
                child: _AnimatedToast(
                  key: ValueKey(toasts[i].id),
                  data: toasts[i],
                  width: width,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _AnimatedToast extends StatefulWidget {
  final HzToastData data;
  final double width;

  const _AnimatedToast({super.key, required this.data, required this.width});

  @override
  State<_AnimatedToast> createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<_AnimatedToast> {
  bool _visible = false;
  bool _exiting = false;
  late final StreamSubscription<String> _removeSub;

  //if auto hide is enabled, start a timer to hide the toast and also update the progress bar
  final Stopwatch _stopwatch = Stopwatch();
  final ValueNotifier<double> _progress = ValueNotifier<double>(1.0);

  @override
  void initState() {
    super.initState();

    // Start the stopwatch
    if (widget.data.autoHide) {
      _stopwatch.start();
      Timer.periodic(const Duration(milliseconds: 10), (timer) {
        if (!mounted || _exiting) {
          timer.cancel();
          return;
        }
        if (_stopwatch.elapsed >= widget.data.duration) {
          timer.cancel();
          _startExitAnimation();
        } else {
          _progress.value = 1.0 - (_stopwatch.elapsed.inMilliseconds / widget.data.duration.inMilliseconds);
        }
      });
    }

    // Start entry animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
    });

    // Listen for removal
    _removeSub = HzToast.onRemove.listen((id) {
      if (id == widget.data.id && mounted) _startExitAnimation();
    });
  }

  void _startExitAnimation() {
    if (_exiting) return;
    setState(() {
      _exiting = true;
      _visible = false;
    });

    // Wait for animation to complete before removing
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        HzToast.toasts.value = HzToast.toasts.value.where((t) => t.id != widget.data.id).toList();
        widget.data.onClose?.call();
      }
    });
  }

  @override
  void dispose() {
    _removeSub.cancel();
    _stopwatch.stop();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offset = _visible ? Offset.zero : const Offset(1.0, 0.0);
    final opacity = _visible ? 1.0 : 0.0;

    return AnimatedSlide(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      offset: offset,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: opacity,
        child: Stack(
          children: [
            _ToastBody(width: widget.width, data: widget.data),

            //a bar that shows the time running out
            if (widget.data.showProgressBar && widget.data.autoHide)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: ValueListenableBuilder<double>(
                      valueListenable: _progress,
                      builder: (context, value, child) {
                        return LinearProgressIndicator(
                          value: widget.data.autoHide ? value : null,
                          valueColor: AlwaysStoppedAnimation(widget.data.progressBarColor ?? widget.data.type.iconColor),
                          backgroundColor: Colors.transparent,
                          minHeight: 4,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ToastBody extends StatelessWidget {
  final double width;
  final HzToastData data;

  const _ToastBody({required this.width, required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.clickable
          ? () {
              data.onTap?.call();
              HzToast.hide(data.id);
            }
          : null,
      child: Container(
        constraints: BoxConstraints(maxWidth: width * data.maxWidth.clamp(0.0, 1.0)),
        margin: data.margin,
        padding: data.padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: data.decoration ??
            BoxDecoration(
              color: data.backgroundColor ?? Colors.white,
              borderRadius: data.borderRadius ?? const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 8, offset: const Offset(0, 2))],
            ),
        child: Row(
          spacing: data.spacing ?? 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (data.showIcon)
              data.iconBuilder?.call(data.iconColor ?? data.type.iconColor) ??
                  Icon(data.icon ?? data.type.defaultIcon, color: data.iconColor ?? data.type.iconColor),
            data.titleBuilder?.call(data.message, data.textColor ?? data.type.textColor) ??
                Flexible(child: Text(data.message, style: TextStyle(fontWeight: FontWeight.w500, color: data.textColor ?? data.type.textColor))),
            if (data.showCloseIcon)
              data.closeIconBuilder?.call(data.closeIconColor ?? data.type.closeIconColor) ??
                  Icon(data.closeIcon ?? Icons.close, color: data.closeIconColor ?? data.type.closeIconColor),
          ],
        ),
      ),
    );
  }
}
