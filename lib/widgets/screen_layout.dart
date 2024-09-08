import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ScreenLayout extends StatelessWidget {
  final Widget child;
  final bool useCardStyle;

  const ScreenLayout({
    Key? key,
    required this.child,
    this.useCardStyle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 50),
            Expanded(
              child: useCardStyle
                  ? Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x40000000),
                            offset: Offset(0, -6),
                            blurRadius: 20.0499992371,
                          ),
                        ],
                      ),
                      child: child,
                    )
                  : child,
            ),
          ],
        ),
      ),
    );
  }
}
