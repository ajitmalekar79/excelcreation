import 'package:flutter/material.dart';

import 'AppColors.dart';
import 'text_styles.dart';

class AppButtons {
  static circularButton(
          {Function onTap,
          String title,
          double heigth,
          double wigth,
          TextStyle textStyle}) =>
      FlatButton(
          onPressed: onTap,
          color: AppColors.appTheame,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
          height: heigth,
          minWidth: wigth,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: textStyle ?? TextStyles.buttontitle,
          ));

  static circularNormalButton(
          {Function onTap,
          String title,
          double heigth,
          double wigth,
          @required double radius,
          TextStyle textStyle}) =>
      FlatButton(
          onPressed: onTap,
          color: AppColors.appTheame,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
          height: heigth,
          minWidth: wigth,
          child: Text(
            title,
            style: textStyle ?? TextStyles.buttontitle,
          ));

  static circularWhiteButton(
          {Function onTap,
          String title,
          Widget icon,
          double heigth,
          double wigth,
          @required double radius,
          TextStyle textStyle}) =>
      FlatButton(
          onPressed: onTap,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: BorderSide(color: AppColors.appTheame)),
          height: heigth,
          minWidth: wigth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Container(margin: EdgeInsets.only(right: 5), child: icon),
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: textStyle ?? TextStyles.text18B4,
              ),
            ],
          ));

  static tabBarButton(
          {Function onTap,
          String title,
          double heigth,
          double wigth,
          bool isSelected,
          TextStyle textStyle}) =>
      RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 20),
          onPressed: onTap,
          color: isSelected == true ? AppColors.appTheame : AppColors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            // side: BorderSide(color: AppColors.appTheame)
          ),
          elevation: isSelected == true ? 5 : 0,
          // height: heigth,
          // minWidth: wigth,
          child: Text(title,
              overflow: TextOverflow.ellipsis,
              style: isSelected == true
                  ? TextStyles.text14W7
                  : TextStyles.text14B7));
}
