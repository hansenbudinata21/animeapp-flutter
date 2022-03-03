import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double maxHeight;
  final Color linkColor;

  const ExpandableText({
    Key? key,
    required this.text,
    required this.style,
    required this.maxHeight,
    required this.linkColor,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> with TickerProviderStateMixin<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
            height: isExpanded ? 750.h : widget.maxHeight,
            duration: const Duration(milliseconds: 250),
            child: Text(
              widget.text,
              style: widget.style,
              softWrap: true,
              overflow: TextOverflow.fade,
            )),
        GestureDetector(
          onTap: () => setState(() {
            isExpanded = !isExpanded;
          }),
          child: Container(
            margin: EdgeInsets.only(top: 50.h),
            child: Text(
              isExpanded ? "show less..." : "show more...",
              style: widget.style.copyWith(color: widget.linkColor),
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
          ),
        )
      ],
    );
  }
}
