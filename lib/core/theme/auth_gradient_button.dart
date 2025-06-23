import 'package:blogpost_colln/core/theme/app_pallet.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget{
  final String buttonText;
  final VoidCallback onPressed;
const AuthGradientButton({
  super.key,
  required this.buttonText,
  required this.onPressed,
});

@override
Widget build(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppPallete.gradient1,
          AppPallete.gradient2,
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ),
      borderRadius: BorderRadius.circular(7.0),
    ),
    child: ElevatedButton(onPressed:onPressed,
    style:ElevatedButton.styleFrom(
      fixedSize:const Size(400,50),
      backgroundColor: AppPallete.transparentColor,
      shadowColor: AppPallete.transparentColor,
      
    
    ),
    child:Text(buttonText,
    style:const TextStyle(
      fontSize:17,
      fontWeight: FontWeight.w600,
    )),
    ),
  );
}
}
