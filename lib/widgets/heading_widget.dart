import 'package:e_comm/utils/app_constant.dart';
import 'package:flutter/material.dart';

class HeadingWidget extends StatefulWidget {
  final String headingTitle;
  final String headingSubTitle;
  final VoidCallback onTap;
  final String buttonText;

  const HeadingWidget({
    super.key,
    required this.headingTitle,
    required this.headingSubTitle,
    required this.onTap,
    required this.buttonText,
  });

  @override
  _HeadingWidgetState createState() => _HeadingWidgetState();
}

class _HeadingWidgetState extends State<HeadingWidget> {
  bool isPressed = false; // State to track button press

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.headingTitle,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                widget.headingSubTitle,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTapDown: (_) {
              setState(() {
                isPressed = true;
              });
            },
            onTapUp: (_) {
              setState(() {
                isPressed = false;
              });
              widget.onTap(); // Execute the actual function
            },
            onTapCancel: () {
              setState(() {
                isPressed = false;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              transform: Matrix4.diagonal3Values(
                isPressed ? 0.9 : 1.0, // Shrinks when pressed
                isPressed ? 0.9 : 1.0,
                1.0,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.lightBlue.shade300.withOpacity(
                      isPressed ? 0.8 : 1.0,
                    ),
                    Colors.blueAccent.withOpacity(isPressed ? 0.8 : 1.0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(isPressed ? 0.8 : 0.5),
                    blurRadius: isPressed ? 20 : 3,
                    spreadRadius: isPressed ? 5 : 2,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.buttonText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 6.0),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14.0,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
